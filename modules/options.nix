{ config, lib, ... }: {
  options.me = {
    environment = lib.mkOption {
      type = lib.types.enum [ "desktop" "laptop" "headless" ];
      default = "desktop";
    };

    fprint = lib.mkOption {
      type = lib.types.bool;
      default = false;
    };

    gui = lib.mkOption {
      type = lib.types.bool;
      default = config.me.environment != "headless";
    };
  };
}
