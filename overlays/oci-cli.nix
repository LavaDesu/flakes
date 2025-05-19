self: super: {
  oci-cli = super.oci-cli.overrideAttrs(o: {
    patches = o.patches ++ [ ./patches/oci.patch ];
  });
}
