{ config, lib, pkgs, ... }: {
  systemd.user.tmpfiles.rules = [
    "D %t/vim/swap 0755 - - - -"
    "D %t/vim/undo 0755 - - - -"
  ];
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    withNodeJs = false;

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
        tree-sitter-json
        tree-sitter-lua
        tree-sitter-nix
        tree-sitter-toml
        tree-sitter-yaml
      ]))
    ];

    extraConfig = ''
      luafile ${../../res/config-minimal.lua}
    '';
  };
}
