{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    font = {
      package = pkgs.open-sans;
      name = "Open Sans";
      size = 11;
    };
    iconTheme = {
      package = pkgs.yaru-theme;
      name = "Yaru";
    };
    theme = {
      name = "Adapta-Nokto-Eta";
      package = pkgs.adapta-gtk-theme;
    };
  };
}
