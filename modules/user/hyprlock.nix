{ ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      auth = {
        fingerprint = {
          enabled = true;
        };
      };
    };
  };
}
