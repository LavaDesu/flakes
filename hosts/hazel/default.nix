{ config, modules, pkgs, ... }:
let
  dirs = [
    ["immich" "immich"]
    ["nextcloud" "nextcloud"]
    ["postgresql" "postgres"]
    ["redis-immich" "redis-immich"]
  ];

  rules = builtins.map (d: "d /flower/${builtins.elemAt d 0} 750 ${builtins.elemAt d 1} ${builtins.elemAt d 1}") dirs;
  mounts = builtins.listToAttrs (builtins.map (d: {
    name = "/var/lib/${builtins.elemAt d 0}";
    value = {
      depends = [ "/flower" ];
      device = "/flower/${builtins.elemAt d 0}";
      fsType = "none";
      options = [ "bind" ];
    };
  }) dirs);
in
{
  networking.hostName = "hazel";
  system.stateVersion = "24.11";
  time.timeZone = "Australia/Melbourne";

  age.secrets = {
    acme_dns.file = ../../secrets/acme_dns.age;
  };

  imports = with modules.system; with modules.services; [
    home-manager-stable

    base
    kernel
    nginx
    nix-stable
    packages
    security

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/hana
  ];

  me.environment = "headless";

  services.nextcloud = {
    enable = true;
    package = pkgs.nextcloud31;
    hostName = "cloud.lava.moe";
    database.createLocally = true;
    config = {
      dbtype = "pgsql";
      adminpassFile = "/persist/nextcloud-admin-pass";
    };
    https = true;
  };

  services.nginx.virtualHosts.${config.services.nextcloud.hostName} = {
    forceSSL = true;
    enableACME = true;
  };

  services.immich = {
    enable = true;
    port = 2283;
  };

  users.users.immich.extraGroups = [ "video" "render" ];
  hardware.opengl.enable = true;
  services.nginx.virtualHosts."photos.lava.moe" = {
    enableACME = true;
    forceSSL = true;
    locations."/" = {
      proxyPass = "http://[::1]:${toString config.services.immich.port}";
      proxyWebsockets = true;
      recommendedProxySettings = true;
      extraConfig = ''
        client_max_body_size 50000M;
        proxy_read_timeout   600s;
        proxy_send_timeout   600s;
        send_timeout         600s;
      '';
    };
  };

  systemd.tmpfiles.rules = rules;
  fileSystems = mounts;
}
