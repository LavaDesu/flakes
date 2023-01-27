{ config, ... }: {
  services.polybar =
  let
    colours = {
      background1 = "#1a1b26";
      background2 = "#9d7cd8";
      accent = "#c0caf5";
      foreground2 = "#1a1b26";
      foreground2trans = "#cc1a1b26";
    };
  in {
    enable = true;
    script = builtins.readFile ../../scripts/polybar.sh;
    settings = {
      "bar/scroller" = {
        monitor = "DisplayPort-0";
        width = "100%";
        height = 1;
        background = colours.background1;
        spacing = 2;
        override-redirect = true;

        modules.center = "workspaces-stub";
        scroll = {
          up = "#workspaces-stub.prev";
          down = "#workspaces-stub.next";
        };
      };

      "bar/top" = {
        monitor = "DisplayPort-0";
        width = "100%";
        height = 29;
        background = colours.background1;
        foreground = "#fff";
        offset-y = 3;

        spacing = 2;
        padding = {
          left = 5;
          right = 5;
          bottom = 5;
        };
        override-redirect = true;
        wm-restack = "bspwm";

        font = [
          "NotoSans:style=SemiBold:size=11:antialias=true;2"
          "NotoSans:size=11:antialias=true;2"
          "MaterialIcons:size=17:antialias=true;6"
          "Iosevka:style=Medium:antialias=false:size=19;4"

          "HanaMinA:size=9.8;1"
          "HanaMinB:size=9.8;1"
        ];

        modules = {
          left = "left workspaces right";
          center = "title";
          right = "left datetime right";
        };

        enable-ipc = true;
        scroll = {
          up = "#workspaces.prev";
          down = "#workspaces.next";
        };
      };

      "module/left" = {
        type = "custom/text";

        content = {
          text = "%{T4}";
          background = colours.background1;
          foreground = colours.background2;
        };
      };

      "module/right" = {
        type = "custom/text";

        content = {
          text = "%{T4}";
          background = colours.background1;
          foreground = colours.background2;
        };
      };

      "module/workspaces" = {
        type = "internal/bspwm";

        pin-workspaces = true;
        enable-click = true;
        enable-scroll = false;
        reverse-scroll = false;

        label = {
          monitor = "";
          focused = {
            text = "%{T3}"; # ef4a
            background = colours.background2;
            foreground = colours.accent;
          };
          occupied = {
            text = "%{T3}"; # e837
            background = colours.background2;
            foreground = colours.background1;
          };
          empty = {
            text = "%{T3}"; # ef4a
            background = colours.background2;
            foreground = colours.background1;
          };
          urgent = {
            text = "%{T3}"; # e837
            background = colours.background2;
            foreground = colours.background1;
          };

          separator = {
            text = " ";
            background = colours.background2;
            padding = "0";
          };
        };
      };

      "module/workspaces-stub" = {
        type = "internal/bspwm";
        pin-workspaces = true;
        enable-click = false;
        enable-scroll = false;
        reverse-scroll = false;
        label = {
          monitor = "";
          focused = "";
          occupied = "";
          empty = "";
          urgent = "";
          separator = "";
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
          text = "%{T1}%%{F${colours.foreground2}}%H:%M%%{F-}";
          alt = "%{T2}%%{F${colours.foreground2trans}}%A, %d %B %Y  %{T1}%%{F${colours.foreground2}}%H:%M%%{F${colours.foreground2trans}}:%{T2}%S%%{F-}";
        };
        format = {
          background = colours.background2;
        };
      };
    };
  };
}
