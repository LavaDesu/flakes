{ config, ... }: {
  programs.rofi = {
    enable = true;
    font = "Open Sans 10";
    terminal = "kitty";
    #theme = builtins.fetchUrl {};
  };
}
