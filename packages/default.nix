{
  callPackage,
  linuxLavaNixpkgs,
  inputs
}: {
  linux-lava = linuxLavaNixpkgs.callPackage ./linux-lava { inherit inputs; };
  nvim-treesitter-nightly = callPackage ./nvim-treesitter-nightly { inherit inputs; };
  psensor = callPackage ./psensor { };
  spotify-adblock = callPackage ./spotify-adblock { inherit inputs; };
  tree-sitter-jsonc = callPackage ./tree-sitter-jsonc { inherit inputs; };
  wine-discord-ipc-bridge = callPackage ./wine-discord-ipc-bridge { inherit inputs; };
}
