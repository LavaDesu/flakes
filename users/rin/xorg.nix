{ config, ... }: {
  xsession.enable = true;
  home.file.".xinitrc".source = ./scripts/xinitrc;
  xdg.configFile."xorg/wallpaper.png".source = ../../res/wallpaper.png;
}
