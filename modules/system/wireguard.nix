{ config, lib, pkgs, ... }:
let
  port = 51820;
  serverName = "sugarcane";
  serverInterface = "ens3";

  clients = {
    blossom = {
      publicKey = "6nVhazYdmC15A/nke9VrqIg3sOBVOmqj4GEsyBq7MVo=";
      allowedIPs = [ "10.100.0.3/32" ];
    };
    strawberry = {
      publicKey = "Fkcp/VSN4Dkhly8V4hskF4lnDviA7VZHCnWf7OliFCg=";
      allowedIPs = [ "10.100.0.4/32" ];
    };
  };

  clientPeers = builtins.attrValues clients;
  serverPeer = {
    publicKey = "3ugIk2tQZXjAH9/95s63ld2WNUHQrd4Mz5jzbln6oj0=";
    allowedIPs = [ "0.0.0.0/0" ];
    endpoint = "sugarcane.lava.moe:${toString port}";
    persistentKeepalive = 25;
  };

  serverConfig = {
    nat = {
      enable = true;
      externalInterface = serverInterface;
      internalInterfaces = [ "wg0" ];
    };
    firewall = {
      allowedUDPPorts = [ port ];
    };

    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = port;

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
      listenPort = port;

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
