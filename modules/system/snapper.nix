{ config, lib, ... }: {
  services.snapper = {
    cleanupInterval = "1h";
    configs.home = {
      FSTYPE = "btrfs";
      SUBVOLUME = "/home";
      TIMELINE_CLEANUP = true;
      TIMELINE_CREATE = true;
      TIMELINE_MIN_AGE = "1800";
      TIMELINE_LIMIT_HOURLY = "5";
      TIMELINE_LIMIT_DAILY = "7";
      TIMELINE_LIMIT_WEEKLY = "0";
      TIMELINE_LIMIT_MONTHLY = "0";
      TIMELINE_LIMIT_YEARLY = "0";
    };
  };
}
