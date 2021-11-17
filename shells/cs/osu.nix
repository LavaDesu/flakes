# Flake for development on https://github.com/ppy/osu
{
  lib,
  mkShell,
  writeScript,
  stdenv,
  stdenvNoCC,

  dotnetCorePackages,

  alsa-lib,
  ffmpeg_4,
  icu,
  lltng-ust,
  numactl,
  openssl,
  SDL2
}:
let
  baseBuild = "-f net5.0 -v minimal /property:Version=$OSU_VERSION osu.Desktop -- $@";

  deps = [
    alsa-lib ffmpeg_4 icu lttng-ust numactl openssl SDL2 
  ];

  fixSdl = writeScript "osu-fixsdl" ''
    ln -sft osu.Desktop/bin/Debug/net5.0/linux-x64/ ${SDL2}/lib/libSDL2${stdenv.hostPlatform.extensions.sharedLibrary}
    ln -sft osu.Desktop/bin/Release/net5.0/linux-x64/ ${SDL2}/lib/libSDL2${stdenv.hostPlatform.extensions.sharedLibrary}
  '';
  buildScript = writeScript "osu-build" ''
    rm -f osu.Desktop/bin/Debug/net5.0/linux-x64/libSDL2.so
    dotnet build -c Debug -r linux-x64 ${baseBuild} && ${fixSdl}
  '';
  buildReleaseScript = writeScript "osu-build-rel" ''
    rm -f osu.Desktop/bin/Release/net5.0/linux-x64/libSDL2.so
    dotnet build -c Release -r linux-x64 ${baseBuild} && ${fixSdl}
  '';
  publishScript = writeScript "osu-publish" ''
    rm -f osu.Desktop/bin/Release/net5.0/linux-x64/libSDL2.so
    dotnet publish -c Release -r linux-x64 --self-contained false ${baseBuild} && ${fixSdl}
  '';
  publishWinScript = writeScript "osu-publish-win" ''
    dotnet publish -c Release -r win-x64 --self-contained false -o build-win ${baseBuild}
  '';
  runScript = writeScript "osu-run" ''
    ${buildScript} && dotnet run --no-build -c Debug -f net5.0 -r linux-x64 -p osu.Desktop -v minimal -- $@
  '';
  runReleaseScript = writeScript "osu-run-rel" ''
    ${buildReleaseScript} && dotnet run --no-build -c Release -f net5.0 -r linux-x64 -p osu.Desktop -v minimal -- $@
  '';

  scripts = stdenvNoCC.mkDerivation {
    pname = "osu-scripts";
    version = "1.0.0";
    dontUnpack = true;
    installPhase = ''
      mkdir $out
      cp ${fixSdl} $out/osu-fixsdl
      cp ${buildScript} $out/osu-build
      cp ${buildReleaseScript} $out/osu-build-rel
      cp ${publishScript} $out/osu-publish
      cp ${publishWinScript} $out/osu-publish-win
      cp ${runScript} $out/osu-run
      cp ${runReleaseScript} $out/osu-run-rel
    '';
  };
in mkShell {
  nativeBuildInputs = [
    icu

    (with dotnetCorePackages; combinePackages [ sdk_5_0 runtime_5_0 ])
  ];

  DOTNET_CLI_TELEMETRY_OPTOUT = 1;
  DRI_PRIME = 1;
  LD_LIBRARY_PATH = lib.makeLibraryPath deps;
  shellHook = ''
    export PATH="${scripts}:$PATH"
  '';
}
