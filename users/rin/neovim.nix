{ config, pkgs, ... }:
let
  vim-material = pkgs.vimUtils.buildVimPlugin {
    name = "vim-material";
    src = pkgs.fetchFromGitHub {
      owner = "hzchirs";
      repo = "vim-material";
      rev = "05461c967b861ef532c44d5348555febac94b0d5";
      sha256 = "1w59zqrx3scqsrg1a43497xybc3m4zm00kwfqpvjfw6qrpk2zb3f";
    };
  };
in {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;

    plugins = with pkgs.vimPlugins; [
      # nerdtree
      # vim-fugitive
      ale
      coc-nvim
      vim-airline
      vim-material
      vim-nix
      vim-repeat
      vim-surround

      lf-vim
      vim-floaterm
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
      set termguicolors
      hi MatchParen cterm=underline ctermbg=none ctermfg=white
      let g:material_style='oceanic'
      let g:airline_theme='material'
      set background=dark
      colorscheme vim-material

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
    '';
  };
}
