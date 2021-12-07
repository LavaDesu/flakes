{ config, enableGUI, inputs, pkgs, ... }: {
  home.packages = with pkgs; [
    dconf
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
    youtube-dl

    nodePackages_latest.pnpm
  ] ++ lib.optionals enableGUI [
    adoptopenjdk-hotspot-bin-16
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
        pkgs.me.discord-tokyonight
        inputs.radialstatus
        inputs.tokyonight
        inputs.zelk
      ];
    })
    element-desktop
    feh
    gnome.file-roller
    gimp
    jetbrains.idea-community
    kotatogram-desktop
    insomnia
    lxappearance
    maim
    ((multimc.override {
      jdk8 = adoptopenjdk-hotspot-bin-8;
      jdk = adoptopenjdk-hotspot-bin-16;
    }).overrideAttrs(o: {
      postPatch = lib.strings.replaceStrings ["/lib/openjdk"] [""] o.postPatch;
    }))
    obs-studio
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
