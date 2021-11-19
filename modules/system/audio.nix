{ config, ... }:
let
  int = {
    quantum = {
      min = 64;
      def = 1024;
      max = 2048;
    };
    rate = 48000;
  };
  str = {
    quantum = {
      min = toString int.quantum.min;
      def = toString int.quantum.def;
      max = toString int.quantum.max;
    };
    rate = toString int.rate;
  };
in {
  sound.enable = false;
  security.rtkit.enable = true;
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    jack.enable = true;

    config.pipewire = {
      "context.properties" = {
        "link.max-buffers" = 16;
        "default.clock.rate" = int.rate;
        "default.clock.quantum" = int.quantum.def;
        "default.clock.min-quantum" = int.quantum.min;
        "default.clock.max-quantum" = int.quantum.max;
        "core.daemon" = true;
        "core.name" = "pipewire-0";
      };

      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        { name = "libpipewire-module-protocol-native"; }
        { name = "libpipewire-module-profiler"; }
        { name = "libpipewire-module-metadata"; }
        { name = "libpipewire-module-spa-device-factory"; }
        { name = "libpipewire-module-spa-node-factory"; }
        { name = "libpipewire-module-client-node"; }
        { name = "libpipewire-module-client-device"; }
        {
          name = "libpipewire-module-portal";
          flags = [ "ifexists" "nofail" ];
        }
        { name = "libpipewire-module-access"; args = {}; }
        { name = "libpipewire-module-adapter"; }
        { name = "libpipewire-module-link-factory"; }
        { name = "libpipewire-module-session-manager"; }
      ];
      "stream.properties" = {
        "node.latency" = "${str.quantum.min}/${str.rate}";
        "resample.quality" = 1;
      };
    };
    config.pipewire-pulse = {
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
          flags = [ "ifexists" "nofail" ];
        }
        { name = "libpipewire-module-protocol-native"; }
        { name = "libpipewire-module-client-node"; }
        { name = "libpipewire-module-adapter"; }
        { name = "libpipewire-module-metadata"; }
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "pulse.min.req" = "${str.quantum.min}/${str.rate}";
            "pulse.default.req" = "${str.quantum.def}/${str.rate}";
            "pulse.max.req" = "${str.quantum.max}/${str.rate}";
            "pulse.min.quantum" = "${str.quantum.min}/${str.rate}";
            "pulse.max.quantum" = "${str.quantum.max}/${str.rate}";
            "server.address" = [ "unix:native" ];
          };
        }
      ];
      "stream.properties" = {
        "node.latency" = "${str.quantum.min}/${str.rate}";
        "resample.quality" = 1;
      };
    };
  };
}

