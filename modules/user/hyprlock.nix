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
        # Time
        {
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = 90;
          font_family = "Open Sans";
          position = "-50, 0";
          halign = "right";
          valign = "top";
        }
        # Date
        {
          monitor = "";
          text = "cmd[update:43200000] date +'%A, %d %B %Y'";
          color = "$text";
          font_size = 25;
          font_family = "Open Sans";
          position = "-50, -150";
          halign = "right";
          valign = "top";
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
