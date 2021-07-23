self: super: {
  osu-lazer = super.osu-lazer.overrideAttrs(o: {
    patches = [ ./patches/bypass-tamper-detection.patch ];
  });
}
