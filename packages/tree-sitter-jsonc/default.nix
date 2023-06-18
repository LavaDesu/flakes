{
  callPackage,
  inputs
}:
callPackage (inputs.nixpkgs + "/pkgs/development/tools/parsing/tree-sitter/grammar.nix") {} {
  language = "jsonc";
  version = "1.0.0";
  src = inputs.tree-sitter-jsonc;
}
