{ config, lib, modules, pkgs, ... }: {
  users.users.rin = {
    isNormalUser = true;
    extraGroups = [ "audio" "video" "wheel" ];
    shell = pkgs.zsh;
    uid = 1001;
  };
  home-manager.users.rin = { config, enableGUI, lib, pkgs, ... }: {
    home = {
      username = "rin";
      homeDirectory = "/home/rin";
      stateVersion = "21.05";
      packages = with pkgs; [
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
        element-desktop
        feh
        gnome.file-roller
        gimp
        kotatogram-desktop
        lxappearance
        maim
        pavucontrol
        tor-browser-bundle-bin
        transmission-remote-gtk
        xclip
        xorg.xgamma
      ];
    };

    imports = with modules.user; [
      sessionVariables

      direnv
      git
      gpg
      neovim
      npm
      zsh
    ] ++ lib.optionals enableGUI [
      theming
      xdg

      kitty
      mpv
      rofi

      dunst
      picom
      polybar

      xorg
      sxhkd
      bspwm
    ];

    home.file.".local/bin/ipc-bridge.exe".source = builtins.fetchurl {
      url = "https://github.com/0e4ef622/wine-discord-ipc-bridge/releases/download/v0.0.1/winediscordipcbridge.exe";
      sha256 = "1swn9spxpq6blm74kjmfz4ipq6a8qjzccvb2msb25pf5b1z7jnns";
    };
    home.file.".local/bin/osu" = {
      executable = true;
      source = ../scripts/osu;
    };
  };
}
