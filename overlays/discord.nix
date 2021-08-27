self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.127";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "02rcnw38qran63grxzc6w8skp2qk749m63xnp6z4y6zya1aj9xbp";
    };
  };
}
