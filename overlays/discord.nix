self: super: {
  discord-canary = super.discord-canary.override rec {
    version = "0.0.133";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "0wx8wkgkzvw9094baa3dni834l0n4p6ih024bj1851sgwwnidb0a";
    };
  };
}
