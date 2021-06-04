self: super: {
  xorg = super.xorg // {
    xinit = super.xorg.xinit.overrideAttrs(o: {
      # Some info:
      # - Make startx use $XAUTHORITY as server auth files instead of .serverauth.$$
      # - Make startx respect $XINITRC and $XSERVERRC
      patches = o.patches ++ [ ./misc/startx.patch ];
    });
  };
}
