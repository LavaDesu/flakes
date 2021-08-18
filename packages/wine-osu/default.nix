{ callPackage
, getPaths
, lib
, winePackages
, wineUnstable
, wineStaging
, ...
}:
let
  sources = callPackage ./sources.nix {};
in
# TODO: Use winePackages.callPackage
(wineStaging.override {
  wineRelease = "staging";
  wineBuild = "wineWow";

  pngSupport = true;
  jpegSupport = true;
  tiffSupport = true;
  gettextSupport = true;
  fontconfigSupport = true;
  alsaSupport = true;
  gtkSupport = true;
  openglSupport = true;
  tlsSupport = true;
  gstreamerSupport = true;
  #cupsSupport = true;
  colorManagementSupport = true;
  dbusSupport = true;
  mpg123Support = true;
  #openalSupport = true;
  #openclSupport = true;
  #cairoSupport = true;
  #odbcSupport = true;
  netapiSupport = true;
  cursesSupport = true;
  vaSupport = true;
  pcapSupport = true;
  #v4lSupport = true;
  #saneSupport = true;
  gsmSupport = true;
  #gphoto2Support = true;
  #ldapSupport = true;
  pulseaudioSupport = true;
  udevSupport = true;
  xineramaSupport = true;
  xmlSupport = true;
  vulkanSupport = true;
  sdlSupport = true;
  faudioSupport = true;
  vkd3dSupport = true;
  mingwSupport = true;
}).overrideDerivation (old: {
  inherit (sources) src;
  name = "wine-osu-${sources.version}-staging";
  patches = (old.patches or []) ++ getPaths ./patches;
  postPatch = wineUnstable.postPatch or "" + ''
    patchShebangs tools
    cp -r ${sources.staging}/patches .
    chmod +w patches
    cd patches
    patchShebangs gitapply.sh
    ./patchinstall.sh DESTDIR="$PWD/.." --all ${lib.concatMapStringsSep " " (ps: "-W ${ps}") []}
    cd ..
  '';
})
