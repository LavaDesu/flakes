self: super: {
  material-icons = let version = "4.0.0"; in super.fetchFromGitHub {
    name = "material-icons-${version}";

    owner  = "google";
    repo   = "material-design-icons";
    rev    = version;

    postFetch = ''
      tar xf $downloadedFile --strip=1
      mkdir -p $out/share/fonts/opentype $out/share/fonts/truetype
      cp font/*.ttf $out/share/fonts/truetype
      cp font/*.otf $out/share/fonts/opentype
    '';
    sha256 = "05g5b8dn8vkjv98lmfgbd92wb5i8cfgc9j5f9ai86xl4r58yx10a";

    meta = with super.lib; {
      description = "System status icons by Google, featuring material design";
      homepage = "https://material.io/icons";
      license = licenses.asl20;
      platforms = platforms.all;
      maintainers = with maintainers; [ mpcsh ];
    };
  };
}
