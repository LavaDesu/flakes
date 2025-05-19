self: super: {
  oci-cli = super.oci-cli.overrideAttrs(o: {
    patches = (o.patches or []) ++ [ ./patches/oci.patch ];
  });
}
