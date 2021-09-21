{ config, ... }: {
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa_conf.path;
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
    nameservers = [ "8.8.8.8" ];

    extraHosts = ''
      192.168.100.10 strawberry
      192.168.100.11 peach
      192.168.100.12 butterfly
      192.168.100.13 winter
      192.168.100.14 apricot

      10.100.0.1     fondue
    '';
  };
}
