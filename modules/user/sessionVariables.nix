{ config, ... }: {
  home.sessionVariables = {
    PATH = builtins.concatStringsSep ":" [
      "${config.home.homeDirectory}/.local/bin"
      "${config.xdg.dataHome}/npm/bin"
      "$PATH"
    ];

    XAUTHORITY = "$XDG_RUNTIME_DIR/Xauthority";
    EDITOR = "nvim";

    _JAVA_OPTIONS = "-Djava.util.prefs.userRoot=${config.xdg.configHome}/java";
    CARGO_HOME = "${config.xdg.dataHome}/cargo";
    DIRENV_LOG_FORMAT = "";
    FZF_DEFAULT_COMMAND = "fd --type f --hidden --follow --exclude .git";
    GNUPGHOME = "${config.xdg.dataHome}/gnupg";
    GTK2_RC_FILES = "${config.xdg.configHome}/gtk-2.0/gtkrc";
    LESSHISTFILE = "-";
    LUTRIS_SKIP_INIT = "1";
    NODE_REPL_HISTORY = "${config.xdg.dataHome}/nodejs/repl_history";
    NPM_CONFIG_USERCONFIG = "${config.xdg.configHome}/npm/npmrc";
    PUB_CACHE = "${config.xdg.cacheHome}/dart";
    WGETRC = "${config.xdg.configHome}/wgetrc";
    XINITRC = "${config.xdg.configHome}/xorg/xinitrc";

    WINEPREFIX = "${config.xdg.dataHome}/wine64";
    WINEARCH = "win64";
    # Stops wine from creating filetype associations
    WINEDLLOVERRIDES = "winemenubuilder.exe=d";
  };
}
