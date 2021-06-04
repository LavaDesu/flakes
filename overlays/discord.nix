self: super: {
  discord-canary = (super.discord-canary.override rec {
    version = "0.0.124";
    src = builtins.fetchurl {
      url = "https://dl-canary.discordapp.net/apps/linux/${version}/discord-canary-${version}.tar.gz";
      sha256 = "060ypr9rn5yl8iwh4v3ax1v6501yaq72sx50q47sm0wyxn7gpv91";
    };
  }).overrideAttrs(o: {
    # TODO: delete this when upstream
    nativeBuildInputs = o.nativeBuildInputs ++ [ super.xorg.libxshmfence ];
  });
}
