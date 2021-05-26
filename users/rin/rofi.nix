{ config, ... }: {
  programs.rofi = {
    font = "Open Sans 10";
    scrollbar = false;
    #theme = builtins.fetchUrl {};
  };
}
