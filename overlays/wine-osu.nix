self: super: {
  wine-osu = (super.wineStaging.overrideDerivation(o: {
    patches = (o.patches or []) ++ [
      #(builtins.fetchurl {
      #  url = "https://gist.githubusercontent.com/LavaDesu/01c0f3144526da6aed4b2deb1d10cc99/raw/304d2def1b37f1319e27428f049f22c74eea882b/winepulse-v6.5-revert-wasapifriendy.patch";
      #  sha256 = "1wjjwf1jfwafk1kdq0iw0r3hvi1h0i7ni276pv263rkkv418i8bq";
      #})
      (builtins.fetchurl {
        url = "https://gist.githubusercontent.com/LavaDesu/01c0f3144526da6aed4b2deb1d10cc99/raw/304d2def1b37f1319e27428f049f22c74eea882b/winepulse-v6.5-wasapifriendy.patch";
        sha256 = "12fhnbyl6kw284z3d6685xhcx21jmwhvibphx669qqbxj9bfk4hi";
      })
    ];
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
