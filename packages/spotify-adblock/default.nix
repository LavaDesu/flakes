{ inputs
, lib
, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "1.0";
  src = inputs.spotify-adblock;

  cargoSha256 = "1dabmqjvbxdgs8im7asilv4nnx6xzcbwbiy924sci1zbd5isxgfx";
  cargoPatches = [ ./0001-cargo.patch ];

  patches = [ ./0002-allow-setting-config-from-environment-variable.patch ];

  postInstall = ''
    cp ${inputs.spotify-adblock}/config.toml $out/lib
  '';
}
