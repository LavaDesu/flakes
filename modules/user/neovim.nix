{ config, lib, pkgs, ... }:
let
  nvim-cmp = pkgs.vimUtils.buildVimPluginFrom2Nix {
    pname = "nvim-cmp";
    version = "2021-10-09";
    src = pkgs.fetchFromGitHub {
      owner = "hrsh7th";
      repo = "nvim-cmp";
      rev = "339fe9177b8eff85b21a0e118db400ab89775c28";
      sha256 = "16k9zqqhsw4z4zx1x1y34yss2k2jzq04f4mlp5xc2rwnfxi8yd93";
    };
    meta.homepage = "https://github.com/hrsh7th/nvim-cmp/";
  };
  luaconf = pkgs.writeText "config.lua"
    (lib.replaceStrings ["{{OMNISHARP_PATH}}"] ["${pkgs.omnisharp-roslyn}/bin/omnisharp"]
      (builtins.readFile ../../res/config.lua));
in {
  systemd.user.tmpfiles.rules = [
    "D %t/vim/swap 0755 - - - -"
    "D %t/vim/undo 0755 - - - -"
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    package = pkgs.neovim-nightly;
    withNodeJs = true;

    extraPackages = with pkgs; [
      rust-analyzer
      nodePackages.diagnostic-languageserver
      nodePackages.eslint_d
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      ctrlp-vim
      lualine-nvim
      nerdtree
      tokyonight-nvim
      vim-fugitive
      vim-nix
      vim-repeat
      vim-signify
      vim-surround

      nvim-cmp
      nvim-lspconfig
      cmp-nvim-lsp
      cmp_luasnip
      luasnip

      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-comment
        tree-sitter-c-sharp
        pkgs.tree-sitter-glimmer
        tree-sitter-html
        tree-sitter-javascript
        tree-sitter-jsdoc
        tree-sitter-json
        pkgs.tree-sitter-jsonc
        tree-sitter-lua
        tree-sitter-nix
        tree-sitter-php
        tree-sitter-regex
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-typescript
        tree-sitter-tsx
        tree-sitter-yaml
      ]))
    ];

    extraConfig = ''
      luafile ${luaconf}
    '';
  };
}
