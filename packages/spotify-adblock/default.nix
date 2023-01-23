{ inputs
, lib
, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "1.0";
  src = inputs.spotify-adblock;

  cargoSha256 = "sha256-07vswkW0BZCEg8Z/cS71bbkJ546k+YI38HN5bdIqTPU=";

  patches = [ ./0002-allow-setting-config-from-environment-variable.patch ];

  postInstall = ''
    cp ${inputs.spotify-adblock}/config.toml $out/lib
  '';
}
