self: super:
let
  version = "2021.927.0";
in {
  osu-lazer = super.osu-lazer.overrideAttrs(old: {
    inherit version;

    src = super.fetchFromGitHub {
      owner = "ppy";
      repo = "osu";
      rev = version;
      sha256 = "+RsvOd1BXBGoeNEyRt90aYicPBspe/Ki0XWw/Cbghoo=";
    };

    buildPhase = super.lib.replaceStrings [ old.version ] [ version ] old.buildPhase;

    nugetDeps = super.linkFarmFromDrvs "${old.pname}-nuget-deps" (import ./patches/deps.nix {
      fetchNuGet = { name, version, sha256 }: super.fetchurl {
        name = "nuget-${name}-${version}.nupkg";
        url = "https://www.nuget.org/api/v2/package/${name}/${version}";
        inherit sha256;
      };
    });

    patches = [ ./patches/bypass-tamper-detection.patch ];
    patchFlags = [ "--binary" "-p1" ];
  });
}
