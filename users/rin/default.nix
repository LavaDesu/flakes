{ config, lib, modules, pkgs, ... }: {
  users.users.rin = {
    isNormalUser = true;
    extraGroups = [ "adbusers" "audio" "video" "wheel" ];
    shell = pkgs.zsh;
    uid = 1001;
    passwordFile = config.age.secrets.passwd.path;
  };
  home-manager.users.rin = { config, enableGUI, lib, pkgs, ... }: {
    home = {
      username = "rin";
      homeDirectory = "/home/rin";
      stateVersion = "21.05";
      keyboard = null; # see https://github.com/nix-community/home-manager/issues/2219
    };

    imports = with modules.user; [
      ./packages.nix
      sessionVariables

      direnv
      git
      gpg
      neovim
      npm
      pass
      zsh
    ] ++ lib.optionals enableGUI [
      theming
      xdg

      kitty
      mpv
      rofi
      spicetify

      dunst
      eww
      picom

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
      source = ../../scripts/osu;
    };
  };
}
