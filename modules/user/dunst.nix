{ config, pkgs, ... }:
let
  historyScript = pkgs.writeShellScript "dunst_history.sh" ''
    echo "$(${pkgs.coreutils}/bin/date +%s):$DUNST_TIMESTAMP:$DUNST_APP_NAME:$DUNST_URGENCY:$DUNST_SUMMARY:$DUNST_BODY" >> ${config.xdg.dataHome}/dunst/history
  '';
in {
  systemd.user.tmpfiles.rules = [ "d ${config.xdg.dataHome}/dunst - - - -" ];

  services.dunst = {
    enable = true;
    settings = {
      global = {
        monitor = 0;
        follow = "mouse";
        width = "(100, 450)";
        origin = "top-right";
        offset = "24x50";
        notification_limit = 0;
        indicate_hidden = true;
        shrink = true;
        separator_height = 0;
        padding = 16;
        horizontal_padding = 24;
        frame_width = 0;
        sort = false;
        idle_threshold = 60;
        font = "Open Sans 9";
        line_height = 4;
        markup = "full";
        format = "<b>%s</b>\\n%b";
        alignment = "left";
        show_age_threshold = 60;
        word_wrap = true;
        ignore_newline = false;
        stack_duplicates = false;
        hide_duplicate_count = true;
        show_indicators = false;
        icon_position = "left";
        max_icon_size = 40;
        sticky_history = true;
        history_length = 100;
        browser = "${pkgs.firefox}/bin/firefox -new-tab";
        always_run_script = true;
        title = "Dunst";
        class = "Dunst";
        corner_radius = 15;

        script = historyScript.outPath;
      };

      urgency_low = {
        background = config.catppuccin.hexcolors.crust;
        foreground = config.catppuccin.hexcolors.text;
        timeout = 3;
      };

      urgency_normal = {
        background = config.catppuccin.hexcolors.crust;
        foreground = config.catppuccin.hexcolors.text;
        timeout = 5;
      };

      urgency_critical = {
        background = config.catppuccin.hexcolors.crust;
        foreground = config.catppuccin.hexcolors.text;
        frame_color = config.catppuccin.hexcolors.red;
        timeout = 0;
      };
    };
  };
}
