{ config, enableGUI, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    efibootmgr
    git
    htop
    libarchive
    lf
    msr-tools
    ncdu
    neovim
    ntfs3g
    rsync
    wget
  ] ++ lib.optionals enableGUI [
    gparted
    gnome3.nautilus
  ];
  environment.variables.EDITOR = "nvim";
}
// (if !enableGUI then {} else {
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
    intel-ocl
    rocm-opencl-icd
    rocm-opencl-runtime
  ];
  programs.light.enable = true;
  hardware.opentabletdriver.enable = true;
  programs.steam.enable = true;
  services.dbus.packages = [ pkgs.gnome3.dconf pkgs.gcr ];
  services.gnome.sushi.enable = true;
})
