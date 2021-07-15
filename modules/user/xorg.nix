{ config, ... }: {

  xsession = {
    enable = true;
    profilePath = ".config/xorg/xprofile";
    scriptPath = ".config/xorg/xsession";
  };

  xdg.configFile."xorg/xinitrc".source = ../../scripts/xinitrc;
  xdg.configFile."xorg/wallpaper.png".source = ../../res/wallpaper.png;
  xresources = {
    path = "${config.xdg.configHome}/xorg/xresources";
    properties = {
      # special
      "*.foreground" =  "#c5c8c6";
      "*.background" =  "#1d1f21";
      "*.cursorColor" = "#c5c8c6";

      # black
      "*.color0" =      "#1d1f21";
      "*.color8" =      "#969896";

      # red
      "*.color1" =      "#cc342b";
      "*.color9" =      "#cc342b";

      # green
      "*.color2" =      "#198844";
      "*.color10" =     "#198844";

      # yellow
      "*.color3" =      "#fba922";
      "*.color11" =     "#fba922";

      # blue
      "*.color4" =      "#3971ed";
      "*.color12" =     "#3971ed";

      # magenta
      "*.color5" =      "#a36ac7";
      "*.color13" =     "#a36ac7";

      # cyan
      "*.color6" =      "#3971ed";
      "*.color14" =     "#3971ed";

      # white
      "*.color7" =      "#c5c8c6";
      "*.color15" =     "#ffffff";
    };
  };
}
