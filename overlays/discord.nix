self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.148";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "02cv8irj5rk8zpzyjknkvqkzfwfkyyvgv695i3mh3p734c7x56nr";
    };
  };
}
