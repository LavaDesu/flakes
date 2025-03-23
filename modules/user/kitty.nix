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
      scrollback_pager = ''nvim --noplugin -c "set signcolumn=no showtabline=0" -c "silent write! /tmp/kitty_scrollback_buffer | te cat /tmp/kitty_scrollback_buffer - " -c "autocmd VimEnter * normal G"'';
      scrollback_pager_history_size = 2;
    };
  };
}
