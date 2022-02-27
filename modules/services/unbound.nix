{ inputs, ... }:
let
  dir = "/persist/unbound";
in {
  networking.firewall.interfaces.wlan0 = {
    allowedUDPPorts = [ 53 853 ];
    allowedTCPPorts = [ 53 853 ];
  };
  systemd.tmpfiles.rules = [ "d ${dir} 700 unbound unbound" ];

  services.unbound = {
    enable = true;
    stateDir = dir;
    settings = {
      forward-zone = [{
        name = ".";
        forward-tls-upstream = true;
        forward-addr = [
          "1.1.1.1@853#cloudflare-dns.com"
          "1.0.0.1@853#cloudflare-dns.com"
        ];
      }];

      server = {
        interface = [ "0.0.0.0" ];
        access-control = [
          "127.0.0.1/8      allow"
          "10.0.0.0/8       allow"
          "192.168.100.0/24 allow"
        ];
      };

      include = "${inputs.hosts-blocklists}/unbound/unbound.blacklist.conf";
    };
  };

  systemd.services.unbound.serviceConfig.ReadWritePaths = [ dir ];
}
