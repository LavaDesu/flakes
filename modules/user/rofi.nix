{ config, inputs, ... }: {
  programs.rofi = {
    enable = true;
    theme = "theme";
  };
  xdg.configFile."rofi/theme.rasi".source = ../../res/theme.rasi;
}
