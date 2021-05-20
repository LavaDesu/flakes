{ config, ... }:
let
  memoryBar = {
    width = 20;
    foreground = [
      "#aaff77"
      "#aaff77"
      "#fba922"
      "#ff5555"
    ];
    indicator = {
      text = "|";
      font = 6;
      foreground = "#fff";
    };
    fill = {
      text = "─";
      font = 6;
    };
    empty = {
      text = "─";
      font = 6;
      foreground = "#444444";
    };
  };
  formatRampCoreload = text: color: {
    inherit text;
    font = 2;
    foreground = color;
  };
in {
  services.polybar = {
    enable = true;
    script = builtins.readFile ./scripts/polybar.sh;
    settings = rec {
      _base = {
        monitor = "eDP-1";
        width = "100%";
        height = 22;
        background = "#00";
        foreground = "#fff";
        line = {
          color = "#00";
          size = 1;
        };
      };

      "bar/top" = _base // {
        spacing = 2;
        padding = {
          right = 5;
          bottom = 5;
          left = 5;
        };

        font = [
          "NotoSans-Regular:size=8.2;2"
          "MaterialIcons:size=10;1"
          "FontAwesome:size=10;3"
          "NotoSans-Regular:size=10;2"
          "MaterialIcons:size=12;4"
          "FontAwesome5Brands:style=Solid:pixelsize=10;1"
          "HanaMinA:size=9.8;1"
          "HanaMinB:size=9.8;1"
        ];

        # enable-ipc = true;
        modules = {
          # left = "previous playpause next spotify";
          left = "title";
          right = "datetime";
        };
      };

      "bar/bottom" = _base // {
        bottom = true;

        spacing = 3;
        padding = {
          top = 5;
          right = 5;
        };
        module.margin = {
          left = 2;
          right = 2;
        };

        font = [
          "NotoSans-Regular:size=8.2;1"
          "unifont:size=6;1"
          "FontAwesome:size=10;1"
          "NotoSans-Regular:size=10;1"
          "MaterialIcons:size=12;4"
          "FontAwesome5Brands:style=Solid:pixelsize=10;1"
        ];

        modules = {
          left = "i3";
          right = "fs cpu memory swap wifi";
        };

        tray = {
          position = "right";
          padding = 2;
          scale = 1.1;
        };
      };

      "module/i3" = {
        type = "internal/i3";

        format = "<label-state> <label-mode>";
        strip.wsnumbers = true;
        wrapping.scroll = false;

        ws.icon = {
          text = [
            "1:code;"
            "2:web;"
            "3:discord;%{T6}"
            "4:game;"
            "8:steam;"
            "9:spotify;"
            "10:term;"
          ];
          default = "";
        };

        label = {
          mode = {
            text = "%mode%";
            padding = 5;
          };

          dimmed.underline = _base.background;

          focused = {
            text = "%icon%";
            foreground = "#fff";
            background = "#773f3f3f";
            underline = "#c9665e";
            font = 4;
            padding = 4;
          };

          unfocused = {
            text = "%icon%";
            foreground = "#fff";
            background = "#00";
            underline = "#00";
            font = 4;
            padding = 4;
          };

          visible = {
            text = "%index%";
            underline = "#555555";
            padding = 4;
          };

          urgent = {
            text = "%icon%";
            foreground = "#00";
            background = "#bd2c40";
            underline = "#9b0a20";
            font = 4;
            padding = 4;
          };
        };
      };

      "module/cpu" = {
        type = "internal/cpu";
        interval = 0.5;
        label = "CPU %percentage%%";
        format = {
          text = "<label> <ramp-coreload>";
          underline = "#00f5ff";
        };

        ramp.coreload = [
          ( formatRampCoreload "▁" "#aaff77" )
          ( formatRampCoreload "▂" "#aaff77" )
          ( formatRampCoreload "▃" "#aaff77" )
          ( formatRampCoreload "▄" "#aaff77" )
          ( formatRampCoreload "▅" "#fba922" )
          ( formatRampCoreload "▆" "#fba922" )
          ( formatRampCoreload "▇" "#ff5555" )
          ( formatRampCoreload "█" "#ff5555" )
        ];
      };

      "module/datetime" = {
        type = "internal/date";
        date = {
          text = "%{T1}%%{F#ccc}%A, %d %B %Y  %{T4}%%{F#fff}%H:%M%%{F#666}:%%{F#ccc}%S%%{F-}";
          alt = "%{T1}%%{F#ccc}%Y-%m-%d%%{F-}  %{T4}%%{F#fff}%H:%M%%{F-}";
        };
        format = {
          overline = "#fff";
          background = _base.background;
          padding = 4;
        };
      };

      "module/fs" = {
        type = "internal/fs";
        format.mounted = {
          text = "<label-mounted>";
          underline = "#ffea61";
        };
        label.mounted = "%mountpoint% %free%";
        mount = [
          "/home"
          "/mnt/hdd"
        ];
        fixed-values = true;
      };

      "module/memory" = {
        type = "internal/memory";
        format = {
          text = "<label> <bar-used>";
          underline = "#aaff77";
        };
        label = "RAM %gb_used%";

        bar.used = memoryBar;
      };

      "module/swap" = {
        type = "internal/memory";
        format = {
          text = "<label> <bar-swap-used>";
          underline = "#fba922";
        };
        label = "SWAP %gb_swap_used%";

        bar.swap.used = memoryBar;
      };

      "module/title" = {
        type = "internal/xwindow";
        format = {
          text = "%{T4}<label>";
          overline = "#fff";
          padding = 6;
        };
      };

      "module/wifi" = {
        type = "internal/network";
        interface = "wlp3s0";
        interval = 3;
        ping.interval = 30;

        format = {
          connected = "<ramp-signal>";
          packetloss = "<animation-packetloss>";
        };
        label.disconnected = {
          text = "   not connected";
          foreground = "#66";
        };

        ramp.signal = [
          ""
          ""
          ""
          ""
          ""
        ];
        animation.packetloss = {
          text = [
            {
              text = "";
              foreground = "#ffa64c";
            }
            {
              text = "";
              foreground = _base.foreground;
            }
          ];
          framerate = 500;
        };
      };
    };
  };
}
