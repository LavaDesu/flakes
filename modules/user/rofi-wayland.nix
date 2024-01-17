{ config, pkgs, ... }: {
  programs.rofi = {
    enable = true;
    package = pkgs.rofi-wayland;
    theme = "theme";
  };
  xdg.configFile."rofi/theme.rasi".source = ../../res/theme.rasi;
}
