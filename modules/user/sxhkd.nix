{ config, pkgs, ... }:
let
  super = "Mod4";
  alt = "Mod1";
in {
  services.sxhkd = {
    enable = true;
    keybindings = {
      # Dunst (Notification daemon)
      "super + {_,shift + }space" = "dunstctl close{_,-all}";
      "super + grave" = "dunstctl history-pop";
      "super + shift + period" = "dunstctl context";

      # Rofi (App launcher)
      "super + Return" = "rofi -lines 12 -padding 18 -width 60 -location 0 -show drun -sidebar-mode -columns 3 -font 'Noto Sans 8'";

      # Printscreen
      "Print" = "maim -us | tee ~/Pictures/Screenshots/$(date +%s)c.png | xclip -selection clipboard -t image/png";
      "shift + Print" = "maim -u | tee ~/Pictures/Screenshots/$(date +%s).png | xclip -selection clipboard -t image/png";

      # Quick-kill picom
      "super + p" = "systemctl --user stop picom";
      "super + shift + p" = "systemctl --user restart picom";

      # Volume
      "XF86Audio{RaiseVolume,LowerVolume,Mute}" = "pamixer -{i 5,d 5,t}";

      # Brightness
      "XF86MonBrightness{Up,Down}" = "light -{A,U} 10";
      "shift + XF86MonBrightness{Up,Down}" = "light -{A,U} 1";

      # Gamma
      "ctrl + XF86MonBrightness{Up,Down}" = "xgamma -gamma {1.3,1}";

      # Kill focused window
      "super + {_,shift + }c" = "bspc node -{c,k}";

      # Change focus
      "super + {h,j,k,l}" = "bspc node -f {west,south,north,east}";
      "super + {Left,Down,Up,Right}" = "bspc node -f {west,south,north,east}";

      # Switch windows
      "super + shift + {h,j,k,l}" = "bspc node -s {west,south,north,east}";
      "super + shift + {Left,Down,Up,Right}" = "bspc node -s {west,south,north,east}";

      # Move focused window
      "super + shift + {1-9,0}" = "bspc node -d ^{1-9,10}";

      # Toggle tiled/fullscreen/floating
      "super + {t,f,space}" = "bspc node -t '~{tiled,fullscreen,floating}'";

      # Exit / Restart bspwm
      "super + shift + {q,r}" = "bspc {quit,wm -r}";

      # Restart sxhkd
      "super + shift + s" = "pkill -USR1 -x sxhkd";

      # Workspace switching
      "super + {1-9,0}" = "bspc desktop -f ^{1-9,10}";
    };
  };
}
