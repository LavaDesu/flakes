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
    nodejs-16_x
    pamixer
    ripgrep
    rnix-lsp
    unrar
    weechat
    youtube-dl

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    discord-canary
    element-desktop
    eww
    feh
    gamescope
    gimp
    gnome.file-roller
    kotatogram-desktop
    krita
    insomnia
    maim
    me.tetrio-desktop-plus
    obs-studio
    openjdk17
    pavucontrol
    prismlauncher
    screenkey
    tor-browser-bundle-bin
    transmission-remote-gtk
    inputs.nix-gaming.packages.x86_64-linux.wine-osu
    winetricks
    xclip
    xorg.xgamma
  ];
}
