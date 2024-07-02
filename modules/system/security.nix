{ config, pkgs, ... }: {
  networking.firewall =
  let
    iptables = "${pkgs.iptables}/bin/iptables";
    genCmds = type: ''
      ${iptables} -${type} nixos-fw -p tcp --source 192.168.0.0/16 -j nixos-fw-accept ${if type == "D" then " || true" else ""}
      ${iptables} -${type} nixos-fw -p udp --source 192.168.0.0/16 -j nixos-fw-accept ${if type == "D" then " || true" else ""}
    '';
  in {
    enable = true;
    allowedUDPPortRanges = [ { from = 20000; to = 20100; } ];
    allowedTCPPortRanges = [ { from = 20000; to = 20100; } ];
    trustedInterfaces = [ "wg0" ];
    logRefusedConnections = false;

    extraCommands = genCmds "I";
    extraStopCommands = genCmds "D";
  };

  services.openssh = {
    enable = true;
    settings = {
      PermitRootLogin = "no";
      PasswordAuthentication = false;
      X11Forwarding = true;
    };

    hostKeys = [
      {
        bits = 4096;
        path = "/persist/ssh_host_rsa_key";
        rounds = 100;
        type = "rsa";
      }
      {
        path = "/persist/ssh_host_ed25519_key";
        rounds = 100;
        type = "ed25519";
      }
    ];
  };

  security = {
    polkit.enable = true;
    sudo.enable = false;
    doas = {
      enable = true;
      extraRules = [
        {
          groups = [ "wheel" ];
          keepEnv = true;
          persist = true;
        }
      ];
    };
  };
}
