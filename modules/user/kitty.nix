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
    };
    extraConfig = builtins.readFile (builtins.fetchurl {
      url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/eede574f9ef57137e6d7e4bab37b09db636c5a56/extras/kitty_tokyonight_night.conf";
      sha256 = "0l9yl3qmgf7b10x7hy7q5hma0hsyamq3n14lfbw31cimm6snwim6";
    });
  };
}
