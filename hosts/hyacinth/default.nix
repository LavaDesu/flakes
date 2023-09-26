{ config, inputs, modules, overlays, pkgs, ... }: {
  networking.hostName = "hyacinth";
  system.stateVersion = "21.11";
  time.timeZone = "Asia/Phnom_Penh";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.overlays = [ inputs.neovim-nightly.overlay ];
  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wg_hyacinth.file = ../../secrets/wg_blossom.age;
    wpa_conf.file = ../../secrets/wpa_conf.age;
  };
  imports = with modules.system; [
    inputs.home-manager.nixosModule
    home-manager

    audio
    base
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
    virtualisation
    wireguard

    modules.services.postgres

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    ../../users/rin
  ];
  services.postgresql.ensureDatabases = [ "barista" "barista-dev" ];

  # For steam fhs-env
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1v"
  ];
}
