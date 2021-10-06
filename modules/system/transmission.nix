{ config, ... }: {
  services.transmission = {
    enable = true;
    downloadDirPermissions = "775";
    settings = {
      alt-speed-down = 512;
      alt-speed-enabled = true;
      alt-speed-time-begin = 360;
      alt-speed-time-day = 127;
      alt-speed-time-enabled = true;
      alt-speed-time-end = 1380;
      alt-speed-up = 256;
      ratio-limit-enabled = true;
      rpc-host-whitelist = "${config.networking.hostName}";
      rpc-whitelist = "10.100.0.*,10.0.0.*,192.168.100.*";
    };
  };
}
