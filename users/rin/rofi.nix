{ config, ... }: {
  programs.rofi = {
    enable = true;
    font = "Open Sans 10";
    scrollbar = false;
    terminal = "kitty";
    #theme = builtins.fetchUrl {};
  };
}
