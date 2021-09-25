self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.131";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "087rzyivk0grhc73v7ldxxghks0n16ifrvpmk95vzaw99l9xv0v5";
    };
  };
}
