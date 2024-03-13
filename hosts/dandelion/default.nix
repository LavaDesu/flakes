{ config, inputs, modules, modulesPath, overlays, pkgs, ... }: {
  networking.hostName = "dandelion";
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  imports = with modules.system; [
    (modulesPath + "/profiles/qemu-guest.nix")
    inputs.home-manager-stable.nixosModule

    base
    home-manager
    input
    nix-stable
    security
    #wireguard

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix

    ../../users/hana
  ];
}
