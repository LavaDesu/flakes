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
      url = "https://raw.githubusercontent.com/folke/tokyonight.nvim/main/extras/kitty_tokyonight_night.conf";
      sha256 = "0mgjkmn4grr7rrxc5rrs1n0cghf03gp0v55hf3phll6czjavjldf";
    });
  };
}
