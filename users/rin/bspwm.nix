{ config, ... }: {
  xsession.windowManager.bspwm = {
    enable = true;
    monitors = { eDP-1 = [ "I" "II" "III" "IV" "V" "VI" "VII" "VIII" "XI" "X" ]; };
    settings = {
      window_gap = 10;
      border_width = 0;
      split_ratio = 0.5;
    };
    extraConfig = ''
      feh --no-fehbg --bg-fill ${config.xdg.configHome}/xorg/wallpaper.png
      systemctl --user restart polybar # home-manager loads this too early
    '';
  };
}
