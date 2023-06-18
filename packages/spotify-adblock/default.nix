{ inputs
, lib
, rustPlatform
}:
rustPlatform.buildRustPackage {
  pname = "spotify-adblock";
  version = "1.0";
  src = inputs.spotify-adblock;

  cargoSha256 = "sha256-t8OVQEp4M0H7gTGaP/2KBChRvAyhWCWV+6d/tPXa3/k=";

  patches = [ ./0002-allow-setting-config-from-environment-variable.patch ];

  postInstall = ''
    cp ${inputs.spotify-adblock}/config.toml $out/lib
  '';
}
