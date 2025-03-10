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
    nil
    nodejs-18_x
    pamixer
    qmk
    ripgrep
    unrar
    weechat
    yt-dlp

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    android-studio
    discord-canary
    drawio
    element-desktop
    eww
    feh
    file-roller
    gamescope
    gimp
    grim
    jetbrains.idea-community-bin
    #kotatogram-desktop
    krita
    lm_sensors
    lutris
    insomnia
    maim
    mangohud
    #me.tetrio-desktop-plus
    me.psensor
    inputs.nix-gaming.packages.x86_64-linux.osu-lazer-bin
    inputs.nix-gaming.packages.x86_64-linux.wine-osu
    obsidian
    pavucontrol
    prismlauncher
    qbittorrent
    rivalcfg
    screenkey
    slurp
    swaybg
    texliveFull
    tor-browser-bundle-bin
    transmission-remote-gtk
    virt-manager
    winetricks
    (vscode-with-extensions.override {
      vscodeExtensions = with vscode-extensions; [
        ms-vsliveshare.vsliveshare
        vscodevim.vim
    ];
    })
    xclip
    xorg.xgamma
    zathura
    zenity
  ];
}
