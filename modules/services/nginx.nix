{ config, inputs, ... }: {
  security.acme = {
    acceptTerms = true;
    email = "me@lava.moe";
    certs."lava.moe" = {
      group = "nginx";
      domain = "*.lava.moe";
      extraDomainNames = [ "lava.moe" ];
      dnsProvider = "cloudflare";
      credentialsFile = config.age.secrets."acme_dns".path;
    };
  };

  services.nginx = {
    enable = true;
    recommendedTlsSettings = true;
    recommendedOptimisation = true;
    recommendedGzipSettings = true;
    recommendedProxySettings = true;

    virtualHosts = {
      "lava.moe" = {
        useACMEHost = "lava.moe";
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
