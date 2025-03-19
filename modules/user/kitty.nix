{ config, pkgs, ... }: {
  programs.kitty = {
    enable = true;
    font = {
      package = pkgs.cascadia-code;
      name = "Cascadia Code PL";
      size = 13;
    };
    settings = {
      font_features = "-ss01 +ss19";
      enable_audio_bell = false;
      color5 = config.catppuccin.hexcolors.mauve;
      color13 = config.catppuccin.hexcolors.mauve;
      window_margin_width = 5;
    };
  };
}
