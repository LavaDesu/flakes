{ pkgs, ... }: {
  home.packages = with pkgs; [ socat ];
  programs.eww = {
    enable = true;
    configDir = ../../res/eww-wayland;
  };
}
