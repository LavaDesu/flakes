{ config, ... }:
let
  dir = "/persist/postgresql/${config.services.postgresql.package.psqlSchema}";
  uid = toString config.ids.uids.postgres;
  gid = toString config.ids.gids.postgres;
in {
  systemd.tmpfiles.rules = [ "d ${dir} 700 ${uid} ${gid}" ];
  services.postgresql = {
    enable = true;
    dataDir = dir;
  };
}
