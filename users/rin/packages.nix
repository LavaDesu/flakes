{ config, enableGUI, inputs, pkgs, ... }:
let
  mediaKeyPatch = pkgs.fetchurl {
    url = "https://github.com/powercord-org/powercord/commit/6c9e57de7fcbd50e473c6d9b1c81e56fef85fa93.diff";
    sha256 = "16jy1qkkbjxmylqpjfm3y47nf40hw5anq284aj6kc9z3n3323pic";
  };
  discord = pkgs.discord-plugged.override {
    discord-canary = pkgs.discord-canary.override rec {
      version = "0.0.136";
      src = builtins.fetchurl {
        url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
        sha256 = "01a855g3bj989ydd304ipvpjmz1p8ha4f3hl0q3yp2gk6pia1c9s";
      };
    };
    powercord = pkgs.powercord.override {
      powercord-unwrapped = pkgs.powercord.unwrapped.overrideAttrs(old: {
        patches = (if (old ? patches) then old.patches else []) ++ [
          mediaKeyPatch
          ./powercordMediaKeyPatchPatch.patch
        ];
      });
    };
    plugins = [
      #inputs.better-status-indicators
      inputs.channel-typing
      inputs.discord-tweaks
      inputs.fix-user-popouts
      inputs.multitask
      inputs.no-double-back-pc
      inputs.powercord-popout-fix
      inputs.rolecolor-everywhere
      inputs.theme-toggler
      inputs.twemoji-but-good
      inputs.view-raw
      inputs.who-reacted
    ];
    themes = [
      pkgs.me.discord-tokyonight
      inputs.radialstatus
      inputs.tokyonight
      inputs.zelk
    ];
  };
in {
  programs.firefox = {
    enable = true;
    package = pkgs.firefox.override { extraNativeMessagingHosts = [ pkgs.passff-host ]; };
  };

  home.packages = with pkgs; [
    dconf
    fd
    ffmpeg
    gnupg
    kitty
    nodejs-16_x
    pamixer
    ripgrep
    rnix-lsp
    unrar
    weechat
    youtube-dl

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    discord
    element-desktop
    eww
    feh
    gnome.file-roller
    gimp
    kotatogram-desktop
    krita
    insomnia
    maim
    me.tetrio-desktop-plus
    obs-studio
    openjdk17
    pavucontrol
    polymc
    screenkey
    tor-browser-bundle-bin
    transmission-remote-gtk
    inputs.nix-gaming.packages.x86_64-linux.wine-osu
    winetricks
    xclip
    xorg.xgamma
  ];
}
