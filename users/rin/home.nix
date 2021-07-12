{ config, pkgs, ... }: rec {
  home = {
    username = "rin";
    homeDirectory = "/home/rin";
    stateVersion = "21.05";
    packages = with pkgs; [
      appimage-run
      brave
      discord-canary
      element-desktop
      feh
      ffmpeg
      gnome.file-roller
      ghidra-bin
      gimp
      gnupg
      inkscape
      kotatogram-desktop
      lf
      lxappearance
      maim
      mps-youtube
      neofetch
      nodejs-16_x
      pamixer
      pavucontrol
      rnix-lsp
      tor-browser-bundle-bin
      transcrypt
      transmission-remote-gtk
      unrar
      vlc
      wine-osu
      (winetricks.override { wine = wine-osu; })
      xclip
      xorg.xgamma
      youtube-dl

      nodePackages_latest.pnpm
    ];

    sessionVariables = {
      PATH = builtins.concatStringsSep ":" [
        "${config.home.homeDirectory}/.local/bin"
        "${config.xdg.dataHome}/npm/bin"
        "$PATH"
      ];

      XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
      EDITOR = "nvim";

      _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
      CARGO_HOME = "${config.xdg.dataHome}/cargo";
      DIRENV_LOG_FORMAT = "";
      GNUPGHOME = "${config.xdg.dataHome}/gnupg";
      GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
      LESSHISTFILE = "-";
      NODE_REPL_HISTORY="${config.xdg.dataHome}/nodejs/repl_history";
      NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
      PUB_CACHE = "${config.xdg.cacheHome}/dart";
      WGETRC = "${config.xdg.configHome}/wgetrc";
      XINITRC = "${config.xdg.configHome}/xorg/xinitrc";

      WINEPREFIX = "${config.xdg.dataHome}/wine64";
      WINEARCH = "win64";
    };
  };

  imports = [
    ./theming.nix
    ./xdg.nix

    # ./alacritty.nix
    ./kitty.nix
    ./mpv.nix
    ./neovim.nix
    ./npm.nix
    ./rofi.nix
    # ./urxvt.nix
    ./zsh.nix

    ./dunst.nix
    ./picom.nix
    ./polybar.bspwm.nix
    # ./polybar.i3.nix

    ./xorg.nix
    ./sxhkd.nix
    ./bspwm.nix
    # ./i3.nix
  ];

  programs = {
    feh.enable = true;

    direnv = {
      enable = true;
      nix-direnv = {
        enable = true;
        enableFlakes = true;
      };
    };
    git = {
      enable = true;
      userName = "LavaDesu";
      userEmail = "me@lava.moe";
      signing = {
        key = "059F098EBF0E9A13E10A46BF6500251E087653C9";
        signByDefault = true;
      };
      extraConfig = {
        core.abbrev = 11;
      };
    };
    gpg = {
      enable = true;
      homedir = "${config.xdg.dataHome}/gnupg";
    };
  };

  services = {
    # TODO: borked
    clipmenu.enable = false;
    gpg-agent = {
      enable = true;
      pinentryFlavor = "gnome3";
    };
  };

  home.file.".local/bin/ipc-bridge.exe".source = builtins.fetchurl {
    url = "https://github.com/0e4ef622/wine-discord-ipc-bridge/releases/download/v0.0.1/winediscordipcbridge.exe";
    sha256 = "1swn9spxpq6blm74kjmfz4ipq6a8qjzccvb2msb25pf5b1z7jnns";
  };
  home.file.".local/bin/osu" = {
    executable = true;
    source = ./scripts/osu;
  };
}
