{ ... }: {
  security.acme.acceptTerms = true;
  security.acme.email = "me@lava.moe";
  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "lava.moe" = {
        enableACME = true;
        forceSSL = true;

        locations."/".extraConfig = ''
          return 404;
        '';
      };
    };
  };
}
