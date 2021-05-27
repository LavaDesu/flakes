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
  environment.pathsToLink = [ "/share/zsh" ];
  users.mutableUsers = false;

  imports = [
    ./audio.nix
    ./gui.nix
    ./hardware-configuration.nix
    ./kernel.nix
    ./networking.nix
    ./packages.nix
    ./security.nix

    ../../users/rin
  ];
  nix = rec {
    package = pkgs.nixUnstable;
    binaryCaches = [
      "https://cache.nixos.org?priority=10"
      "https://lava.cachix.org"
    ];
    binaryCachePublicKeys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "lava.cachix.org-1:8lTWI/3IKWHByzzYHZySunMPYs2eAJw2duL+uLZkSy0="
    ];
    trustedBinaryCaches = binaryCaches;

    extraOptions = ''
      experimental-features = nix-command flakes
    '';
  };
  nixpkgs.config.allowUnfree = true;

  i18n.defaultLocale = "en_GB.UTF-8";
  console.useXkbConfig = true;
}

