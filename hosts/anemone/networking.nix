{ config, ... }: {
  networking = {
    nameservers = [ "8.8.8.8" "8.8.4.4" ];
    wireless.enable = true;

    networkmanager = {
      enable = true;
      dns = "none";
    };

    extraHosts = ''
      192.168.100.16 hyacinth
    '';
  };
}
