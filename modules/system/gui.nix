{ config, lib, pkgs, ... }: {
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        serif = [ "NotoSerif" ];
        sansSerif = [ "NotoSans" ];
        monospace = [ "CascadiaCode" ];
      };
    };
    fonts = with pkgs; [
      material-symbols
      material-icons
      cascadia-code
      font-awesome
      font-awesome_4
      hanazono
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-extra
      open-sans
      twemoji-color-font
      unifont
    ];
  };
  services.xserver = {
    enable = true;
    displayManager.lightdm.enable = lib.mkForce false;
    desktopManager.xterm.enable = false;
  };
}
