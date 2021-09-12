{ config, pkgs, ... }: {
  programs.neovim = {
    enable = true;
    viAlias = true;
    vimAlias = true;
    vimdiffAlias = true;
    package = pkgs.neovim-nightly;

    plugins = with pkgs.vimPlugins; [
      coc-css
      coc-html
      coc-nvim
      coc-eslint
      coc-json
      coc-rust-analyzer
      coc-tsserver
      coc-yaml

      ctrlp-vim
      lualine-nvim
      nerdtree
      tokyonight-nvim
      vim-fugitive
      vim-nix
      vim-repeat
      vim-signify
      vim-surround

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
      set updatetime=100
      let g:yaml_recommended_style=0

      " signify
      set signcolumn=yes:3
      let g:signify_priority               = 5
      let g:signify_sign_show_count        = 0
      let g:signify_sign_add               = '┃'
      let g:signify_sign_delete            = g:signify_sign_add
      let g:signify_sign_delete_first_line = '┏━'
      let g:signify_sign_change            = g:signify_sign_add
      let g:signify_sign_change_delete     = g:signify_sign_delete

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
      nnoremap <leader>rs :source $MYVIMRC<CR>
      nnoremap <C-N> :NERDTreeToggle<CR>
      nnoremap <C-H> <C-W>h
      nnoremap <C-J> <C-W>j
      nnoremap <C-K> <C-W>k
      nnoremap <C-L> <C-W>l
      nnoremap <C-Q> :q<CR>

      nmap <silent> [g <Plug>(coc-diagnostic-prev)
      nmap <silent> ]g <Plug>(coc-diagnostic-next)
      nmap <silent> gd <Plug>(coc-definition)
      nmap <silent> gy <Plug>(coc-type-definition)
      nmap <silent> gi <Plug>(coc-implementation)
      nmap <silent> gr <Plug>(coc-references)
      nmap <leader>ref <Plug>(coc-references)
      nmap <leader>gd :Gdiff<CR>
      nmap <leader>rn <Plug>(coc-rename)
      command! -nargs=0 Sw w !doas tee % > /dev/null

      " autosave rust source files on change
      au FileType rust inoremap <silent><esc> <esc>:update<cr>
      au TextChanged,FocusLost,BufEnter *.rs silent update

      " disable read-only warning
      au BufEnter * set noro

      " set filetype=html for handlebar templates
      " au BufRead,BufNewFile *.hbs set filetype=html

      " disable empty line tildes
      set fcs=eob:\ 

      lua <<EOF
        require('nvim-treesitter.configs').setup {
          highlight = { enable = true },
          indent = { enable = false }
        }
        require('lualine').setup {
          options = {
            theme = 'tokyonight'
          }
        }

        local colors = require("tokyonight.colors").setup({})

        vim.cmd("highlight SignifySignAdd             guifg="..colors.green)
        vim.cmd("highlight SignifySignChange          guifg="..colors.orange)
        vim.cmd("highlight SignifySignDelete          guifg="..colors.red)
        vim.cmd("highlight SignifySignDeleteFirstLine guifg="..colors.red)
        vim.cmd("highlight SignifySignChangeDelete    guifg="..colors.red)
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
    "omnisharp.path" = "${pkgs.omnisharp-roslyn}/bin/omnisharp";
    "rust-analyzer.lens.enable" = false;
    "rust-analyzer.inlayHints.enable" = false;
    "rust-analyzer.serverPath" = pkgs.rust-analyzer + "/bin/rust-analyzer";
  };
}
