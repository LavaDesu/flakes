{ config, ... }: {
  networking = {
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    wireless.iwd.enable = true;

    networkmanager = {
      enable = true;
      wifi.backend = "iwd";
    };

    extraHosts = ''
      192.168.100.16 hyacinth
    '';
  };
}
