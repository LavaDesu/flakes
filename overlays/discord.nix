self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.128";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "18xd2mglb75wpc9cb8p4hlydl86gyd5g15585h84x9jsr421h3bk";
    };
  };
}
