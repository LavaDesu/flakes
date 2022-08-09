{ ... }:
let
  dir = "/persist/jellyfin";
in
{
  systemd.tmpfiles.rules = [
    "d ${dir} 700 jellyfin jellyfin"
    "L /var/lib/jellyfin - - - - ${dir}"
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
