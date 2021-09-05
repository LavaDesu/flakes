{
  callPackage,
  inputs
}:
callPackage (inputs.nixpkgs + "/pkgs/development/tools/parsing/tree-sitter/grammar.nix") {} {
  language = "glimmer";
  version = "1.0.0";
  source = inputs.tree-sitter-glimmer;
}
