{
  callPackage,
  lib,
  mkShell,
  dotnetCorePackages
}:
mkShell {
  nativeBuildInputs = [ (with dotnetCorePackages; combinePackages [ sdk_6_0 runtime_6_0 ]) ];
  DOTNET_CLI_TELEMETRY_OPTOUT = 1;

  passthru = {
    osu = callPackage ./osu.nix {};
  };
}
