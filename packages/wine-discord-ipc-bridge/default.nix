{
  inputs,
  pkgsCross,
  stdenv
}:
stdenv.mkDerivation {
  name = "wine-discord-ipc-bridge.exe";
  src = inputs.wine-discord-ipc-bridge;

  buildInputs = [ pkgsCross.mingw32.buildPackages.gcc ];

  installPhase = ''
    cp winediscordipcbridge.exe $out
  '';
}
