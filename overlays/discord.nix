self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.126";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "0apj1c4my17ca452wdga2zb82iqsbljbbg2fylfdvslx286r7dhj";
    };
  };
}
