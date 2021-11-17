{
  inputs,
  mkShell,

  pkg-config
}:
let
  overlays = [ (import inputs.rust-overlay) ];
  pkgs = import inputs.nixpkgs {
    inherit system overlays;
  };

  toolchain = pkgs.rust-bin.fromRustupToolchainFile ./rust-toolchain;

  rustPlatform = pkgs.makeRustPlatform {
    inherit (toolchain) cargo rustc;
  };
in mkShell {
  nativeBuildInputs = [
    toolchain
    pkg-config
  ];

  RUST_SRC_PATH = "${pkgs.rust.packages.stable.rustPlatform.rustLibSrc}";
}
