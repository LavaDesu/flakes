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
        };
      };
      background = {
        monitor = "";
        path = "$HOME/Pictures/Wallpapers/current.png";
        blur_passes = 1;
        color = "$base";
      };
      label = [
        {
          monitor = "";
          text = "$TIME";
          color = "$text";
          font_size = 90;
          font_family = "Open Sans";
          position = "-30, 0";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = "cmd[update:43200000] date +'%A, %d %B %Y'";
          color = "$text";
          font_size = 25;
          font_family = "Open Sans";
          position = "-30, -150";
          halign = "right";
          valign = "top";
        }
        {
          monitor = "";
          text = "fprint";
          color = "$FPRINTPROMPT";
          font_size = 14;
          font_family = "Open Sans";
          position = "0, -107";
          halign = "center";
          valign = "center";
        }
      ];
      input-field = {
        monitor = "";
        size = "300, 60";
        outline_thickness = 4;
        dots_size = 0.2;
        dots_spacing = 0.2;
        dots_center = true;
        outer_color = "$accent";
        inner_color = "$surface0";
        font_color = "$text";
        fade_on_empty = false;
        placeholder_text = ''<span foreground="##$textAlpha"><i>󰌾 Logged in as </i><span foreground="##$accentAlpha">$USER</span></span>'';
        hide_input = false;
        check_color = "$accent";
        fail_color = "$red";
        fail_text = "<i>$FAIL <b>($ATTEMPTS)</b></i>";
        capslock_color = "$yellow";
        position = "0, -47";
        halign = "center";
        valign = "center";
      };
    };
  };
}
