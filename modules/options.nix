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
      type = types.nullOr types.string;
      default = null;
    };

    kbBacklightDevice = mkOption {
      type = types.nullOr types.string;
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
