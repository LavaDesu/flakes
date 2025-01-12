{ config, inputs, modules, overlays, pkgs, ... }: {
  networking.hostName = "hyacinth";
  system.stateVersion = "21.11";
  time.timeZone = "Australia/Melbourne";

  boot.binfmt.emulatedSystems = [ "aarch64-linux" ];
  nixpkgs.overlays = [ inputs.neovim-nightly.overlays.default ];
  age.secrets = {
    passwd.file = ../../secrets/passwd.age;
    wg_hyacinth.file = ../../secrets/wg_blossom.age;
    wpa_conf.file = ../../secrets/wpa_conf.age;
  };
  imports = with modules.system; [
    inputs.home-manager.nixosModule
    home-manager

    aagl
    audio
    base
    bluetooth
    ccache
    corectrl
    flatpak
    #greetd_xorg
    greetd_wayland
    gui
    input
    kernel
    nix
    packages
    printing
    security
    snapper
    virtualisation

    modules.services.postgres

    ./filesystem.nix
    ./kernel.nix
    ./networking.nix

    #../../users/rin/xorg.nix
    ../../users/rin/wayland.nix
  ];
  services.postgresql.ensureDatabases = [ "barista" "barista-dev" ];
  programs.hyprland.enable = true;
  systemd.services.nix-daemon.environment.TMPDIR = "/nix/tmp";

  # For steam fhs-env
  nixpkgs.config.permittedInsecurePackages = [
    "openssl-1.1.1w"
  ];
}
