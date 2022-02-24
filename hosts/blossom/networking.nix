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
    nameservers = [ "192.168.100.15" ];

    extraHosts = ''
      192.168.100.12 strawberry
      192.168.100.15 caramel

      10.100.0.1     sugarcane
    '';
  };
}
