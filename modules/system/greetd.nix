{ pkgs, lib, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time --cmd 'zsh -c \"source $HOME/.config/zsh/.zshrc && startx\"'";
        user = "greeter";
      };
    };
  };

  services.xserver = {
    autorun = false;
    displayManager.startx.enable = true;
  };
}
