{ config, enableGUI, lib, pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    comma
    ecryptfs
    efibootmgr
    git
    htop
    jq
    libarchive
    lf
    msr-tools
    ncdu
    neovim
    nfs-utils
    ntfs3g
    sshfs
    rsync
    wget
  ] ++ lib.optionals enableGUI [
    gparted
    nautilus
  ];
  environment.variables.EDITOR = "nvim";
}
// (if !enableGUI then {} else {
  programs.adb.enable = true;
  hardware.opengl.extraPackages = with pkgs; [
    vaapiIntel
    vaapiVdpau
    libvdpau-va-gl
  ];
  programs.light.enable = true;
  hardware.opentabletdriver.enable = true;
  hardware.keyboard.qmk.enable = true;
  programs.steam = {
    enable = true;
    package = pkgs.steam.override {
      extraPkgs = pkgs: with pkgs; [
        gsettings-desktop-schemas
      ];
    };
  };
  services.dbus.packages = [ pkgs.dconf pkgs.gcr ];
  services.gnome.sushi.enable = true;
})
