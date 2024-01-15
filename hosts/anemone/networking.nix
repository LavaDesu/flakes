{ config, ... }: {
  networking = {
    useDHCP = true;
    nameservers = [ "1.1.1.1" "8.8.8.8" ];
    wireless.userControlled.enable = true;

    extraHosts = ''
      192.168.100.12 strawberry
      192.168.100.15 caramel
    '';
  };
}
