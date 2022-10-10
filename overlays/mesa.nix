self: super: {
  mesa = super.mesa.overrideAttrs(o: {
    patches = o.patches ++ [ ./patches/mr_17182.patch ];
  });
}
