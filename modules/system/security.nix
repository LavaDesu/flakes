{ config, pkgs, ... }: {
  networking.firewall.enable = false;

  services.openssh = {
    enable = true;
    permitRootLogin = "no";
    passwordAuthentication = false;
  };

  security = {
    polkit.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };
}
