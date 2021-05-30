{ config, pkgs, ... }:
let
  super = "Mod4";
  alt = "Mod1";

  mkGapsMode = mode: {
    "plus"  = "gaps ${mode} current plus 5";
    "minus" = "gaps ${mode} current minus 5";
    "0"     = "gaps ${mode} current set 0";
    "Shift+plus"  = "gaps ${mode} all plus 5";
    "Shift+minus" = "gaps ${mode} all minus 5";
    "Shift+0"     = "gaps ${mode} all set 0";
    "Return" = "mode gapsMode";
    "Escape" = "mode default";
  };
  genGapsModes = modes: builtins.listToAttrs (builtins.map (mode: {
    name = mode;
    value = mkGapsMode mode;
  }) modes);
  genColors = states: builtins.listToAttrs (builtins.map (state: {
    name = state;
    value = {
      background = "#2f343f";
      border = "#2f343f";
      childBorder = "#2f343f";
      indicator = "#2f343f";
      text = "#d8dee8";
    };
  }) states);

in rec {
  xsession.windowManager.i3 = {
    enable = true;
    package = pkgs.i3-gaps;

    config = {
      startup = [
        {
          # HACK: what is this lol
          command = "systemctl --user restart polybar";
          always = true;
          notification = false;
        }
        {
          command = "feh --no-fehbg --bg-fill ${config.xdg.configHome}/xorg/wallpaper.png";
          always = true;
          notification = false;
        }
      ];

      fonts = {
        names = [
          "Open Sans"
          "HanaMinA"
          "HanaMinB"
        ];
        style = "Regular";
        size = 8.0;
      };

      floating = {
        titlebar = false;
        modifier = super;
        border = 0;
      };

      window.border = 0;
      bars = [];

      gaps = {
        smartGaps = true;
        inner = 5;
      };

      colors = genColors [
        "focused"
        "focusedInactive"
        "unfocused"
        "urgent"
        "placeholder"
      ] // { background = "#2f343f"; };
      #colors.focused.background = "#1d242f";

      modifier = super;
      keybindings = {
        # Rofi (App launcher)
        "${super}+Return" = "exec rofi -lines 12 -padding 18 -width 60 -location 0 -show drun -sidebar-mode -columns 3 -font 'Noto Sans 8'";

        # Printscreen
        "Print" = "exec maim -us | tee ~/Pictures/Screenshots/$(date +%s)c.png | xclip -selection clipboard -t image/png";
        "Shift+Print" = "exec maim -u | tee ~/Pictures/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png";

        # Quick-kill picom
        "${super}+p" = "exec systemctl --user stop picom";
        "${super}+Shift+p" = "exec systemctl --user restart picom";

        # Volume
        "XF86AudioRaiseVolume" = "exec pamixer -i 5%";
        "XF86AudioLowerVolume" = "exec pamixer -d 5%";
        "XF86AudioMute" = "exec pamixer -t";

        # Brightness
        "XF86MonBrightnessUp" = "exec light -A 10";
        "XF86MonBrightnessDown" = "exec light -U 10";
        "Shift+XF86MonBrightnessUp" = "exec light -A 1";
        "Shift+XF86MonBrightnessDown" = "exec light -U 1";
        "Ctrl+XF86MonBrightnessUp" = "exec xgamma -gamma 1.3";
        "Ctrl+XF86MonBrightnessDown" = "exec xgamma -gamma 1";

        # Music control
        # "XF86AudioNext" = "exec mpc next";
        # "XF86AudioPrev" = "exec mpc prev";
        # "XF86AudioPlay" = "exec mpc toggle";
        # "XF86AudioStop" = "exec mpc stop";

        # Kill focused window
        "${super}+c" = "kill";
        "${alt}+F4" = "kill";

        # Change focus
        "${super}+Left" = "focus left";
        "${super}+Down" = "focus down";
        "${super}+Up" = "focus up";
        "${super}+Right" = "focus right";
        "${super}+h" = "focus left";
        "${super}+j" = "focus down";
        "${super}+k" = "focus up";
        "${super}+l" = "focus right";

        # Move focused window
        "${super}+Shift+Left" = "move left";
        "${super}+Shift+Down" = "move down";
        "${super}+Shift+Up" = "move up";
        "${super}+Shift+Right" = "move right";
        "${super}+Shift+h" = "move left";
        "${super}+Shift+j" = "move down";
        "${super}+Shift+k" = "move up";
        "${super}+Shift+l" = "move right";

        # Change split modes
        "${super}+b" = "split h";
        "${super}+v" = "split v";
        "${super}+s" = "layout toggle split";
        "${super}+w" = "layout tabbed";

        # Enter fullscreen
        "${super}+f" = "fullscreen toggle";

        # Toggle floating windows
        "${super}+space" = "floating toggle";

        # Restart / Exit i3
        "${super}+Shift+r" = "restart";
        "${super}+q" = "exec i3-nagbar -m 'Exit?' -b 'Yes' 'i3-msg exit'";

        # Modes
        "${super}+r" = "mode Resize";
        "${super}+Shift+g" = "mode Gaps";

        # Workspace switching
        "${super}+1" = "workspace number $ws1";
        "${super}+2" = "workspace number $ws2";
        "${super}+3" = "workspace number $ws3";
        "${super}+4" = "workspace number $ws4";
        "${super}+5" = "workspace number $ws5";
        "${super}+6" = "workspace number $ws6";
        "${super}+7" = "workspace number $ws7";
        "${super}+8" = "workspace number $ws8";
        "${super}+9" = "workspace number $ws9";
        "${super}+0" = "workspace number $ws10";
        "${alt}+Control+Left" = "workspace prev";
        "${alt}+Control+Right" = "workspace next";
        "${alt}+Control+h" = "workspace prev";
        "${alt}+Control+l" = "workspace next";

        "${super}+Shift+1" = "move container to workspace number $ws1";
        "${super}+Shift+2" = "move container to workspace number $ws2";
        "${super}+Shift+3" = "move container to workspace number $ws3";
        "${super}+Shift+4" = "move container to workspace number $ws4";
        "${super}+Shift+5" = "move container to workspace number $ws5";
        "${super}+Shift+6" = "move container to workspace number $ws6";
        "${super}+Shift+7" = "move container to workspace number $ws7";
        "${super}+Shift+8" = "move container to workspace number $ws8";
        "${super}+Shift+9" = "move container to workspace number $ws9";
        "${super}+Shift+0" = "move container to workspace number $ws10";
      };

      modes = {
        "Resize" = {
          "Left" = "resize shrink width 5 px or 5 ppt";
          "Down" = "resize grow height 5 px or 5 ppt";
          "Up" = "resize shrink height 5 px or 5 ppt";
          "Right" = "resize grow width 5 px or 5 ppt";
          "Return" = "mode default";
        };
        "Gaps" = {
          "o"      = "mode Outer";
          "i"      = "mode Inner";
          "h"      = "mode Horizontal";
          "v"      = "mode Vertical";
          "t"      = "mode Top";
          "r"      = "mode Right";
          "b"      = "mode Bottom";
          "l"      = "mode Left";
          "Return" = "mode Gaps";
          "Escape" = "mode default";
        };
      } // genGapsModes [
        "Outer"
        "Inner"
        "Horizontal"
        "Vertical"
        "Top"
        "Right"
        "Bottom"
        "Left"
      ];
    };

    extraConfig = ''
      set $ws1 "1:code"
      set $ws2 "2:web"
      set $ws3 "3:discord"
      set $ws4 "4:game"
      set $ws5 "5"
      set $ws6 "6"
      set $ws7 "7"
      set $ws8 "8:steam"
      set $ws9 "9:spotify"
      set $ws10 "10:term"
    '';
  };
}
