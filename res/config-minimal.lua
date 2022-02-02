-- Keybindings
local map = vim.api.nvim_set_keymap
map('n', '<C-H>', '<C-W>h', { noremap = true })
map('n', '<C-J>', '<C-W>j', { noremap = true })
map('n', '<C-K>', '<C-W>k', { noremap = true })
map('n', '<C-L>', '<C-W>l', { noremap = true })
map('n', '<C-Q>', ':q<CR>', { noremap = true })

-- Autocommands
vim.cmd('au BufEnter * set noro')

-- Settings
vim.opt.relativenumber = true
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes:3"
vim.opt.title = true
vim.opt.updatetime = 0
vim.opt.clipboard:prepend('unnamedplus')

local runtimedir = os.getenv('XDG_RUNTIME_DIR')
vim.opt.directory:prepend(runtimedir..'/vim/swap//')
vim.opt.undodir:prepend(runtimedir..'/vim/undo//')
vim.opt.swapfile = true
vim.opt.undofile = true

vim.opt.hlsearch = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.incsearch = true

vim.opt.tabstop = 8
vim.opt.softtabstop = 0
vim.opt.expandtab = true
vim.opt.shiftwidth = 4
vim.opt.smarttab = true

vim.g.signify_priority               = 5
vim.g.signify_sign_show_count        = 0
vim.g.signify_sign_add               = '┃'
vim.g.signify_sign_delete            = vim.g.signify_sign_add
vim.g.signify_sign_delete_first_line = '┏━'
vim.g.signify_sign_change            = vim.g.signify_sign_add
vim.g.signify_sign_change_delete     = vim.g.signify_sign_delete

-- Theming
vim.g.tokyonight_style = 'night'
vim.cmd[[
    syntax enable
    colorscheme tokyonight
]]
local colors = require("tokyonight.colors").setup {}
vim.cmd("highlight SignifySignAdd             guifg="..colors.green)
vim.cmd("highlight SignifySignChange          guifg="..colors.orange)
vim.cmd("highlight SignifySignDelete          guifg="..colors.red)
vim.cmd("highlight SignifySignDeleteFirstLine guifg="..colors.red)
vim.cmd("highlight SignifySignChangeDelete    guifg="..colors.red)

-- Plugins
require('nvim-treesitter.configs').setup {
    highlight = { enable = true },
    indent = { enable = false }
}
require('lualine').setup {
    options = {
        theme = 'tokyonight'
    }
}

-- LSP
local nvim_lsp = require('lspconfig')

local on_attach = function(client, bufnr)
    local function buf_set_keymap(...) vim.api.nvim_buf_set_keymap(bufnr, ...) end
    local function buf_set_option(...) vim.api.nvim_buf_set_option(bufnr, ...) end

    buf_set_option('omnifunc', 'v:lua.vim.lsp.omnifunc')

    local opts = { noremap = true, silent = true }

    buf_set_keymap('n', 'gD', '<cmd>lua vim.lsp.buf.declaration()<CR>', opts)
    buf_set_keymap('n', 'gd', '<cmd>lua vim.lsp.buf.definition()<CR>', opts)
    buf_set_keymap('n', 'K', '<cmd>lua vim.lsp.buf.hover()<CR>', opts)
    buf_set_keymap('n', 'gi', '<cmd>lua vim.lsp.buf.implementation()<CR>', opts)
    buf_set_keymap('n', '<C-k>', '<cmd>lua vim.lsp.buf.signature_help()<CR>', opts)
    buf_set_keymap('n', '<space>wa', '<cmd>lua vim.lsp.buf.add_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wr', '<cmd>lua vim.lsp.buf.remove_workspace_folder()<CR>', opts)
    buf_set_keymap('n', '<space>wl', '<cmd>lua print(vim.inspect(vim.lsp.buf.list_workspace_folders()))<CR>', opts)
    buf_set_keymap('n', '<space>D', '<cmd>lua vim.lsp.buf.type_definition()<CR>', opts)
    buf_set_keymap('n', '<space>rn', '<cmd>lua vim.lsp.buf.rename()<CR>', opts)
    buf_set_keymap('n', '<space>ca', '<cmd>lua vim.lsp.buf.code_action()<CR>', opts)
    buf_set_keymap('n', 'gr', '<cmd>lua vim.lsp.buf.references()<CR>', opts)
    buf_set_keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float(0, { scope = "line" })<CR>', opts)
    buf_set_keymap('n', '[d', '<cmd>lua vim.lsp.diagnostic.goto_prev()<CR>', opts)
    buf_set_keymap('n', ']d', '<cmd>lua vim.lsp.diagnostic.goto_next()<CR>', opts)
    buf_set_keymap('n', '<space>q', '<cmd>lua vim.lsp.diagnostic.set_loclist()<CR>', opts)
    buf_set_keymap('n', '<space>f', '<cmd>lua vim.lsp.buf.formatting()<CR>', opts)
end
