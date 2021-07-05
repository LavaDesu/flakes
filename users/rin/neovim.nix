{ config, pkgs, ... }:
let
  vim-material = pkgs.vimUtils.buildVimPlugin {
    name = "vim-material";
    src = pkgs.fetchFromGitHub {
      owner = "kaicataldo";
      repo = "material.vim";
      rev = "7dfa4bbf1fe43fcebcd836ef4f3b1342b4ea69be";
      sha256 = "1ihakmh07j47rzy76242zbipcgdn4yh5bivz09469hr1jj2snyj3";
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
      coc-yaml

      nerdtree
      vim-airline
      vim-material
      vim-nix
      vim-repeat
      vim-surround

      lf-vim
      vim-floaterm
      (nvim-treesitter.withPlugins (p: with p; [
        tree-sitter-nix
        tree-sitter-typescript
      ]))
    ];
    withNodeJs = true;

    extraConfig = ''
      " configuration
      syntax enable
      set relativenumber number
      set noswapfile
      set hlsearch
      set ignorecase
      set incsearch
      set title
      set clipboard^=unnamed
      set tabstop=8 softtabstop=0 expandtab shiftwidth=4 smarttab
      set expandtab

      " theming
      hi MatchParen cterm=underline ctermbg=none ctermfg=white
      set termguicolors
      let g:airline_theme='material'
      let g:material_terminal_italics = 1
      let g:material_theme_style = 'ocean'
      colorscheme material

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
      nnoremap <c-p> :Lf<CR>
      nnoremap <leader>r :source $MYVIMRC<CR>
      command! -nargs=0 Sw w !doas tee % > /dev/null

      " disable read-only warning
      au BufEnter * set noro

      " disable empty line tildes
      set fcs=eob:\ 

      lua <<EOF
        require'nvim-treesitter.configs'.setup {
          highlight = { enable = true }
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
