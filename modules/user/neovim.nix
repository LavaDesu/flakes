{ config, lib, pkgs, ... }:
let
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

      (pkgs.me.nvim-treesitter-nightly.withPlugins (p: with p; [
        tree-sitter-comment
        tree-sitter-c-sharp
        pkgs.me.tree-sitter-glimmer
        tree-sitter-html
        tree-sitter-javascript
        tree-sitter-jsdoc
        tree-sitter-json
        pkgs.me.tree-sitter-jsonc
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
