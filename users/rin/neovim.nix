{ config, pkgs, ... }:
let
  tokyonight-nvim = pkgs.vimUtils.buildVimPlugin {
    name = "tokyonight-nvim";
    src = pkgs.fetchFromGitHub {
      owner = "folke";
      repo = "tokyonight.nvim";
      rev = "0ead86afe390603f9bd688103d7a5fc6724a828e";
      sha256 = "1l6hscamapmqjn1kc2hrpynwwrljdlp84g27282wfvc2i0kpj884";
    };
  };
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    package = pkgs.neovim-nightly;

    plugins = with pkgs.vimPlugins; [
      coc-nvim
      coc-eslint
      coc-json
      coc-rust-analyzer
      coc-tsserver

      ctrlp-vim
      lualine-nvim
      nerdtree
      tokyonight-nvim
      vim-nix
      vim-repeat
      vim-surround

      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-javascript
        tree-sitter-nix
        tree-sitter-typescript
        tree-sitter-yaml
      ]))
    ];
    withNodeJs = true;

    extraConfig = ''
      " configuration
      syntax enable
      set relativenumber number
      set cursorline
      set noswapfile
      set hlsearch
      set ignorecase
      set incsearch
      set title
      set clipboard^=unnamed
      set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
      set expandtab
      let g:yaml_recommended_style=0

      " theming
      let g:tokyonight_style='night'
      colorscheme tokyonight

      " using tab for trigger completion
      function! s:check_back_space() abort
        let col = col('.') - 1
        return !col || getline('.')[col - 1]  =~ '\s'
      endfunction

      inoremap <silent><expr> <Tab>
            \ pumvisible() ? "\<C-n>" :
            \ <SID>check_back_space() ? "\<Tab>" :
            \ coc#refresh()

      inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
      inoremap <silent><expr> <c-space> coc#refresh()

      " various aliases
      nnoremap <c-h> :NERDTreeToggle
      nnoremap <leader>rs :source $MYVIMRC<CR>
      nmap <leader>rn <Plug>(coc-rename)
      command! -nargs=0 Sw w !doas tee % > /dev/null

      " disable read-only warning
      au BufEnter * set noro

      " disable empty line tildes
      set fcs=eob:\ 

      lua <<EOF
        require('nvim-treesitter.configs').setup {
          highlight = { enable = true }
        }
        require('lualine').setup {
          options = {
            theme = 'tokyonight'
          }
        }
      EOF
    '';
  };
  xdg.configFile."nvim/coc-settings.json".text = builtins.toJSON {
    languageserver = {
      nix = {
        command = "rnix-lsp";
        filetypes = [ "nix" ];
      };
    };
    "eslint.enable" = true;
    "eslint.options" = {
      configFile = "./.eslintrc.json";
    };
    "rust-analyzer.lens.enable" = false;
    "rust-analyzer.inlayHints.enable" = false;
    "rust-analyzer.serverPath" = pkgs.rust-analyzer + "/bin/rust-analyzer";
  };
}
