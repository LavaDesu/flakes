{ config, lib, pkgs, ... }:
let
  port = 51820;
  serverName = "sugarcane";
  serverInterface = "ens3";
  serverIp = "51.79.240.130";

  routeBypass = {
    caramel = {
      gateway = "192.168.100.1";
      interface = "wlan0";
      routes = [
        serverIp
      ];
    };
    blossom = {
      gateway = "192.168.100.1";
      interface = "wlp3s0";
      routes = [
        serverIp
      ];
    };
  };

  clients = {
    caramel = {
      publicKey = "VDqcpS0lJzFgwikj61MJ1xc9P8Cuq0NXa+Hc+etn2iA=";
      allowedIPs = [ "10.100.0.2/32" ];
    };
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
    endpoint = "${serverIp}:${toString port}";
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
    wireguard.interfaces.wg0 =
    let
      client = clients."${config.networking.hostName}";
      routes = routeBypass."${config.networking.hostName}";
      mappedAdd = lib.concatMapStringsSep "\n" (r: "${pkgs.iproute2}/bin/ip route add ${r} via ${routes.gateway} dev ${routes.interface}") routes.routes;
      mappedDel = lib.concatMapStringsSep "\n" (r: "${pkgs.iproute2}/bin/ip route del ${r} via ${routes.gateway} dev ${routes.interface}") routes.routes;
    in {
      ips = client.allowedIPs;
      listenPort = port;

      postSetup = ''
        ${mappedAdd}
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${serverInterface} -j MASQUERADE
      '';

      postShutdown = ''
        ${mappedDel}
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${serverInterface} -j MASQUERADE
      '';

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
