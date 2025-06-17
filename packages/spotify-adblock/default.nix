{ inputs
, lib
, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "1.0";
  src = inputs.spotify-adblock;

  cargoHash = "sha256-oGpe+kBf6kBboyx/YfbQBt1vvjtXd1n2pOH6FNcbF8M=";

  patches = [ ./0002-allow-setting-config-from-environment-variable.patch ];

  postInstall = ''
    cp ${inputs.spotify-adblock}/config.toml $out/lib
  '';
}
