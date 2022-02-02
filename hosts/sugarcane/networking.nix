{ config, ... }: {
  networking = {
    useDHCP = false;
    interfaces.ens3.useDHCP = true;

    extraHosts = ''
      10.100.0.3 blossom
      10.100.0.4 strawberry
    '';
  };
}
