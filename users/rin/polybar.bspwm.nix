{ config, ... }: {
  services.polybar = {
    enable = true;
    script = builtins.readFile ./scripts/polybar.sh;
    settings = {
      "bar/top" = {
        monitor = "eDP-1";
        width = "100%";
        height = 35;
        #background = "#64506c";
        background = "#10000000";
        foreground = "#fff";

        spacing = 2;
        padding = {
          left = 5;
          right = 5;
          bottom = 5;
        };

        font = [
          "NotoSans:style=Regular:size=11:antialias=true;2"
          "NotoSans:size=11:antialias=true;2"
          "MaterialIcons:size=17:antialias=true;6"

          "HanaMinA:size=9.8;1"
          "HanaMinB:size=9.8;1"
        ];

        modules = {
          left = "workspaces";
          center = "title";
          right = "datetime";
        };

        enable-ipc = true;
        scroll = {
          up = "#workspaces.prev";
          down = "#workspaces.next";
        };
      };

      "module/workspaces" = {
        type = "internal/bspwm";

        pin-workspaces = true;
        enable-click = false;
        enable-scroll = false;
        reverse-scroll = false;

        #ws-icon.default = "%{T3}"; # ef4a
        label = {
          monitor = "";
          focused = "%{T3}"; # ef4a
          occupied = {
            text = "%{T3}"; # e837
            foreground = "#B0FFFFFF";
          };
          empty = {
            text = "%{T3}"; # ef4a
            foreground = "#B0FFFFFF";
          };
          urgent = {
            text = "%{T3}"; # e837
            foreground = "#EE1012";
          };

          separator = {
            text = " ";
            padding = "0";
          };
        };
      };

      "module/title" = {
        type = "internal/xwindow";
        format = {
          text = "%{T1}<label>";
          padding = 4;
        };
      };

      "module/datetime" = {
        type = "internal/date";
        date = {
          text = "%{T2}%%{F#fff}%H:%M%%{F-}";
          alt = "%{T2}%%{F#ccc}%A, %d %B %Y  %%{F#fff}%H:%M%%{F#666}:%%{F#ccc}%S%%{F-}";
        };
        format = {
          padding = 4;
        };
      };
    };
  };
}
