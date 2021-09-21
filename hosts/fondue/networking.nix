{ config, ... }: {
  networking = {
    useDHCP = false;
    interfaces.enp2s1.useDHCP = false;

    interfaces.enp2s1.ipv4.addresses = [{
      address = "192.168.100.101";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.100.1";
    nameservers = [ "8.8.8.8" ];

    extraHosts = ''
      10.100.0.2 apricot
      10.100.0.3 winter
    '';
  };
}
