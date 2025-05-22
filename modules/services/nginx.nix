{ config, ... }: {
  networking.firewall.allowedTCPPorts = [ 80 443 ];
  security.acme = {
    acceptTerms = true;
    email = "me@lava.moe";
    certs."lava.moe" = {
      group = "nginx";
      domain = "lava.moe";
      extraDomainNames = [
        "*.lava.moe"
        "*.local.lava.moe"
      ];
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
  };
}
