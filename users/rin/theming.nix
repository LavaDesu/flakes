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
      name = "Materia-dark";
      package = pkgs.materia-theme;
    };
  };

  xsession.pointerCursor = {
    package = pkgs.yaru-theme;
    name = "Yaru";
    size = 16;
  };
}
