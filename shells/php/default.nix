{
  callPackage,
  mkShell,
  php80,
  php80Packages,
}:
mkShell {
  buildInputs = [
    php80
    php80Packages.composer
  ];

  passthru = {
    osu-web = callPackage ./osu-web.nix {};
  };
}
