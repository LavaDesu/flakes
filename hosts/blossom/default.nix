{ config, inputs, modules, overlays, pkgs, ... }: {
  networking.hostName = "blossom";
  system.stateVersion = "21.11";
  time.timeZone = "Asia/Phnom_Penh";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.overlays = [ inputs.neovim-nightly.overlay ];
  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wg_blossom.file = ../../secrets/wg_blossom.age;
    wpa_conf.file = ../../secrets/wpa_conf.age;
  };
  imports = with modules.system; [
    inputs.home-manager.nixosModule
    home-manager

    audio
    base
    greetd
    gui
    input
    kernel
    nix
    packages
    security
    snapper
    wireguard

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin
  ];

  hardware.opengl.package = (pkgs.mesa.overrideAttrs(o: {
    patches = o.patches ++ [ ./mesa_mr_17182.patch ];
  })).drivers;
}

