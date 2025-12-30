-------------------------------------------------
-- Bootstrap lazy.nvim
-------------------------------------------------
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not vim.loop.fs_stat(lazypath) then
    vim.fn.system({
        "git",
        "clone",
        "--filter=blob:none",
        "https://github.com/folke/lazy.nvim.git",
        "--branch=stable",
        lazypath,
    })
end
vim.opt.rtp:prepend(lazypath)

vim.g.mapleader = " "

-------------------------------------------------
-- Plugins
-------------------------------------------------
require("lazy").setup({

    -- Themes (pink/cyan/blue vibes)
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
    { "folke/tokyonight.nvim", priority = 1000 },
    {"kyazdani42/nvim-palenight.lua", priority = 1000 },

    -- Statusline
    { "nvim-lualine/lualine.nvim", dependencies = { "nvim-tree/nvim-web-devicons" } },

    -- Treesitter
    {
        "nvim-treesitter/nvim-treesitter",
        build = ":TSUpdate",
        opts = { auto_install = true, highlight = { enable = true } },
    },

    -- FZF
    {
        "ibhagwan/fzf-lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("fzf-lua").setup({
                winopts = {
                    height = 0.85,
                    width = 0.80,
                    preview = { layout = "vertical" },
                },
            })
        end,
    },

    -- Autopairs
    { "windwp/nvim-autopairs", event = "InsertEnter", config = true },

    -- LSP
    { "neovim/nvim-lspconfig" },

    -- Completion
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/vim-vsnip" },
    { "hrsh7th/cmp-vsnip" },

    -- Diagnostics UI
    {
        "folke/trouble.nvim",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        opts = { focus = false, auto_preview = true },
    },
})

-------------------------------------------------
-- General Options
-------------------------------------------------
vim.o.termguicolors = true
vim.opt.clipboard = "unnamedplus"
vim.opt.mouse = "a"
vim.opt.number = true
vim.opt.cursorline = true
vim.opt.signcolumn = "yes"
vim.opt.wrap = false
vim.opt.scrolloff = 8
vim.opt.sidescrolloff = 8
vim.opt.tabstop = 3
vim.opt.shiftwidth = 3
vim.opt.expandtab = true
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.splitbelow = true
vim.opt.splitright = true
vim.opt.updatetime = 250
vim.opt.timeoutlen = 400

-------------------------------------------------
-- Clipboard / Keymaps
-------------------------------------------------
vim.keymap.set({ "n", "i", "v" }, "<C-v>", '"+p', { silent = true })
vim.keymap.set("v", "<C-c>", '"+y', { silent = true })
vim.keymap.set("n", "<C-c>", '"+yy', { silent = true })
vim.keymap.set({ "n", "i" }, "<C-a>", "<Esc>ggVG", { silent = true })
vim.keymap.set("v", "<C-a>", "ggVG", { silent = true })
vim.keymap.set("c", "<C-a>", "<Home>", { noremap = true })
vim.keymap.set("c", "<C-c>", "<C-y>", { noremap = true })
vim.keymap.set("c", "<C-v>", "<C-r>+", { noremap = true })

-------------------------------------------------
-- Diagnostic Display (real-time + styled)
-------------------------------------------------
vim.diagnostic.config({
    virtual_text = {
        prefix = "●",
        spacing = 4,
    },
    signs = true,
    underline = true,
    update_in_insert = true,
    severity_sort = true,
})

-- Floating diagnostic settings with transparency
-- vim.api.nvim_set_hl(0, "DiagnosticFloating", { bg = "#000000000" })
-- vim.api.nvim_set_hl(0, "DiagnosticFloatBorder", { bg = "#000000000" })

vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
    callback = function()
        vim.diagnostic.open_float(nil, {
            focus = false,
            border = "rounded",
            source = "always",
        })
    end,
})

-------------------------------------------------
-- Autoformat on Save
-------------------------------------------------
vim.api.nvim_create_autocmd("BufWritePre", {
    callback = function()
        if #vim.lsp.get_active_clients({ bufnr = 0 }) > 0 then
            vim.lsp.buf.format({ async = false })
        end
    end,
})

-------------------------------------------------
-- FZF Keymaps
-------------------------------------------------
local fzf = require("fzf-lua")
vim.keymap.set("n", "<leader>ff", fzf.files)
vim.keymap.set("n", "<leader>fg", fzf.live_grep)
vim.keymap.set("n", "<leader>fb", fzf.buffers)
vim.keymap.set("n", "<leader>fh", fzf.help_tags)

-------------------------------------------------
-- Autopairs + CMP integration
-------------------------------------------------
local npairs = require("nvim-autopairs")
npairs.setup({ check_ts = true })

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
local cmp = require("cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-------------------------------------------------
-- LSP Setup
-------------------------------------------------
local capabilities = require("cmp_nvim_lsp").default_capabilities()

vim.lsp.config("clangd", {
    cmd = { "clangd", "--background-index", "--completion-style=detailed" },
    capabilities = capabilities,
})
vim.lsp.enable("clangd")

vim.lsp.config("lua_ls", {
    capabilities = capabilities,
    settings = {
        Lua = {
            diagnostics = { globals = { "vim" } },
            format = { enable = true },
        },
    },
})
vim.lsp.enable("lua_ls")

vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(ev)
        local opts = { buffer = ev.buf }
        vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)
        vim.keymap.set("n", "K", vim.lsp.buf.hover, opts)
        vim.keymap.set("n", "gr", vim.lsp.buf.references, opts)
        vim.keymap.set("n", "<leader>rn", vim.lsp.buf.rename, opts)
        vim.keymap.set("n", "<leader>ca", vim.lsp.buf.code_action, opts)
        vim.keymap.set("n", "<leader>f", vim.lsp.buf.format, opts)
    end,
})

-------------------------------------------------
-- Trouble Keymaps
-------------------------------------------------
vim.keymap.set("n", "<leader>xx", "<cmd>Trouble toggle<cr>")
vim.keymap.set("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>")

-------------------------------------------------
-- Lualine
-------------------------------------------------
require("lualine").setup({
    options = {
        theme = "auto",
        globalstatus = true,
    },
})

-------------------------------------------------
-- Theme Selection
-------------------------------------------------

-- Options:
-- vim.cmd.colorscheme("catppuccin-mocha")
-- vim.cmd.colorscheme("catppuccin-macchiato")
-- vim.cmd.colorscheme("rose-pine")
-- vim.cmd.colorscheme("tokyonight-storm")
-- vim.cmd.colorscheme("tokyonight-moon")
vim.cmd.colorscheme("palenight")
