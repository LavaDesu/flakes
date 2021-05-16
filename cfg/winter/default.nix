{ config, overlays, pkgs, ... }: {
  networking.hostName = "winter";
  system.stateVersion = "20.09";

  environment.etc = {
    "machine-id".source = "/mnt/bcachefs/machine-id";
    "ssh/ssh_host_rsa_key".source = "/mnt/bcachefs/ssh_host_rsa_key";
    "ssh/ssh_host_rsa_key.pub".source = "/mnt/bcachefs/ssh_host_rsa_key.pub";
    "ssh/ssh_host_ed25519_key".source = "/mnt/bcachefs/ssh_host_ed25519_key";
    "ssh/ssh_host_ed25519_key.pub".source = "/mnt/bcachefs/ssh_host_ed25519_key.pub";
  };
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

