{ config, modules, overlays, pkgs, ... }: {
  networking.hostName = "winter";
  system.stateVersion = "20.09";

  imports = with modules.system; [
    audio
    base
    gui
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

