{ pkgs, lib, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time --cmd startx";
        user = "greeter";
      };
    };
  };
}
