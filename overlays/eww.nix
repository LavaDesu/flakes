self: super: {
  eww = super.eww.overrideAttrs (old: rec {
    patches = old.patches ++ [
      # Use normal scroll events instead of smooth scroll ( due to https://bugzilla.gnome.org/show_bug.cgi?id=675959 )
      ./patches/eww.patch
      # Backport https://github.com/elkowar/eww/pull/711
      ./patches/eww-box.patch
    ];
  });
}
