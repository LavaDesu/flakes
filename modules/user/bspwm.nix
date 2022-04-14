# Depends on eww
{ config, pkgs, ... }: {
  xsession.windowManager.bspwm = {
    enable = true;
    monitors = { eDP-1 = [ "1" "2" "3" "4" "5" "6" "7" "8" "9" "0"]; };
    settings = {
      window_gap = 10;
      border_width = 0;
      split_ratio = 0.5;
      top_padding = 0;
    };
    extraConfig = ''
      ${pkgs.feh}/bin/feh --no-fehbg --bg-fill ~/Pictures/Wallpapers/current

      ${pkgs.procps}/bin/pkill -SIGINT eww
      ${pkgs.eww}/bin/eww open linebar
    '';
  };
}
