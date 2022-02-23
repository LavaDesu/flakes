{ ... }:
let
  dir = "/persist/tmptsync";
in
{
  systemd = {
    services = {
      tmptsync-load = {
        before = [ "basic.target" ];
        after = [ "local-fs.target" "sysinit.target" ];
        unitConfig.DefaultDependencies = false;

        script = "${../../scripts/tmptsync.sh} load";
        wantedBy = [ "basic.target" ];
      };

      tmptsync-save = {
        script = "${../../scripts/tmptsync.sh} load";
        wantedBy = [ "basic.target" ];
      };
    };
    timers.tmptsync-save = {
      timerConfig = {
        Unit = "tmptsync-save.service";
        OnBootSec = "30mn";
        OnUnitActiveSec = "2h";
      };
    };
  };
}
