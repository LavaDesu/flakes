self: super:
let
  lib = super.lib;
  stdenv = super.stdenv;
in {
  tree-sitter = super.tree-sitter.overrideAttrs(o: {
    passthru = o.passthru // {
      withPlugins = grammarFn:
        let
          grammars = grammarFn o.passthru.builtGrammars;
        in
        super.linkFarm "grammars"
          (map
            (drv:
              let
                name = lib.strings.getName drv;
              in
              {
                name =
                  (lib.strings.replaceStrings ["-"] ["_"]
                    (lib.strings.removePrefix "tree-sitter-"
                      (lib.strings.removeSuffix "-grammar" name)))
                  + stdenv.hostPlatform.extensions.sharedLibrary;
                path = "${drv}/parser";
              }
            )
            grammars);
    };
  });
}
