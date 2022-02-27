{ config, ... }:
let
  dir = "/persist/vaultwarden";
  user = config.users.users.vaultwarden.name;
  group = config.users.groups.vaultwarden.name;
in {
  systemd.tmpfiles.rules = [
    "d ${dir} 700 ${user} ${group}"
    "d ${dir}_backup 700 ${user} ${group}"
  ];
  services.vaultwarden = {
    backupDir = "${dir}_backup";
    config = {
      dataFolder = dir;
      signupsAllowed = false;
      domain = "warden.local.lava.moe";
      rocketPort = 8002;
    };
    environmentFile = config.age.secrets.warden_admin.path;
  };

  services.nginx.virtualHosts."warden.local.lava.moe" = {
    forceSSL = true;
    useACMEHost = "lava.moe";

    locations."/".proxyPass = "http://[::1]:8002";
  };

  systemd.services.vaultwarden.serviceConfig.ReadWritePaths = [ dir ];
  systemd.services.backup-vaultwarden.environment.DATA_FOLDER = dir;
}
