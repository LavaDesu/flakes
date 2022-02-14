{ config, lib, pkgs, ... }:
let
  dom = "lava.moe";
  sub = "matrix.lava.moe";
  dir = "/persist/matrix-synapse";
  uid = toString config.ids.uids.matrix-synapse;
  gid = toString config.ids.gids.matrix-synapse;
in {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  systemd.tmpfiles.rules = [ "d ${dir} 700 ${uid} ${gid}" ];

  /*services.postgresql = {
    ensureDatabases = [ "matrix-synapse" ];
    ensureUsers = [{
      name = "matrix-synapse";
      ensurePermissions = {
        "DATABASE matrix-synapse" = "ALL PRIVILEGES";
      };
    }];
  };*/
  # TODO this would be bad if we use postgres for other things too
  services.postgresql.initialScript = pkgs.writeText "synapse-init.sql" ''
    CREATE ROLE "matrix-synapse" WITH LOGIN PASSWORD 'synapse';
    CREATE DATABASE "matrix-synapse" WITH OWNER "matrix-synapse"
      TEMPLATE template0
      LC_COLLATE = "C"
      LC_CTYPE = "C";
  '';

  services.nginx = {
    virtualHosts = {
      ${dom} = {
        locations."= /.well-known/matrix/server".extraConfig =
          let
            server = { "m.server" = "${sub}:443"; };
          in ''
            add_header Content-Type application/json;
            return 200 '${builtins.toJSON server}';
          '';
        locations."= /.well-known/matrix/client".extraConfig =
          let
            client = {
              "m.homeserver" =  { "base_url" = "https://${sub}"; };
              "m.identity_server" =  { "base_url" = "https://vector.im"; };
            };
          in ''
            add_header Content-Type application/json;
            add_header Access-Control-Allow-Origin *;
            return 200 '${builtins.toJSON client}';
          '';
      };

      ${sub} = {
        forceSSL = true;
        useACMEHost = dom;

        locations."/".extraConfig = ''
          return 404;
        '';

        locations."/_matrix" = {
          proxyPass = "http://[::1]:8008";
        };
      };
    };
  };

  services.matrix-synapse = {
    enable = true;
    dataDir = dir;
    server_name = dom;
    listeners = [
      {
        port = 8008;
        bind_address = "::1";
        type = "http";
        tls = false;
        x_forwarded = true;
        resources = [
          {
            names = [ "client" "federation" ];
            compress = false;
          }
        ];
      }
    ];
  };
}
