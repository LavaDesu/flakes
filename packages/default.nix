{
  callPackage,
  inputs
}: {
  discord-tokyonight = callPackage ./discord-tokyonight { inherit inputs; };
  discover-overlay = callPackage ./discover { inherit inputs; };
  linux-lava = callPackage ./linux-lava { inherit inputs; };
  packwiz = callPackage ./packwiz { inherit inputs; };
  spotify-adblock = callPackage ./spotify-adblock { inherit inputs; };
  tree-sitter-glimmer = callPackage ./tree-sitter-glimmer { inherit inputs; };
  tree-sitter-jsonc = callPackage ./tree-sitter-jsonc { inherit inputs; };
}
