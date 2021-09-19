self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.130";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "1razxxx16bjzhv9909qa08dmlmgg7ji1vckvkggw7syi125r5aai";
    };
  };
}
