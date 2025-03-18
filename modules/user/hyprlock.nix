{ ... }: {
  programs.hyprlock = {
    enable = true;
    settings = {
      general = {
        disable_loading_bar = true;
        hide_cursor = true;
      };
      auth = {
        fingerprint = {
          enabled = true;
          ready_message = "Scan fingerprint to unlock";
        };
      };
      background = {
        monitor = "";
        color = "$base";
      };
      shape = [
        # Battery pill
        {
          monitor = "";
          size = "165, 65";
          color = "$crust";
          rounding = -1;
          halign = "right";
          valign = "top";
          position = "-595,-10";
        }
        # Time pill
        {
          monitor = "";
          size = "545, 65";
          color = "$crust";
          rounding = -1;
          halign = "right";
          valign = "top";
          position = "-40,-10";
        }
      ];
      label = [
        # Fingerprint icon
        {
            monitor = "";
            color = "$text";
            font_family = "Material Symbols Outlined";
            font_size = 64;
            halign = "center";
            valign = "top";
            position = "0, -100";
            text = "";
        }
        # Fingerprint text
        {
          monitor = "";
          color = "$text";
          text = "$FPRINTPROMPT";
          font_size = 25;
          font_family = "Open Sans";
          position = "0, -235";
          halign = "center";
          valign = "top";
        }
        # Fail text under input
        {
          monitor = "";
          color = "$red";
          font_family = "Open Sans";
          font_size = 25;
          text = "$FAIL $ATTEMPTS[]";
          position = "0, -200";
          halign = "center";
          valign = "center";
        }
        # Battery icon
        {
          monitor = "";
          text = "";
          color = "$accent";
          font_family = "Material Symbols Outlined";
          font_size = 27;
          position = "-695, -20";
          halign = "right";
          valign = "top";
        }
        # Battery percentage
        {
          monitor = "";
          text = ''cmd[update:60000] echo "<span weight='700'>$(cat /sys/class/power_supply/BATT/capacity)%</span>"'';
          color = "$text";
          font_size = 23;
          font_family = "Open Sans";
          position = "-625, -20";
          halign = "right";
          valign = "top";
        }
        # Time and Date
        {
          monitor = "";
          color = "$text";
          font_family = "Open Sans";
          font_size = 23;
          halign = "right";
          valign = "top";
          position = "-70, -20";
          text = ''cmd[update:1000] echo "<span alpha='70%' weight='550'>$(date '+%A, %d %B %Y')</span>  <span weight='700'>$(date +%H:%M)</span><span alpha='70%' weight='550'>$(date +:%S)</span>"'';
        }
      ];
      input-field = {
        monitor = "";
        size = "600, 120";
        outline_thickness = 4;
        check_color = "$peach";
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        fail_text = "";
        font_color = "$text";
        inner_color = "$crust";
        outer_color = "$base";
        placeholder_text = "Password";
        fade_on_empty = false;
        hide_input = false;
        capslock_color = "$yellow";
        position = "0, -47";
        halign = "center";
        valign = "center";
      };
    };
  };
}
