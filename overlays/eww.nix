self: super: {
  eww = (super.eww.override { withWayland = true; }).overrideAttrs (old: rec {
    patches = old.patches ++ [
      # Use normal scroll events instead of smooth scroll ( due to https://bugzilla.gnome.org/show_bug.cgi?id=675959 )
      ./patches/eww.patch
    ];
  });
}
