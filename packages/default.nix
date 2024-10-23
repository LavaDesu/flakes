{
  callPackage,
  inputs
}: rec {
  discord-tokyonight = callPackage ./discord-tokyonight { inherit inputs; };
  discover-overlay = callPackage ./discover { inherit inputs; };
  epson-201112j = callPackage ./epson-201112j { };
  linux-lava = callPackage ./linux-lava { inherit inputs; };
  nvim-treesitter-nightly = callPackage ./nvim-treesitter-nightly { inherit inputs; };
  packwiz = callPackage ./packwiz { inherit inputs; };
  psensor = callPackage ./psensor {  };
  spotify-adblock = callPackage ./spotify-adblock { inherit inputs; };
  tetrio-desktop = callPackage ./tetrio/base.nix { };
  tetrio-desktop-plus = callPackage ./tetrio/plus.nix { inherit tetrio-desktop; };
  tree-sitter-glimmer = callPackage ./tree-sitter-glimmer { inherit inputs; };
  tree-sitter-jsonc = callPackage ./tree-sitter-jsonc { inherit inputs; };
  wine-discord-ipc-bridge = callPackage ./wine-discord-ipc-bridge { inherit inputs; };
}
