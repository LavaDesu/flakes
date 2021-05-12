{ config, lib, pkgs, ... }: {
  fonts = {
    enableDefaultFonts = true;
    fontconfig = {
      defaultFonts = {
        serif = ["NotoSerif"];
        sansSerif = ["NotoSans"];
        monospace = ["CascadiaCode"];
      };
    };
    fonts = with pkgs; [
      cascadia-code
      font-awesome-ttf
      font-awesome_4
      hanazono
      material-icons
      noto-fonts
      noto-fonts-cjk
      noto-fonts-extra
      open-sans
      twemoji-color-font
      unifont
    ];
  };
  services.xserver = {
    enable = true;
    autorun = false;
    displayManager = {
      lightdm.enable = lib.mkForce false;
      startx.enable = true;
      xserverArgs = [
        "-ardelay 250"
        "-arinterval 15"
      ];
    };
    desktopManager.xterm.enable = false;
    libinput.enable = true;
    config = ''
      Section "InputClass"
        Identifier "mouse accel"
        Driver "libinput"
        MatchIsPointer "yes"
        Option "AccelProfile" "flat"
        Option "AccelSpeed" "0"
      EndSection
    '';
    xkbOptions = "caps:swapescape";
    windowManager.i3 = {
      enable = true;
      package = pkgs.i3-gaps;
      extraPackages = with pkgs; [
        dunst
        feh
        lxappearance
        maim
        picom
        polybar
        rofi
        xclip
      ];
    };
  };
}
