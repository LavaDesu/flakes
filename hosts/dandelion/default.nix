{ config, inputs, modules, modulesPath, overlays, pkgs, ... }: {
  networking.hostName = "dandelion";
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  age.secrets = {
    acme_dns.file = ../../secrets/acme_dns.age;
  };

  imports = with modules.system; [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.home-manager-stable.nixosModule

    base
    home-manager
    input
    nix-stable
    security
    #wireguard

    modules.services.nginx
    modules.services.postgres

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix

    ../../users/hana
  ];
}
