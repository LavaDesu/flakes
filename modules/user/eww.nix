# Depends on bspwm
{ pkgs, ... }: {
  home.packages = with pkgs; [ xtitle ];
  programs.eww = {
    enable = true;
    configDir = ../../res/eww;
  };
}
