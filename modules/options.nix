{ config, lib, ... }:
let
  inherit (lib)
    mkOption
    types;
in {
  options.me = {
    environment = mkOption {
      type = types.enum [ "desktop" "laptop" "headless" ];
      default = "desktop";
    };

    fprint = mkOption {
      type = types.bool;
      default = false;
    };

    gui = mkOption {
      type = types.bool;
      default = config.me.environment != "headless";
    };

    batteryDevice = mkOption {
      type = with types; nullOr (uniq str);
      default = null;
    };

    kbBacklightDevice = mkOption {
      type = with types; nullOr (uniq str);
      default = null;
    };

    hasBluetooth = mkOption {
      type = types.bool;
      default = config.me.environment == "laptop";
    };

    hasWifi = mkOption {
      type = types.bool;
      default = config.me.environment == "laptop";
    };
  };
}
