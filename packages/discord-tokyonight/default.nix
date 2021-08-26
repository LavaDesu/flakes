{
  inputs,
  stdenvNoCC
}:
stdenvNoCC.mkDerivation {
  pname = "discord-tokyonight";
  version = "1.0.0";
  dontUnpack = true;
  installPhase = ''
    cp -r ${inputs.discord-tokyonight} $out
    chmod u+w $out
    cp ${./powercord_manifest.json} $out/powercord_manifest.json
  '';
}
