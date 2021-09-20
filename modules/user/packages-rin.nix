{ config, enableGUI, inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    ffmpeg
    gnupg
    kitty
    neofetch
    nodejs-16_x
    pamixer
    rnix-lsp
    transcrypt
    unrar
    weechat
    inputs.nix-gaming.packages.x86_64-linux.wine-tkg
    inputs.nix-gaming.packages.x86_64-linux.wowtricks
    youtube-dl

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    brave
    (discord-plugged.override {
      plugins = [
        inputs.better-status-indicators
        inputs.channel-typing
        inputs.discord-tweaks
        inputs.fix-user-popouts
        inputs.no-double-back-pc
        inputs.powercord-popout-fix
        inputs.rolecolor-everywhere
        inputs.theme-toggler
        inputs.twemoji-but-good
        inputs.view-raw
        inputs.who-reacted
      ];
      themes = [
        pkgs.discord-tokyonight
        inputs.radialstatus
        inputs.tokyonight
        inputs.zelk
      ];
    })
    discover-overlay
    element-desktop
    feh
    gnome.file-roller
    gimp
    jetbrains.idea-community
    kotatogram-desktop
    insomnia
    lxappearance
    maim
    mongodb-compass
    obs-studio
    pavucontrol
    screenkey
    tor-browser-bundle-bin
    transmission-remote-gtk
    xclip
    xorg.xgamma
  ];
}
