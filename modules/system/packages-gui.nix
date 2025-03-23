{ config, lib, pkgs, ... }: {
  config = lib.mkIf config.me.gui {
    environment.systemPackages = with pkgs; [
      gparted
      nautilus
    ];
    programs.adb.enable = true;
    hardware.graphics.extraPackages = with pkgs; [
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
  };
}
