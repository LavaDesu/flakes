{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 9091 ];
  services.transmission = {
    enable = true;
    downloadDirPermissions = "775";
    openFirewall = true;
    settings = {
      download-dir = "/persist/transmission/Downloads";
      incomplete-dir = "/persist/transmission/.incomplete";
      ratio-limit-enabled = true;
      rpc-bind-address = "0.0.0.0";
      rpc-enabled = true;
      rpc-port = 9091;
      rpc-host-whitelist = "${config.networking.hostName}";
      rpc-whitelist = "10.100.0.*,10.0.0.*,192.168.100.*";
    };
  };
}
