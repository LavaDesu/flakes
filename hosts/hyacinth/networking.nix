{ config, ... }: {
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa_conf.path;
  networking = {
    useDHCP = true;
    interfaces.enp5s0.useDHCP = false;

    interfaces.enp5s0.ipv4.addresses = [{
      address = "192.168.1.201";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.1.1";
    nameservers = [ "8.8.8.8" "8.8.4.4" ];

    extraHosts = ''
      10.100.0.1     sugarcane
    '';
  };
}
