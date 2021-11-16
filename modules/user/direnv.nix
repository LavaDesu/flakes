{ config, ...}: {
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.git.extraConfig.core.excludesFile = ".envrc";
  # We can't use .source since hm manages this file too
  xdg.configFile."direnv/direnvrc".text = builtins.readFile ../../res/direnvrc;
}
