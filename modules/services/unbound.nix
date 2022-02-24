{ inputs, ... }: {
  networking.firewall.interfaces.wlan0 = {
    allowedUDPPorts = [ 53 ];
    allowedTCPPorts = [ 53 ];
  };
  services.unbound = {
    enable = true;
    stateDir = "/persist/unbound";
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
        access-control = [ "192.168.100.0/24 allow" ];
      };

      include = "${inputs.hosts-blocklists}/unbound/unbound.blacklist.conf";
    };
  };
}
