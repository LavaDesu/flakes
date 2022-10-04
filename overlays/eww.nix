self: super: {
  eww = super.eww.overrideAttrs (old: rec {
    # Use normal scroll events instead of smooth scroll ( due to https://bugzilla.gnome.org/show_bug.cgi?id=675959 )
    patches = old.patches ++ [ ./patches/eww.patch ];
  });
}
