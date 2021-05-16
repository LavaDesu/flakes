{ config, overlays, pkgs, ... }: {
  networking.hostName = "winter";
  system.stateVersion = "20.09";

  environment.etc."machine-id".source = "/mnt/bcachefs/machine-id";
  users.mutableUsers = false;

  imports = [
    ./audio.nix
    ./gui.nix
    ./hardware-configuration.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix
    ./security.nix
  ];
  nix = {
    package = pkgs.nixUnstable;
    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.overlays = with overlays; [
    discord
    linux
    polybar
    picom
    wine-osu
  ];
  nixpkgs.config.allowUnfree = true;

  users.users.lava = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  i18n.defaultLocale = "en_GB.UTF-8";
  console.useXkbConfig = true;
}

