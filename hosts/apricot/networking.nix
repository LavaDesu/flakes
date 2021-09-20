{ config, ... }: {
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa_conf.path;
  networking = {
    wireless = {
      enable = true;
      interfaces = [ "wlp1s0" ];
    };

    useDHCP = false;
    interfaces.enp2s0.useDHCP = false;
    interfaces.wlp1s0.useDHCP = false;

    interfaces.enp2s0.ipv4.addresses = [{
      address = "10.0.0.1";
      prefixLength = 24;
    }];
    interfaces.wlp1s0.ipv4.addresses = [{
      address = "192.168.100.14";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.100.1";
    nameservers = [ "8.8.8.8" ];

    extraHosts = ''
      192.168.100.10 strawberry
      192.168.100.11 peach
      192.168.100.12 butterfly
      192.168.100.13 winter
      192.168.100.14 apricot
    '';
  };
}
