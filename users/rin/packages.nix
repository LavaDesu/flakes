{ config, enableGUI, inputs, pkgs, ... }: {
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
    nodejs-18_x
    pamixer
    qmk
    ripgrep
    rnix-lsp
    unrar
    weechat
    yt-dlp

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    discord-canary
    element-desktop
    eww
    feh
    gimp
    gnome.file-roller
    gnome.zenity
    krita
    lm_sensors
    lutris
    insomnia
    maim
    mangohud
    me.tetrio-desktop-plus
    inputs.nix-gaming.packages.x86_64-linux.osu-lazer-bin
    pavucontrol
    prismlauncher
    psensor
    qbittorrent
    rivalcfg
    screenkey
    tor-browser-bundle-bin
    transmission-remote-gtk
    virt-manager
    winetricks
    xclip
    xorg.xgamma
  ];
}
