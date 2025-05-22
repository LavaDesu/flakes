{ gcSecrets, ... }: {
  networking = {
    useDHCP = true;
    interfaces.enp8s0.ipv6.addresses = [
      {
        address = gcSecrets.hazel.ipv6Addr;
        prefixLength = 64;
      }
    ];
    defaultGateway6 = {
      address = "fe80::1";
      interface = "enp8s0";
    };
  };
}
