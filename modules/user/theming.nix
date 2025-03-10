{ config, pkgs, ... }: {
  gtk = {
    enable = true;
    gtk2.configLocation = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    font = {
      package = pkgs.open-sans;
      name = "Open Sans";
      size = 11;
    };
    # iconTheme = {
    #   package = pkgs.yaru-theme;
    #   name = "Yaru";
    # };
    # theme = {
    #   name = "Adwaita-dark";
    #   package = pkgs.gnome-themes-extra;
    # };
    gtk3.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
    gtk4.extraConfig = {
      gtk-application-prefer-dark-theme = 1;
    };
  };

  dconf.settings = {
    "org/gnome/desktop/interface".color-scheme = "prefer-dark";
  };

  home.pointerCursor = {
    package = pkgs.yaru-theme;
    name = "Yaru";
    size = 16;
    gtk.enable = true;
    x11.enable = true;
  };
}
