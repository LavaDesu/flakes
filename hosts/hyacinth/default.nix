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
  programs.corectrl = {
    enable = true;
    gpuOverclock = {
      enable = true;
      ppfeaturemask = "0xffffffff";
    };
  };
  services.murmur = {
    enable = true;
    openFirewall = true;
  };
  virtualisation = {
    lxd.enable = true;
    waydroid.enable = true;
    spiceUSBRedirection.enable = true;
    libvirtd = {
      enable = true;
      qemu.package = pkgs.qemu_kvm.override { smbdSupport = true; };
    };
  };
  services.flatpak.enable = true;
  xdg.portal.enable = true;
  xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk ];
  services.printing.enable = true;
  services.printing.drivers = [ pkgs.epson-escpr pkgs.me.epson-201112j ];
}
