{ config, enableGUI, pkgs, ... }: {
  home.packages = with pkgs; [
    ffmpeg
    gnupg
    neofetch
    nodejs-16_x
    pamixer
    rnix-lsp
    transcrypt
    unrar
    wine-osu
    (winetricks.override { wine = wine-osu; })
    youtube-dl

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    brave
    discord-canary
    discover-overlay
    element-desktop
    feh
    gnome.file-roller
    gimp
    kotatogram-desktop
    insomnia
    lxappearance
    maim
    mongodb-compass
    obs-studio
    osu-lazer
    pavucontrol
    screenkey
    tor-browser-bundle-bin
    transmission-remote-gtk
    xclip
    xorg.xgamma
  ];
}
