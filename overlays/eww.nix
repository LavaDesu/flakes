self: super: {
  # For https://github.com/elkowar/eww/pull/280
  eww = super.eww.overrideAttrs (old: rec {
    version = "unstable-fb0e57a";
    src = self.fetchFromGitHub {
      owner = "elkowar";
      repo = "eww";
      rev = "fb0e57a0149904e76fb33807a2804d4af82350de";
      sha256 = "089rvcswr0wy05fac8xbfrws1qacqi3iialpv8sai7mzlpsw21m0";
    };
    # Use normal scroll events instead of smooth scroll ( due to https://bugzilla.gnome.org/show_bug.cgi?id=675959 )
    patches = old.patches ++ [ ./patches/eww.patch ];
    cargoSha256 = "1s7rxilqis2nbvjqjp5zarvmr9g6ndcicyx1rilgjv34qwna3mz1";
    cargoDeps = self.rustPlatform.fetchCargoTarball {
      inherit src;
      name = "${old.pname}-${version}";
      sha256 = cargoSha256;
    };
  });
}
