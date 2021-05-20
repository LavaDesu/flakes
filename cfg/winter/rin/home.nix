{ config, pkgs, ... }: rec {
  home = {
    username = "rin";
    homeDirectory = "/home/rin";
    stateVersion = "21.05";
    packages = with pkgs; [
      appimage-run
      discord-canary
      element-desktop
      firefox
      gimp
      glxinfo
      gnupg
      lf
      neofetch
      nodejs
      pavucontrol
      osu-lazer
      cargo rustc clippy cmake gcc gnumake pkg-config
      tor-browser-bundle-bin
      wine-osu
      (winetricks.override { wine = wine-osu; })
      xorg.xgamma
    ];
  };

  imports = [
    ./gtk.nix

    ./alacritty.nix
    ./neovim.nix
    ./rofi.nix
    ./zsh.nix

    ./dunst.nix
    ./picom.nix
    ./polybar.nix

    ./i3.nix
  ];

  xdg = {
    enable = true;
    mime.enable = true;
    mimeApps.enable = true;
  };

  programs = {
    feh.enable = true;
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
