{ config, ... }: {
  programs.urxvt = {
    enable = true;
    fonts = [ "xft:Cascadia Code:size=12.4" ];
    scroll.bar.enable = false;
    extraConfig = {
      background = "[65]#000000";
      depth = 32;

      cursorBlink = true;
      letterSpace = 0;
      lineSpace = 0;
      saveline = 4096;
      urlLauncher = "firefox";
      underlineURLs = true;
      urlButton = 1;

      perl-ext = "";
      perl-ext-common = "";
    };
  };
}

