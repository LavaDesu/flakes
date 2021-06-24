self: super:
let
  wine = super.fetchFromGitHub rec {
    owner = "wine-mirror";
    repo = "wine";
    rev = "1de583a4dac7d704b2d4291ada4a1885cd8cd1c9";
    sha256 = "0h3wgd84lvv55b4fknzkclnmkj32c5xcr7z0fgqkfghv2b0ywpnb";
  };

  staging = super.fetchFromGitHub rec {
    owner = "wine-staging";
    repo = "wine-staging";
    rev = "432c0b5a838cb8ebb52d0d37150a57e393b6f33d";
    sha256 = "0gbci8fjvl1bdz7fj4bh25mqrgi1i04q5na2ckv9hj9nh9x7crbm";
  };
in {
  wine-osu = (super.wineStaging.overrideDerivation(o: {
    patches = (o.patches or []) ++ builtins.map (e: ./misc/wine + ("/" + e)) (builtins.attrNames (builtins.readDir ./misc/wine));

    src = wine;
    postPatch = self.postPatch or "" + ''
      patchShebangs tools
      cp -r ${staging}/patches .
      chmod +w patches
      cd patches
      patchShebangs gitapply.sh
      ./patchinstall.sh DESTDIR="$PWD/.." --all
      cd ..
    '';
  })).override {
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
  };
}
