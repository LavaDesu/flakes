{ callPackage, inputs }: {
  cs = callPackage ./cs {};
  flutter = callPackage ./flutter {};
  js = callPackage ./js {};
  php = callPackage ./php {};
  rust = callPackage ./rust { inherit inputs; };
}
