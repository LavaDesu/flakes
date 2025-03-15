self: super: {
  cascadia-code = super.cascadia-code.overrideAttrs(o: {
    installPhase = (builtins.replaceStrings ["runHook postInstall"] [""] o.installPhase) + ''
      install -Dm644 otf/static/*.otf -t $out/share/fonts/opentype
      install -Dm644 ttf/static/*.ttf -t $out/share/fonts/truetype
      rm $out/share/fonts/opentype/*NF*
      rm $out/share/fonts/truetype/*NF*
      runHook postInstall
    '';

  });
}
