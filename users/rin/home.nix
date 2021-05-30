{ config, pkgs, ... }: rec {
  home = {
    username = "rin";
    homeDirectory = "/home/rin";
    stateVersion = "21.05";
    packages = with pkgs; [
      appimage-run
      cachix
      chromium
      discord-canary
      element-desktop
      firefox
      gimp
      glxinfo
      gnupg
      lf
      neofetch
      pamixer
      pavucontrol
      tor-browser-bundle-bin
      transcrypt
      wine-osu
      (winetricks.override { wine = wine-osu; })
      xorg.xgamma
    ];
  };

  imports = [
    ./theming.nix
    ./xdg.nix

    ./alacritty.nix
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
      enableNixDirenvIntegration = true;
    };
    git = {
      enable = true;
      userName = "LavaDesu";
      userEmail = "me@lava.moe";
      signing = {
        key = "059F098EBF0E9A13E10A46BF6500251E087653C9";
        signByDefault = true;
      };
    };
    password-store = {
      enable = true;
      package = pkgs.pass.withExtensions (exts: [ exts.pass-otp ]);
    };
  };
}
