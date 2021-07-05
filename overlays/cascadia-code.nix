self: super: {
  cascadia-code = let version = "2102.25"; in super.fetchzip {
    name = "cascadia-code-${version}";
    url = "https://github.com/microsoft/cascadia-code/releases/download/v${version}/CascadiaCode-${version}.zip";
    sha256 = "14qhawcf1jmv68zdfbi2zfqdw4cf8fpk7plxzphmkqsp7hlw9pzx";
    postFetch = ''
      mkdir -p $out/share/fonts/
      unzip -j $downloadedFile \*.otf -d $out/share/fonts/opentype
      unzip -j $downloadedFile \*.ttf -d $out/share/fonts/truetype
    '';
  };
}
