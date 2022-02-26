{ config, lib, pkgs, ... }:
let
  port = 51820;
  serverName = "sugarcane";
  serverInterface = "ens3";
  serverIp = "51.79.240.130";

  forwarding = {
    "80" = [ "10.100.0.2" "80" ];
    "443" = [ "10.100.0.2" "443" ];
    "22727" = [ "10.100.0.3" "7777" ];
  };

  mapForwards = type:
    builtins.concatStringsSep "\n" (
      lib.mapAttrsToList (sport: tuple:
      let
        dest = builtins.head tuple;
        dport = lib.last tuple;
      in ''
        ${pkgs.iptables}/bin/iptables -${type} PREROUTING -t nat -i ${serverInterface} -p tcp --dport ${sport} -j DNAT --to ${dest}:${dport}
        ${pkgs.iptables}/bin/iptables -${type} FORWARD -p tcp -d ${dest} --dport ${dport} -j ACCEPT
      '') forwarding
    );

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
      allowedTCPPorts = (builtins.map (s: lib.strings.toInt s) (builtins.attrNames forwarding));
      allowedUDPPorts = [ port ];
    };

    wireguard.interfaces.wg0 = {
      ips = [ "10.100.0.1/24" ];
      listenPort = port;

      postSetup = ''
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${serverInterface} -j MASQUERADE
        ${mapForwards "A"}
      '';
      postShutdown = ''
        ${pkgs.iptables}/bin/iptables -t nat -D POSTROUTING -s 10.100.0.0/24 -o ${serverInterface} -j MASQUERADE
        ${mapForwards "D"}
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
      mapRoutes = type: lib.concatMapStringsSep "\n" (r: "${pkgs.iproute2}/bin/ip route ${type} ${r} via ${routes.gateway} dev ${routes.interface}") routes.routes;
    in {
      ips = client.allowedIPs;
      listenPort = port;

      postSetup = ''
        ${mapRoutes "add"}
        ${pkgs.iptables}/bin/iptables -t nat -A POSTROUTING -s 10.100.0.0/24 -o ${serverInterface} -j MASQUERADE
      '';

      postShutdown = ''
        ${mapRoutes "del"}
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
