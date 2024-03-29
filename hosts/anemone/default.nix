{ config, inputs, modules, overlays, pkgs, ... }: {
  networking.hostName = "anemone";
  system.stateVersion = "23.11";
  time.timeZone = "Australia/Melbourne";

  nixpkgs.overlays = [ inputs.neovim-nightly.overlay ];
  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
  };

  imports = with modules.system; [
    inputs.home-manager.nixosModule
    home-manager

    audio
    base
    bluetooth
    ccache
    corectrl
    flatpak
    greetd
    gui
    input
    kernel
    nix
    packages
    printing
    security
    snapper

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin
  ];

  programs.hyprland.enable = true;

  # For steam fhs-env
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
}
