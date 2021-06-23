self: super: {
  wine-osu = (super.wineStaging.overrideDerivation(o: {
    patches = (o.patches or []) ++ builtins.attrNames (builtins.readDir ./misc/wine);
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
