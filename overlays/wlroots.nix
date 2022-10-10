self: super: {
  wlroots = super.wlroots.override {
    mesa = super.mesa.overrideAttrs(o: {
      patches = o.patches ++ [ ../hosts/blossom/mesa_mr_17182.patch ];
    });
  };
}
