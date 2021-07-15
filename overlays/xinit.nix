self: super: {
  xorg = super.xorg // {
    xinit = super.xorg.xinit.overrideAttrs (old: {
      # Some info:
      # - Make startx use $XAUTHORITY as server auth files instead of .serverauth.$$
      # - Make startx respect $XINITRC and $XSERVERRC
      patches = old.patches ++ [ ./patches/startx.patch ];
    });
  };
}
