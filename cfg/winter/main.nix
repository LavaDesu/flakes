{ config, pkgs, ... }: {
  networking.hostName = "winter";
  system.stateVersion = "20.09";

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
  nixpkgs.overlays = [
    (self: super: {
      polybar = super.polybar.override { i3Support = true; };
      picom = super.picom.overrideAttrs(old: {
        src = pkgs.fetchFromGitHub {
          repo = "picom";
          owner = "ibhagwan";
          rev = "60eb00ce1b52aee46d343481d0530d5013ab850b";
          sha256 = "1m17znhl42sa6ry31yiy05j5ql6razajzd6s3k2wz4c63rc2fd1w";
        };
      });
    })
  ];
  nixpkgs.config.allowUnfree = true;

  # set in flakes-secrets
  # time.timeZone = "";
  i18n.defaultLocale = "en_GB.UTF-8";

  sound.enable = true;
  hardware.pulseaudio.enable = true;

  users.users.lava = {
    isNormalUser = true;
    extraGroups = [ "wheel" ];
    shell = pkgs.zsh;
  };

  console.useXkbConfig = true;
}

