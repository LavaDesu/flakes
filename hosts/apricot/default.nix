{ config, modules, overlays, pkgs, ... }: {
  networking.hostName = "apricot";
  system.stateVersion = "21.05";

  imports = with modules.system; [
    base
    input
    kernel
    nix
    packages
    security
    snapper

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin.nix
  ];
}

