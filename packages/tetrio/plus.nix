{
  fetchzip,
  lib,
  symlinkJoin,
  stdenvNoCC,
  tetrio-desktop,
  unzip
}:

let
  version = "0.23.7";

  patchedAsar = stdenvNoCC.mkDerivation rec {
    pname = "tetrio-plus";
    version = "0.25.3";

    src = fetchzip {
      url = "https://gitlab.com/UniQMG/tetrio-plus/uploads/684477053451cd0819e2c84e145966eb/tetrio-plus_0.25.3_app.asar.zip";
      sha256 = "sha256-GQgt4GZNeKx/uzmVsuKppW2zg8AAiGqsk2JYJIkqfVE=";
    };

    installPhase = ''
      runHook preInstall
      install app.asar $out
      runHook postInstall
    '';

    meta = with lib; {
      description = "TETR.IO customization toolkit";
      homepage = "https://gitlab.com/UniQMG/tetrio-plus";
      license = licenses.mit;
      maintainers = with maintainers; [ huantian ];
      platforms = [ "x86_64-linux" ];
    };
  };
in tetrio-desktop.overrideAttrs(old: {
  pname = "tetrio-desktop-plus";
  version = old.version + "+${version}";

  postInstall = ''
    cp ${patchedAsar} $out/opt/TETR.IO/resources/app.asar
  '';
})
