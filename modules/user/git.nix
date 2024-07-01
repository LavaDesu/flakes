{ ... }: {
  programs.git = {
    enable = true;
    userName = "LavaDesu";
    userEmail = "me@lava.moe";
    signing = {
      key = "059F098EBF0E9A13E10A46BF6500251E087653C9";
      signByDefault = true;
    };
    extraConfig = {
      core.abbrev = 11;
      safe.directory = "/home/rin/Projects/flakes";
    };
  };
}
