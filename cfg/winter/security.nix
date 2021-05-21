{ config, pkgs, ... }: {
  networking.firewall.enable = false;
  services.openssh.enable = true;

  security = {
    polkit.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          groups = ["wheel"];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };

  programs.gnupg.agent = {
    enable = true;
    pinentryFlavor = "gnome3";
  };
}
