{ config, modules, overlays, pkgs, ... }: {
  networking.hostName = "winter";
  system.stateVersion = "20.09";

  imports = with modules.system; [
    audio
    base
    filesystem-winter
    gui
    input
    kernel
    kernel-winter
    networking
    nix
    packages
    security
    snapper

    ../users/rin.nix
  ];
}

