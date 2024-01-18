self: super: {
  kotatogram-desktop = super.kotatogram-desktop.overrideAttrs(o:
  let
    lib = self.lib;
    tg_owt = o.passthru.tg_owt;
    ptg_owt = tg_owt.overrideAttrs(o: {
      patches = o.patches ++ [
        ./patches/kotato.patch # https://github.com/NixOS/nixpkgs/pull/281550
      ];
    });
  in
  {
    # If you hate this insanity, grab your pitchforks and demand the existence of "let in" in nixpkgs be void
    buildInputs = (lib.lists.remove tg_owt o.buildInputs) ++ [ ptg_owt ];
    preFixup = lib.replaceStrings [ "${tg_owt.dev}" ] [ "${ptg_owt.dev}" ] o.preFixup;
    passthru = {
      tg_owt = ptg_owt;
    };
  });
}
