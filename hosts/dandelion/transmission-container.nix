{ lib, modules, pkgs, gcSecrets, ... }: {
  networking.nat = {
    enable = true;
    internalInterfaces = [ "ve-+" ];
    externalInterface = "enp0s6";
  };

  networking.firewall = {
    extraCommands = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -d 10.25.0.11 -p tcp -m tcp --dport 9091 -j MASQUERADE
    '';
    extraStopCommands = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -d 10.25.0.11 -p tcp -m tcp --dport 9091 -j MASQUERADE || true
    '';
  };

  services.nginx.virtualHosts."tr.dandelion.gw.lava.moe" = {
    locations."/".proxyPass = "http://10.25.0.11:9091";
  };

  containers.transmission = {
    autoStart = true;
    privateNetwork = true;
    hostAddress = "10.25.0.10";
    localAddress = "10.25.0.11";
    bindMounts."vpn" = {
      hostPath = "/persist/aus.conf";
      mountPoint = "/vpn.conf";
      isReadOnly = true;
    };
    bindMounts."transmission" = {
      hostPath = "/persist/transmission";
      mountPoint = "/persist/transmission";
      isReadOnly = false;
    };
    config = {
      system.stateVersion = "23.11";
      networking.wg-quick.interfaces.wg0 = {
        configFile = "/vpn.conf";
        preUp = ''
          # Try to access the DNS for up to 300s
          for i in {1..60}; do
            ${pkgs.iputils}/bin/ping -c1 'google.com' && break
            echo "Attempt $i: DNS still not available"
            sleep 5s
          done
        '';
      };

      networking.firewall.enable = false;
      systemd.services.transmission.serviceConfig.BindReadOnlyPaths = lib.mkForce [ builtins.storeDir "/etc" ];
      imports = [ modules.services.transmission ];
      services.transmission.settings = {
        rpc-host-whitelist-enabled = false;
        rpc-whitelist = lib.mkForce "10.100.0.*,10.0.0.*,10.25.0.*,192.168.100.*";
        rpc-username = gcSecrets.transmission.username;
        rpc-password = gcSecrets.transmission.password;
      };
    };
  };
}
