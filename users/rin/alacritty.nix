{ config, ... }: {
  programs.alacritty = {
    enable = true;
    settings = {
      scrolling = {
        history = 10000;
        multiplier = 3;
      };
      font = {
        normal = {
          family = "CascadiaCode";
          style = "Regular";
        };
        size = 8.6;
      };
      window = {
        dynamic_title = true;
        padding = {
          x = 5;
          y = 0;
        };
      };
      # TODO: how
      # hints.enabled = [{
      #   command = "xdg-open";
      #   post_processing = true;
      #   mouse = {
      #     enabled = true;
      #     mods = "Control";
      #   };
      # }];

      background_opacity = 0.8;
      draw_bold_text_with_bright_colors = true;
      live_config_reload = true;
    };
  };
}
