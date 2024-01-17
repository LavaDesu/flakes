{ config, lib, pkgs, ... }:
let
  luaconf = pkgs.writeText "config.lua"
    (lib.replaceStrings
      ["{{OMNISHARP_PATH}}" "{{DART_PATH}}"]
      ["${pkgs.omnisharp-roslyn}/bin/OmniSharp" "${pkgs.dart}/bin/dart"]
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
    #package = pkgs.neovim-nightly;
    withNodeJs = true;

    extraPackages = with pkgs; [
      rust-analyzer
      nodePackages."@prisma/language-server"
      nodePackages.diagnostic-languageserver
      nodePackages.eslint_d
      nodePackages.typescript-language-server
      nodePackages.vscode-langservers-extracted
      nodePackages.yaml-language-server
    ];

    plugins = with pkgs.vimPlugins; [
      flutter-tools-nvim
      fzf-vim
      fzf-lsp-nvim
      lualine-nvim
      plenary-nvim
      tokyonight-nvim
      vim-fugitive
      vim-nix
      vim-repeat
      vim-signify
      vim-surround
      lsp_signature-nvim

      nvim-cmp
      nvim-dap
      nvim-lspconfig
      cmp-nvim-lsp
      cmp_luasnip
      luasnip

      #(pkgs.me.nvim-treesitter-nightly.withPlugins (p: with p; [
      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-bash
        tree-sitter-c
        tree-sitter-c-sharp
        tree-sitter-cpp
        tree-sitter-html
        tree-sitter-javascript
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-markdown
        tree-sitter-nix
        tree-sitter-php
        tree-sitter-prisma
        tree-sitter-python
        tree-sitter-query
        tree-sitter-regex
        tree-sitter-rust
        tree-sitter-toml
        tree-sitter-tsx
        tree-sitter-typescript
        tree-sitter-vim
        tree-sitter-vimdoc
        tree-sitter-yaml
      ]))
    ];

    extraConfig = ''
      luafile ${luaconf}
    '';
  };
}
