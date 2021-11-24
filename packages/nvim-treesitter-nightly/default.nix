{
  inputs,
  tree-sitter,
  vimPlugins
}:
let
  nvim-treesitter-nightly = vimPlugins.nvim-treesitter.overrideAttrs(_: {
    pname = "nvim-treesitter-nightly";
    version = inputs.nvim-treesitter.lastModifiedDate;
    src = inputs.nvim-treesitter;
  });
in nvim-treesitter-nightly.overrideAttrs(o: {
  passthru = o.passthru // {
    unwrapped = nvim-treesitter-nightly;
    withPlugins = grammarFn: nvim-treesitter-nightly.overrideAttrs (_: {
      postPatch =
        let
          grammars = tree-sitter.withPlugins grammarFn;
        in
        ''
          rm -r parser
          ln -s ${grammars} parser
        '';
    });
  };
})
