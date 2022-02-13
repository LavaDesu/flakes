{ config, ... }:
let
  dir = "/persist/postgresql/${config.services.postgresql.package.psqlSchema}";
  uid = config.ids.uids.postgres;
  gid = config.ids.gids.postgres;
in {
  systemd.tmpfiles.rules = [ "d ${dir} 700 ${uid} ${gid}" ];
  services.postgresql = {
    enable = true;
    dataDir = dir;
  };
}
