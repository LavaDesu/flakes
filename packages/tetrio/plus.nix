{
  symlinkJoin,
  stdenvNoCC,
  tetrio-desktop,
  unzip
}:
let
  version = "0.23.7";
  patchedAsar = stdenvNoCC.mkDerivation {
    inherit version;
    name = "tetrio-plus";
    src = builtins.fetchurl {
      url = "https://gitlab.com/UniQMG/tetrio-plus/uploads/e51f2fd7a1370bf4ceeecd371204c2e1/tetrio-plus_0.23.7_app.asar.zip";
      sha256 = "03nla54r6s2xhd1ipxl0ffx6q0brby1jlxdx8p2q1nw80dx4gf1l";
    };
    dontUnpack = true;

    nativeBuildInputs = [ unzip ];
    buildPhase = ''
      mkdir -p $out
      unzip $src -d $out
    '';
    dontInstall = true;
  };
in tetrio-desktop.overrideAttrs(old: {
  pname = "tetrio-desktop-plus";
  version = old.version + "+${version}";

  installPhase = old.installPhase + ''
    cp ${patchedAsar}/app.asar $out/opt/TETR.IO/resources
  '';
})
