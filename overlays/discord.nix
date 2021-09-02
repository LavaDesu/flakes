self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.129";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "1x49vvd363w9xyrzjgmynj2b320hzpz388fh5vpp0q0qk8q3gwkk";
    };
  };
}
