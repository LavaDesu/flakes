{ config, lib, ... }: {
  programs.direnv = {
    enable = true;
    nix-direnv = {
      enable = true;
    };
  };
  programs.git.extraConfig.core.excludesFile = ".envrc";
  # We can't use .source since hm manages this file too
  xdg.configFile."direnv/direnvrc".text = builtins.readFile ../../res/direnvrc;
  home.activation = {
    direnvClearCache = lib.hm.dag.entryAfter ["writeBoundary"] ''
      $DRY_RUN_CMD rm -rf $VERBOSE_ARG $HOME/.cache/direnv/layouts
    '';
  };
}
