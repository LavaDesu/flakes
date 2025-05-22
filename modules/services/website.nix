{ inputs, ... }: {
  services.nginx.virtualHosts = {
    "lava.moe" = {
      useACMEHost = "lava.moe";
      forceSSL = true;
      root = inputs.website.outPath;
    };
    "cdn.lava.moe" = {
      useACMEHost = "lava.moe";
      forceSSL = true;
      root = "/persist/cdn";
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
}
