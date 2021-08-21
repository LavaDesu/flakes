{ config, ... }: {
  networking = {
    wireless = {
      enable = true;
      interfaces = [ "wlp3s0" ];
    };

    useDHCP = false;
    interfaces.eno1.useDHCP = false;
    interfaces.wlp3s0.useDHCP = false;

    interfaces.eno1.ipv4.addresses = [{
      address = "10.0.0.2";
      prefixLength = 24;
    }];
    interfaces.wlp3s0.ipv4.addresses = [{
      address = "192.168.100.13";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.100.1";
    nameservers = [ "192.168.100.11" ];
  };
}
