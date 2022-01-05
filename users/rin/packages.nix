{ config, enableGUI, inputs, pkgs, ... }:
let
  mediaKeyPatch = pkgs.fetchurl {
    url = "https://github.com/powercord-org/powercord/commit/6c9e57de7fcbd50e473c6d9b1c81e56fef85fa93.diff";
    sha256 = "16jy1qkkbjxmylqpjfm3y47nf40hw5anq284aj6kc9z3n3323pic";
  };
  discord = pkgs.discord-plugged.override {
    powercord = pkgs.powercord.override {
      powercord-unwrapped = pkgs.powercord.unwrapped.overrideAttrs(old: {
        patches = (if (old ? patches) then old.patches else []) ++ [
          mediaKeyPatch
          ./powercordMediaKeyPatchPatch.patch
        ];
      });
    };
    plugins = [
      inputs.better-status-indicators
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
  home.packages = with pkgs; [
    dconf
    ffmpeg
    gnupg
    kitty
    nodejs-16_x
    pamixer
    rnix-lsp
    unrar
    weechat
    youtube-dl

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    brave
    discord
    element-desktop
    feh
    gnome.file-roller
    gimp
    kotatogram-desktop
    insomnia
    maim
    me.tetrio-desktop-plus
    multimc
    obs-studio
    openjdk17
    pavucontrol
    screenkey
    tor-browser-bundle-bin
    transmission-remote-gtk
    inputs.nix-gaming.packages.x86_64-linux.wine-tkg
    inputs.nix-gaming.packages.x86_64-linux.wowtricks
    xclip
    xorg.xgamma
  ];
}
