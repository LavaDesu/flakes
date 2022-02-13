{ config, ... }: {
  environment.etc."wpa_supplicant.conf".source = config.age.secrets.wpa_conf.path;
  networking = {
    firewall.allowedTCPPorts = [ 80 443 ];

    wireless = {
      enable = true;
      interfaces = [ "wlan0" ];
    };

    useDHCP = false;
    interfaces.wlan0.useDHCP = false;

    interfaces.wlan0.ipv4.addresses = [{
      address = "192.168.100.15";
      prefixLength = 24;
    }];
    defaultGateway = "192.168.100.1";
    nameservers = [ "8.8.8.8" ];

    extraHosts = ''
      192.168.100.12 strawberry
      192.168.100.13 blossom
    '';
  };
}
