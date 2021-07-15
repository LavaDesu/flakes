{ config, lib, ... }: {
  services.snapper = {
    cleanupInterval = "1h";
    configs.home = {
      fstype = "btrfs";
      subvolume = "/home";
      extraConfig = lib.concatStringsSep "\n" (lib.mapAttrsToList (k: v: "${k}=${v}") {
        TIMELINE_CLEANUP = "yes";
        TIMELINE_CREATE = "yes";
        TIMELINE_MIN_AGE = "1800";
        TIMELINE_LIMIT_HOURLY = "5";
        TIMELINE_LIMIT_DAILY = "7";
        TIMELINE_LIMIT_WEEKLY = "0";
        TIMELINE_LIMIT_MONTHLY = "0";
        TIMELINE_LIMIT_YEARLY = "0";
      });
    };
  };
}
