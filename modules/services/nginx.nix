{ inputs, ... }: {
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
        root = inputs.website.outPath;
      };
      "_" = {
        default = true;
        addSSL = true;
        # TODO generate this somewhere
        sslCertificate = "/persist/fakeCerts/fake.crt";
        sslCertificateKey = "/persist/fakeCerts/fake.key";
        extraConfig = ''
          return 444;
        '';
      };
    };
  };
}
