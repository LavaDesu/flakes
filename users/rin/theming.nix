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

  # TODO: i gave up
  #xsession.pointerCursor = {
  #  package = pkgs.bibata-cursors;
  #  name = "Bibata_Classic";
  #  size = 16;
  #};
}
