{ config, enableGUI, ... }: {
  programs.gpg = {
    enable = true;
    homedir = "${config.xdg.dataHome}/gnupg";
  };
  services.gpg-agent = {
    enable = true;
    pinentryFlavor = if enableGUI then "gnome3" else "tty";
  };
}
