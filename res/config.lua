-- Keybindings
local map = vim.api.nvim_set_keymap
map('n', '<C-H>', '<C-W>h', { noremap = true })
map('n', '<C-J>', '<C-W>j', { noremap = true })
map('n', '<C-K>', '<C-W>k', { noremap = true })
map('n', '<C-L>', '<C-W>l', { noremap = true })
map('n', '<C-Q>', ':q<CR>', { noremap = true })

-- Autocommands
vim.cmd('au BufEnter * set noro')
vim.cmd('au CursorHold * lua vim.diagnostic.open_float(0, { scope = "line", focusable = false })')
vim.cmd('au CursorHoldI * silent! lua vim.lsp.buf.signature_help({ focusable = false })')

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

-- Set this specific highlight group in rust
-- Shown when using #[cfg] directives, entire chunks of disabled code has squiggly lines and I don't want
-- to see it
vim.cmd("au FileType rust highlight DiagnosticUnderlineHint ctermfg=14 gui=italic guifg="..colors.comment)

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

-- Block comments indent workaround
-- many thanks to @kristijanhusak
-- https://github.com/nvim-treesitter/nvim-treesitter/issues/1167#issuecomment-920824125
function _G.javascript_indent()
  local line = vim.fn.getline(vim.v.lnum)
  local prev_line = vim.fn.getline(vim.v.lnum - 1)
  if line:match('^%s*[%*/]%s*') then
    if prev_line:match('^%s*%*%s*') then
      return vim.fn.indent(vim.v.lnum - 1)
    end
    if prev_line:match('^%s*/%*%*%s*$') then
      return vim.fn.indent(vim.v.lnum - 1) + 1
    end
  end

  return vim.fn['GetJavascriptIndent']()
end

vim.cmd('au FileType javascript setlocal indentexpr=v:lua.javascript_indent()')

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

vim.lsp.handlers["textDocument/publishDiagnostics"] = vim.lsp.with(
    vim.lsp.diagnostic.on_publish_diagnostics, {
        focusable = false,
        virtual_text = false,
        underline = true,
        signs = true,
        update_in_insert = true
    }
)
vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(
    vim.lsp.handlers.signature_help, { focusable = false }
)

local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true
capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

local servers = { 'cssls', 'html', 'rnix', 'rust_analyzer', 'tsserver', 'yamlls' }
for _, lsp in ipairs(servers) do
    nvim_lsp[lsp].setup {
        capabilities = capabilities,
        on_attach = on_attach,
        flags = {
            debounce_text_changes = 150,
        }
    }
end

-- nvim-cmp
local luasnip = require('luasnip')
local cmp = require('cmp')
cmp.setup {
    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end
    },
    mapping = {
        ['<C-n>'] = cmp.mapping.select_next_item(),
        ['<C-N>'] = cmp.mapping.select_prev_item(),
        ['<C-d>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.close(),
        ['<CR>'] = cmp.mapping.confirm {
            behavior = cmp.ConfirmBehavior.Replace,
            select = true,
        },
        ['<Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-expand-or-jump', true, true, true), '')
            else
                fallback()
            end
        end,
        ['<S-Tab>'] = function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                vim.fn.feedkeys(vim.api.nvim_replace_termcodes('<Plug>luasnip-jump-prev', true, true, true), '')
            else
                fallback()
            end
        end
    },
    sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' }
    }
}

-- LSP/Omnisharp
local pid = vim.fn.getpid()
require'lspconfig'.omnisharp.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    cmd = { "{{OMNISHARP_PATH}}", "--languageserver", "--hostPID", tostring(pid) }
}

-- LSP/Diagnostics
nvim_lsp.diagnosticls.setup {
    capabilities = capabilities,
    on_attach = on_attach,
    filetypes = { 'javascript', 'javascriptreact', 'typescript', 'typescriptreact' },
    init_options = {
        linters = {
            eslint = {
                command = 'eslint_d',
                rootPatterns = { '.git' },
                debounce = 100,
                args = { '--stdin', '--stdin-filename', '%filepath', '--format', 'json' },
                sourceName = 'eslint',
                parseJson = {
                    errorsRoot = '[0].messages',
                    line = 'line',
                    column = 'column',
                    endLine = 'endLine',
                    endColumn = 'endColumn',
                    message = '[eslint] ${message} [${ruleId}]',
                    security = 'severity'
                },
                securities = {
                    [2] = 'error',
                    [1] = 'warning'
                }
            }
        },
        filetypes = {
            javascript = 'eslint',
            javascriptreact = 'eslint',
            typescript = 'eslint',
            typescriptreact = 'eslint'
        }
    }
}
