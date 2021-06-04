{ config, pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    gparted
    htop
    libarchive
    lf
    msr-tools
    ncdu
    neovim
    rsync
    wget

    gnome3.nautilus
  ];
  environment.variables.EDITOR = "nvim";

  programs.light.enable = true;
  hardware.opentabletdriver.enable = true;
  programs.steam.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf ];
  services.gnome.sushi.enable = true;
  services.ipfs.enable = true;
}
