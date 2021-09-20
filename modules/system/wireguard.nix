{ config, lib, pkgs, ... }:
let
  serverName = "fondue";
  serverInterface = "enp2s1";

  clients = {
    apricot = {
      publicKey = "CpQJxoDeWJr7DdhbIO09svCxP7tuG2vUwRM8U4io5ms=";
      allowedIPs = [ "10.100.0.2/32" ];
    };
    winter = {
      publicKey = "6nVhazYdmC15A/nke9VrqIg3sOBVOmqj4GEsyBq7MVo=";
      allowedIPs = [ "10.100.0.3/32" ];
    };
  };

  clientPeers = builtins.attrValues clients;
  serverPeer = {
    publicKey = "GwUO/hU/CrrmfYazqrXuAiP4kFB3ZoaMXf13N12X2SY=";
    allowedIPs = [ "10.100.0.0/24" ];
    endpoint = "fondue.lava.moe:20100";
    persistentKeepalive = 25;
  };

  serverConfig = {
    nat = {
      enable = true;
      externalInterface = serverInterface;
      internalInterfaces = [ "wg0" ];
    };

    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = 20100;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${serverInterface} -j MASQUERADE
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${serverInterface} -j MASQUERADE
      '';

      privateKeyFile = config.age.secrets."wg_${serverName}".path;
      peers = clientPeers;
    };
  };

  clientConfig = {
    wireguard.interfaces.wg0 = {
      ips = clients."${config.networking.hostName}".allowedIPs;
      listenPort = 20100;

      privateKeyFile = config.age.secrets."wg_${config.networking.hostName}".path;
      peers = [ serverPeer ];
    };
  };
in {
  networking =
    lib.mkMerge [
      (lib.mkIf (config.networking.hostName == serverName) serverConfig)
      (lib.mkIf (builtins.hasAttr config.networking.hostName clients) clientConfig)
    ];
}
