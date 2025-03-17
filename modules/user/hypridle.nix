{ config, lib, pkgs, ... }:
let
  kblight = "light -s sysfs/leds/asus::kbd_backlight";
in
{
  home.packages = [ config.services.hypridle.package ];
  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "pidof hyprlock || hyprlock";
        before_sleep_cmd = "${lib.getExe pkgs.playerctl} pause; loginctl lock-session";
        after_sleep_cmd = "hyprctl dispatch dpms on";
      };

      listener = [
        {
          timeout = 120;
          on-timeout = "${kblight} -O && ${kblight} -S 0";
          on-resume = "${kblight} -I";
        }
        {
          timeout = 150;
          on-timeout = "light -O && light -T 0.5";
          on-resume = "light -I";
        }
        {
          timeout = 180;
          on-timeout = "light -I && loginctl lock-session";
        }
        {
          timeout = 195;
          on-timeout = "hyprctl dispatch dpms off";
          on-resume = "hyprctl dispatch dpms on";
        }
        {
          timeout = 600;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
