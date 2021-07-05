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
    package = pkgs.neovim-nightly;

    plugins = with pkgs.vimPlugins; [
      coc-nvim
      coc-eslint
      coc-json
      coc-rust-analyzer
      coc-tsserver
      coc-yaml

      ctrlp-vim
      nerdtree
      vim-airline
      vim-material
      vim-nix
      vim-repeat
      vim-surround

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
      set cursorline
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
      let g:material_style='oceanic'
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
      nnoremap <c-h> :NERDTreeToggle
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
