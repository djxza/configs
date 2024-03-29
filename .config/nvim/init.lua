local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"

if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({"git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable",
                   lazypath})
end

vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

require("lazy").setup({
    {
        "morhetz/gruvbox",
        lazy = false,
        priority = 1000,
        config = function()
            vim.cmd("colorscheme gruvbox")
        end
    }, 
    
    {
        "drewtempelmeyer/palenight.vim",
        lazy = false
    },

    {
        "nvim-lualine/lualine.nvim",
        dependencies = {'nvim-tree/nvim-web-devicons'}
    },

    {
        "folke/tokyonight.nvim"
    },

    {
        "nvim-treesitter/nvim-treesitter",
        lazy = false,
        config = function()
            vim.cmd("TSUpdate");
        end
    },
    
    {
        "windwp/nvim-autopairs",
        event = "InsertEnter",
        opts = {}
    },
    
    -- lsp and cmp

    {
        "neovim/nvim-lspconfig",
        lazy = true
    },

    {
        'neovim/nvim-lspconfig'
    }, 

    {
        'hrsh7th/cmp-nvim-lsp'
    }, 

    {
        'hrsh7th/cmp-buffer'
    }, 
    
    {
        'hrsh7th/cmp-path'
    },

    {
        'hrsh7th/cmp-cmdline'
    },
    
    {
        'hrsh7th/nvim-cmp'
    },
    
    {
        'hrsh7th/cmp-vsnip'
    }, 
    
    {
        'hrsh7th/vim-vsnip'
    
    }
    })

require("nvim-treesitter").setup({
	auto_install = true,
   highlight = {
      rnable = true,
      additional_vim_regex_highlighting = false
   }
})

-- Setup language servers.
local lspconfig = require('lspconfig')

-- Global mappings.
-- See `:help vim.diagnostic.*` for documentation on any of the below functions
vim.keymap.set('n', '<space>e', vim.diagnostic.open_float)
vim.keymap.set('n', 'd[', vim.diagnostic.goto_prev)
vim.keymap.set('n', ']d', vim.diagnostic.goto_next)
vim.keymap.set('n', '<space>q', vim.diagnostic.setloclist)

-- Use LspAttach autocommand to only map the following keys
-- after the language server attaches to the current buffer
vim.api.nvim_create_autocmd('LspAttach', {
    group = vim.api.nvim_create_augroup('UserLspConfig', {}),
    callback = function(ev)
        -- Enable completion triggered by <c-x><c-o>
        vim.bo[ev.buf].omnifunc = 'v:lua.vim.lsp.omnifunc'

        -- Buffer local mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local opts = {
            buffer = ev.buf
        }
        vim.keymap.set('n', 'gD', vim.lsp.buf.declaration, opts)
        vim.keymap.set('n', 'gd', vim.lsp.buf.definition, opts)
        vim.keymap.set('n', 'K', vim.lsp.buf.hover, opts)
        vim.keymap.set('n', 'gi', vim.lsp.buf.implementation, opts)
        vim.keymap.set('n', '<C-k>', vim.lsp.buf.signature_help, opts)
        vim.keymap.set('n', '<space>wa', vim.lsp.buf.add_workspace_folder, opts)
        vim.keymap.set('n', '<space>wr', vim.lsp.buf.remove_workspace_folder, opts)
        vim.keymap.set('n', '<space>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, opts)
        vim.keymap.set('n', '<space>D', vim.lsp.buf.type_definition, opts)
        vim.keymap.set('n', '<space>rn', vim.lsp.buf.rename, opts)
        vim.keymap.set({'n', 'v'}, '<space>ca', vim.lsp.buf.code_action, opts)
        vim.keymap.set('n', 'gr', vim.lsp.buf.references, opts)
        vim.keymap.set('n', '<space>f', function()
            vim.lsp.buf.format {
                async = true
            }
        end, opts)
    end
})

-- Set up nvim-cmp.
local cmp = require('cmp')

cmp.setup({
    snippet = {
        -- REQUIRED - you must specify a snippet engine
        expand = function(args)
            vim.fn["vsnip#anonymous"](args.body) -- For `vsnip` users.
            -- require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
            -- require('snippy').expand_snippet(args.body) -- For `snippy` users.
            -- vim.fn["UltiSnips#Anon"](args.body) -- For `ultisnips` users.
        end
    },
    window = {
        -- completion = cmp.config.window.bordered(),
        -- documentation = cmp.config.window.bordered(),
    },
    mapping = cmp.mapping.preset.insert({
        ['<C-b>'] = cmp.mapping.scroll_docs(-4),
        ['<C-f>'] = cmp.mapping.scroll_docs(4),
        ['<C-Space>'] = cmp.mapping.complete(),
        ['<C-e>'] = cmp.mapping.abort(),
        ['<CR>'] = cmp.mapping.confirm({
            select = true
        }) -- Accept currently selected item. Set `select` to `false` to only confirm explicitly selected items.
    }),
    sources = cmp.config.sources({{
        name = 'nvim_lsp'
    }, {
        name = 'vsnip'
    } -- For vsnip users.
    -- { name = 'luasnip' }, -- For luasnip users.
    -- { name = 'ultisnips' }, -- For ultisnips users.
    -- { name = 'snippy' }, -- For snippy users.
    }, {{
        name = 'buffer'
    }})
})

-- Set configuration for specific filetype.
cmp.setup.filetype('gitcommit', {
    sources = cmp.config.sources({{
        name = 'git'
    } -- You can specify the `git` source if [you were installed it](https://github.com/petertriho/cmp-git).
    }, {{
        name = 'buffer'
    }})
})

-- Use buffer source for `/` and `?` (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline({'/', '?'}, {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {{
        name = 'buffer'
    }}
})

-- Use cmdline & path source for ':' (if you enabled `native_menu`, this won't work anymore).
cmp.setup.cmdline(':', {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({{
        name = 'path'
    }}, {{
        name = 'cmdline'
    }})
})

-- Set up lspconfig.
local capabilities = require('cmp_nvim_lsp').default_capabilities()

require('lspconfig')['clangd'].setup {
    cmd = {
        "clangd",
        "--background-index",
        "--pch-storage=memory",
        "--all-scopes-completion",
        "--pretty",
        "--header-insertion=never",
        "-j=6",
        "--inlay-hints",
        "--header-insertion-decorators",
        "--function-arg-placeholders",
        "--completion-style=detailed"
      },
      filetypes = {"c", "cpp", "objc", "objcpp"},
      root_dir = require('lspconfig').util.root_pattern("src"),
      init_option = { fallbackFlags = {  "-std=gnu++20"  } },
      capabilities = capabilities
    }

vim.opt.mouse = 'a'
vim.opt.number = true
vim.opt.smarttab = true
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true

require('lualine').setup {
    sections = {
        lualine_a = {'mode'},
        lualine_b = {'branch', 'diff', 'diagnostics'},
        lualine_c = {'filename', function()
            return vim.fn['nvim_treesitter#statusline'](180)
        end},
        lualine_x = {'encoding', 'fileformat', 'filetype'},
        lualine_y = {'progress'},
        lualine_z = {'location'}
    }
}

require('nvim-autopairs').setup({})
