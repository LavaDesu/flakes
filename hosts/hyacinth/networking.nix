{ config, ... }: {
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa_conf.path;
  networking = {
    useDHCP = false;
    interfaces.enp5s0.useDHCP = false;

    interfaces.enp5s0.ipv4.addresses = [{
      address = "192.168.100.16";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.100.1";
    nameservers = [ "1.1.1.1" ];

    extraHosts = ''
      192.168.100.12 strawberry
      192.168.100.15 caramel

      10.100.0.1     sugarcane
    '';
  };
}
