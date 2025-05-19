{ config, ... }: {
  networking = {
    useDHCP = true;
    interfaces.enp8s0.ipv6.addresses = [
      {
        address = "2a01:4f9:4a:2694::11";
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp8s0";
    };
  };
}
