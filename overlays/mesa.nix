self: super: {
  mesa = super.mesa.overrideAttrs(o: {
    patches = o.patches ++ [ ./patches/mesa_mr_17182.patch ];
  });
}
