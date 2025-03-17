{ pkgs, lib, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.greetd.tuigreet}/bin/tuigreet --remember --asterisks --time --cmd 'zsh -c \"source $HOME/.config/zsh/.zshrc && Hyprland > $XDG_RUNTIME_DIR/Hyprland.out\"'";
        user = "greeter";
      };

      initial_session = {
        command = "Hyprland > \"$XDG_RUNTIME_DIR/Hyprland.out\"";
        user = "rin";
      };
    };
  };

  services.xserver = {
    autorun = false;
    displayManager.startx.enable = true;
  };
}
