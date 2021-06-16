self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.125";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "0ly5a6l7rvl54mc39xma14jrcrf11q3ndnkkr16by5hy3palmz9g";
    };
  };
}
