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
  };
  environment.etc."pipewire/pipewire.conf.d/99-config.conf".text = builtins.toJSON {
    "context.properties" = {
      "default.clock.rate" = int.rate;
      "default.clock.quantum" = int.quantum.def;
      "default.clock.min-quantum" = int.quantum.min;
      "default.clock.max-quantum" = int.quantum.max;
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
      }
    ];
    "stream.properties" = {
      "node.latency" = "${str.quantum.min}/${str.rate}";
      "resample.quality" = 1;
    };
  };
  environment.etc."pipewire/pipewire-pulse.conf.d/99-config.conf".text = builtins.toJSON {
      "context.modules" = [
        {
          name = "libpipewire-module-rtkit";
          args = {
            "nice.level" = -15;
            "rt.prio" = 88;
            "rt.time.soft" = 200000;
            "rt.time.hard" = 200000;
          };
        }
        {
          name = "libpipewire-module-protocol-pulse";
          args = {
            "pulse.min.req" = "${str.quantum.min}/${str.rate}";
            "pulse.default.req" = "${str.quantum.def}/${str.rate}";
            "pulse.max.req" = "${str.quantum.max}/${str.rate}";
            "pulse.min.quantum" = "${str.quantum.min}/${str.rate}";
            "pulse.max.quantum" = "${str.quantum.max}/${str.rate}";
          };
        }
      ];
      "pulse.rules" = [
        {
          # Discord notification sounds fix
          matches = [ { "application.process.binary" = ".DiscordCanary-wrapped"; } ];
          actions = {
              update-props = {
                  "pulse.min.quantum" = "1024/48000";
              };
          };
        }
      ];
      "stream.properties" = {
        "node.latency" = "${str.quantum.min}/${str.rate}";
        "resample.quality" = 1;
      };
  };
}

