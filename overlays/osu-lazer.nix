self: super:
let
  version = "2021.1120.0";
in rec {
  osu-lazer-unwrapped = super.osu-lazer.overrideAttrs(old: {
    inherit version;
    pname = "osu-lazer-unwrapped";

    src = super.fetchFromGitHub {
      owner = "ppy";
      repo = "osu";
      rev = version;
      sha256 = "1mp379vbvmgcsq2cmhk4pci92ks4p88fig6lax32nsyfjcmnpyn0";
    };

    buildPhase = super.lib.replaceStrings [ old.version ] [ version ] old.buildPhase;

    postInstall = ''
      chmod -R 755 $out/share/applications
      rm -r $out/share/applications
    '';

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

  osu-lazer =
  let
    startScript = super.writeShellScript "osu-lazer" ''
      DRI_PRIME=1 vblank_mode=0 PIPEWIRE_LATENCY=64/48000 ${super.pipewire}/bin/pw-jack ${osu-lazer-unwrapped.outPath}/bin/osu\!
    '';
    desktopEntry = super.makeDesktopItem {
      desktopName = "osu!";
      name = "osu-lazer";
      exec = startScript.outPath;
      icon = "osu!";
      comment = osu-lazer-unwrapped.meta.description;
      type = "Application";
      categories = "Game;";
    };
  in desktopEntry;
}
