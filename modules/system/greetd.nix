{ pkgs, ... }: {
  services.greetd = {
    enable = true;
    settings = {
      default_session = {
        command = "${pkgs.tuigreet}/bin/tuigreet --remember --asterisks --time --cmd 'zsh -c \"source $HOME/.config/zsh/.zshrc && Hyprland > $XDG_RUNTIME_DIR/Hyprland.out\"'";
        user = "greeter";
      };

      initial_session = {
        command = "${pkgs.writeShellScript "launch.sh" ''
          zsh -c "source $HOME/.config/zsh/.zshrc && Hyprland > \"$XDG_RUNTIME_DIR/Hyprland.out\""
        ''}";
        user = "rin";
      };
    };
  };
}
