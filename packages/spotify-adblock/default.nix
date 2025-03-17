{ inputs
, lib
, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "1.0";
  src = inputs.spotify-adblock;

  cargoHash = "sha256-yxumYGAMObgl1u6GlbEQOKOn1DWxXN8bbT7BjiWT96o=";

  patches = [ ./0002-allow-setting-config-from-environment-variable.patch ];

  postInstall = ''
    cp ${inputs.spotify-adblock}/config.toml $out/lib
  '';
}
