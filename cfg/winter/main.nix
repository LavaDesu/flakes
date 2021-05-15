{ config, overlays, pkgs, ... }: {
  networking.hostName = "winter";
  system.stateVersion = "20.09";

  environment.etc."machine-id".source = "/mnt/bcachefs/machine-id";

  imports = [
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
  ];
  nixpkgs.config.allowUnfree = true;

  # set in flakes-secrets
  # time.timeZone = "";
  i18n.defaultLocale = "en_GB.UTF-8";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.mutableUsers = false;
  users.users.lava = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
    initialPassword = "gaming";
  };

  console.useXkbConfig = true;
}

