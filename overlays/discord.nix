self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.166";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "02sa34jjwwpf82w492qpk9k2jjfg2lkh1f2z4w5l0zyll6jwjikd";
    };
  };
}
