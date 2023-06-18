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
    gimp
    gnome.file-roller
    gnome.zenity
    kotatogram-desktop
    krita
    lm_sensors
    lutris
    insomnia
    maim
    me.rivalcfg
    me.tetrio-desktop-plus
    mumble
    obs-studio
    openjdk17
    inputs.nix-gaming.packages.x86_64-linux.osu-lazer-bin
    pavucontrol
    prismlauncher
    psensor
    screenkey
    tor-browser-bundle-bin
    transmission-remote-gtk
    virt-manager
    inputs.nix-gaming.packages.x86_64-linux.wine-osu
    winetricks
    xclip
    xorg.xgamma
  ];
}
