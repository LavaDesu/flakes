{ config, ... }: {
  networking = {
    useDHCP = true;

    # extraHosts = ''
    #   10.100.0.3 blossom
    #   10.100.0.4 strawberry
    # '';
  };
}
