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
    gimp
    gnome.file-roller
    kotatogram-desktop
    krita
    lm_sensors
    lutris
    insomnia
    maim
    #me.tetrio-desktop-plus
    mumble
    obs-studio
    openjdk17
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
