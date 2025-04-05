{ config, modules, pkgs, ... }: {
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
}
