{ ... }:
let
  dir = "/persist/jellyfin";
in
{
  fileSystems."/var/lib/jellyfin" = {
    depends = [ "/persist" ];
    device = dir;
    fsType = "none";
    options = [ "bind" ];
  };
  system.activationScripts."jellyfin-create-bind-mount" = {
    deps = [ "users" "groups" ];
    text = ''
      mkdir ${dir}
      chown jellyfin:jellyfin ${dir}
      chmod 700 ${dir}
    '';
  };
  systemd.tmpfiles.rules = [
    "d /tmp/jelly-transcodes 700 jellyfin jellyfin"
    "L+ /var/lib/jellyfin/transcodes - - - - /tmp/jelly-transcodes"
  ];
  services.jellyfin = {
    enable = true;
    openFirewall = true;
  };
}
