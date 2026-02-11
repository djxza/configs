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
-- Configuration Flags (Set these BEFORE requiring)
-- Uncomment any of these lines to disable specific startup messages
-------------------------------------------------
-- vim.g.disable_startup_theme_message = true      -- Disable theme selection message
-- vim.g.disable_startup_help_message = true       -- Disable help message
-- vim.g.disable_all_startup_messages = true       -- Disable all startup messages
-- vim.g.disable_random_theme = true               -- Use default theme instead of random
-- vim.g.default_theme = "onedark"                 -- Set default theme when random is disabled

vim.g.disable_all_startup_messages = 1

-------------------------------------------------
-- Helper function for conditional printing
-------------------------------------------------
local function startup_print(message, message_type)
    -- Check if all messages are disabled
    if vim.g.disable_all_startup_messages then
        return
    end
    
    -- Check specific message type
    if message_type == "theme" and vim.g.disable_startup_theme_message then
        return
    end
    
    if message_type == "help" and vim.g.disable_startup_help_message then
        return
    end
    
    -- Print the message
    print(message)
end

-------------------------------------------------
-- Theme selection
-------------------------------------------------
local themes = {
    "catppuccin-mocha",      -- Pink/blue vibes
    "rose-pine-moon",        -- Purple/blue elegance
    "tokyonight-storm",      -- Blue/purple storm
    "palenight",             -- Deep blue
    "onedark",               -- Dark blue/green
    "dracula",               -- Purple/cyan
    "gruvbox-material",      -- Warm brown/green
    "nightfox",              -- Blue/orange contrast
    "monokai-pro",           -- Vibrant professional
    "sonokai",               -- High contrast modern
    "everforest",            -- Gentle on eyes
    "kanagawa-wave",         -- Japanese painting style
    "material-deep-ocean",   -- Deep ocean blue
    "oxocarbon",             -- IBM Carbon inspired
    "vscode",                -- VS Code dark theme
    "onedark-pro",           -- Enhanced OneDark
    "nord",                  -- Arctic blue
    "melange",               -- Warm neutral
    "embark",                -- Port of Emacs embark
    "falcon",                -- Dark minimalist
    "github_dark",           -- GitHub Dark
    "github_dark_dimmed",    -- GitHub Dark Dimmed
    "moonlight",             -- VS Code Moonlight
    "outrun",                -- Synthwave/outrun
}

local random_theme
if vim.g.disable_random_theme then
    -- Use specified default theme or fallback to onedark
    random_theme = vim.g.default_theme or "onedark"
    startup_print("🎨 Using theme: " .. random_theme, "theme")
else
    -- Pick random theme
    math.randomseed(os.time())
    random_theme = themes[math.random(#themes)]
    startup_print("🎲 Surprise theme: " .. random_theme, "theme")
end

-------------------------------------------------
-- Plugins
-------------------------------------------------
require("lazy").setup({

    -- Themes
    { "catppuccin/nvim", name = "catppuccin", priority = 1000 },
    { "rose-pine/neovim", name = "rose-pine", priority = 1000 },
    { "folke/tokyonight.nvim", priority = 1000 },
    { "kyazdani42/nvim-palenight.lua", priority = 1000 },
    { "navarasu/onedark.nvim", priority = 1000 },
    { "Mofiqul/dracula.nvim", priority = 1000 },
    { "sainnhe/gruvbox-material", priority = 1000 },
    { "EdenEast/nightfox.nvim", priority = 1000 },
    { "loctvl842/monokai-pro.nvim", priority = 1000 },
    { "sainnhe/sonokai", priority = 1000 },
    { "sainnhe/everforest", priority = 1000 },
    { "rebelot/kanagawa.nvim", priority = 1000 },
    { "marko-cerovac/material.nvim", priority = 1000 },
    { "nyoom-engineering/oxocarbon.nvim", priority = 1000 },
    { "Mofiqul/vscode.nvim", priority = 1000 },
    { "olimorris/onedarkpro.nvim", priority = 1000 },
    { "shaunsingh/nord.nvim", priority = 1000 },
    { "savq/melange-nvim", priority = 1000 },
    { "embark-theme/vim", name = "embark", priority = 1000 },
    { "fenetikm/falcon", priority = 1000 },
    { "projekt0n/github-nvim-theme", priority = 1000 },
    { "shaunsingh/moonlight.nvim", priority = 1000 },
    { "ghifarit53/tokyonight-vim", name = "outrun", priority = 1000 },

    -- Enhanced Search & Replace
    {
        "nvim-pack/nvim-spectre",
        dependencies = { "nvim-lua/plenary.nvim" },
        config = function()
            require("spectre").setup({
                color_devicons = true,
                highlight = {
                    ui = "String",
                    search = "DiffChange",
                    replace = "DiffDelete",
                },
                mapping = {
                    ["toggle_line"] = {
                        map = "dd",
                        cmd = "<cmd>lua require('spectre').toggle_line()<CR>",
                        desc = "Toggle current item",
                    },
                    ["enter_file"] = {
                        map = "<cr>",
                        cmd = "<cmd>lua require('spectre.actions').select_entry()<CR>",
                        desc = "Open file",
                    },
                    ["send_to_qf"] = {
                        map = "<leader>q",
                        cmd = "<cmd>lua require('spectre.actions').send_to_qf()<CR>",
                        desc = "Send all items to quickfix",
                    },
                    ["replace_cmd"] = {
                        map = "<leader>c",
                        cmd = "<cmd>lua require('spectre.actions').replace_cmd()<CR>",
                        desc = "Input replace command",
                    },
                    ["show_option_menu"] = {
                        map = "<leader>o",
                        cmd = "<cmd>lua require('spectre').show_options()<CR>",
                        desc = "Show options",
                    },
                    ["run_current_replace"] = {
                        map = "<leader>rc",
                        cmd = "<cmd>lua require('spectre.actions').run_current_replace()<CR>",
                        desc = "Replace current line",
                    },
                    ["run_replace"] = {
                        map = "<leader>R",
                        cmd = "<cmd>lua require('spectre.actions').run_replace()<CR>",
                        desc = "Replace all",
                    },
                    ["change_view_mode"] = {
                        map = "<leader>v",
                        cmd = "<cmd>lua require('spectre').change_view()<CR>",
                        desc = "Change result view mode",
                    },
                },
                find_engine = {
                    ["rg"] = {
                        cmd = "rg",
                        args = {
                            "--color=never",
                            "--no-heading",
                            "--with-filename",
                            "--line-number",
                            "--column",
                            "--smart-case",
                            "--hidden",
                            "--glob=!git/*",
                        },
                    },
                },
                replace_engine = {
                    ["sed"] = {
                        cmd = "sed",
                    },
                },
                default = {
                    find = {
                        cmd = "rg",
                        options = { "ignore-case" },
                    },
                    replace = {
                        cmd = "sed",
                    },
                },
                replace_vim_cmd = "cdo",
                is_open_target_win = true,
                is_insert_mode = false,
            })
        end,
    },

    -- Better incremental search highlighting
    {
        "kevinhwang91/nvim-hlslens",
        config = function()
            require("hlslens").setup({
                calm_down = true,
                nearest_only = true,
                nearest_float_when = "always",
            })

            -- Enhanced search keymaps with hlslens
            local kopts = { noremap = true, silent = true }
            vim.api.nvim_set_keymap(
                "n",
                "n",
                [[<Cmd>execute('normal! ' . v:count1 . 'n')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap(
                "n",
                "N",
                [[<Cmd>execute('normal! ' . v:count1 . 'N')<CR><Cmd>lua require('hlslens').start()<CR>]],
                kopts
            )
            vim.api.nvim_set_keymap("n", "*", [[*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "#", [[#<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g*", [[g*<Cmd>lua require('hlslens').start()<CR>]], kopts)
            vim.api.nvim_set_keymap("n", "g#", [[g#<Cmd>lua require('hlslens').start()<CR>]], kopts)
        end,
    },

    -- Nvim Tree
    {
        "nvim-tree/nvim-tree.lua",
        dependencies = { "nvim-tree/nvim-web-devicons" },
        config = function()
            require("nvim-tree").setup({
                view = {
                    width = 35,
                    side = "left",
                    number = false,
                    relativenumber = false,
                    signcolumn = "yes",
                    float = {
                        enable = false,
                    },
                },
                renderer = {
                    highlight_git = true,
                    highlight_opened_files = "icon",
                    group_empty = true,
                    indent_markers = {
                        enable = true,
                    },
                    icons = {
                        web_devicons = {
                            file = {
                                enable = true,
                                color = true,
                            },
                            folder = {
                                enable = true,
                                color = true,
                            },
                        },
                        glyphs = {
                            default = "",
                            symlink = "",
                            git = {
                                unstaged = "●",
                                staged = "✓",
                                unmerged = "",
                                renamed = "➜",
                                untracked = "★",
                                deleted = "",
                                ignored = "◌",
                            },
                            folder = {
                                arrow_open = "",
                                arrow_closed = "",
                                default = "",
                                open = "",
                                empty = "",
                                empty_open = "",
                                symlink = "",
                                symlink_open = "",
                            },
                        },
                    },
                },
                update_focused_file = {
                    enable = true,
                    update_root = true,
                },
                diagnostics = {
                    enable = true,
                    show_on_dirs = true,
                    icons = {
                        hint = "",
                        info = "",
                        warning = "",
                        error = "",
                    },
                },
                filters = {
                    dotfiles = false,
                    custom = {},
                },
                actions = {
                    open_file = {
                        quit_on_open = false,
                        resize_window = true,
                    },
                },
                git = {
                    enable = true,
                    ignore = false,
                    timeout = 400,
                },
                log = {
                    enable = false,
                    truncate = false,
                    types = {
                        all = false,
                        config = false,
                        copy_paste = false,
                        diagnostics = false,
                        git = false,
                        profile = false,
                    },
                },
            })
        end,
    },

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

    -- Completion (advanced)
    { "hrsh7th/nvim-cmp" },
    { "hrsh7th/cmp-nvim-lsp" },
    { "hrsh7th/cmp-buffer" },
    { "hrsh7th/cmp-path" },
    { "hrsh7th/cmp-cmdline" },
    { "hrsh7th/cmp-nvim-lua" },
    { "saadparwaiz1/cmp_luasnip" },

    -- Snippets
    { "L3MON4D3/LuaSnip" },
    { "rafamadriz/friendly-snippets" },

    -- Completion UI polish
    { "onsails/lspkind.nvim" },

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

-- Enhanced search options
vim.opt.hlsearch = true
vim.opt.incsearch = true
vim.opt.inccommand = "split" -- Live preview of substitute commands

-- new
vim.opt.laststatus = 2
vim.opt.statusline = "%F%m%r%=%l,%v"

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
-- Enhanced Search & Replace Keymaps
-------------------------------------------------
vim.keymap.set("n", "<leader>sr", function()
    require("spectre").open()
end, { desc = "Open Spectre (Search & Replace)" })

vim.keymap.set("n", "<leader>sw", function()
    require("spectre").open_visual({ select_word = true })
end, { desc = "Search current word with Spectre" })

vim.keymap.set("v", "<leader>sw", function()
    require("spectre").open_visual()
end, { desc = "Search selection with Spectre" })

vim.keymap.set("n", "<leader>sp", function()
    require("spectre").open_file_search({ select_word = true })
end, { desc = "Search in current file with Spectre" })

-- Better incremental search with hlslens
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Clear search highlights" })

-- Improved find and replace in buffer
vim.keymap.set("n", "<leader>s", ":%s/\\<<C-r><C-w>\\>/", { desc = "Replace current word in buffer" })
vim.keymap.set("v", "<leader>s", '"hy:%s/<C-r>h/', { desc = "Replace selection in buffer" })

-------------------------------------------------
-- Nvim Tree Keymaps
-------------------------------------------------
vim.keymap.set("n", "<leader>e", "<cmd>NvimTreeToggle<CR>", { desc = "Toggle file tree" })
vim.keymap.set("n", "<leader>E", "<cmd>NvimTreeFindFile<CR>", { desc = "Find current file in tree" })

-------------------------------------------------
-- Diagnostic Display
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

-------------------------------------------------
-- Advanced Completion (nvim-cmp)
-------------------------------------------------
local cmp = require("cmp")
local luasnip = require("luasnip")
local lspkind = require("lspkind")

require("luasnip.loaders.from_vscode").lazy_load()

cmp.setup({
    completion = {
        completeopt = "menu,menuone,noinsert",
    },

    snippet = {
        expand = function(args)
            luasnip.lsp_expand(args.body)
        end,
    },

    window = {
        completion = cmp.config.window.bordered(),
        documentation = cmp.config.window.bordered(),
    },

    formatting = {
        format = lspkind.cmp_format({
            mode = "symbol_text",
            maxwidth = 50,
            ellipsis_char = "…",
        }),
    },

    mapping = cmp.mapping.preset.insert({
        ["<C-Space>"] = cmp.mapping.complete(),
        ["<C-e>"] = cmp.mapping.abort(),
        ["<CR>"] = cmp.mapping.confirm({ select = true }),

        ["<Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_next_item()
            elseif luasnip.expand_or_jumpable() then
                luasnip.expand_or_jump()
            else
                fallback()
            end
        end, { "i", "s" }),

        ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
                cmp.select_prev_item()
            elseif luasnip.jumpable(-1) then
                luasnip.jump(-1)
            else
                fallback()
            end
        end, { "i", "s" }),
    }),

    sources = cmp.config.sources({
        { name = "nvim_lsp" },
        { name = "luasnip" },
        { name = "nvim_lua" },
        { name = "path" },
    }, {
        { name = "buffer", keyword_length = 3 },
    }),

    experimental = {
        ghost_text = true,
    },
})

local cmp_autopairs = require("nvim-autopairs.completion.cmp")
cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())

-------------------------------------------------
-- Cmdline Completion
-------------------------------------------------
cmp.setup.cmdline("/", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = {
        { name = "buffer" }
    }
})

cmp.setup.cmdline(":", {
    mapping = cmp.mapping.preset.cmdline(),
    sources = cmp.config.sources({
        { name = "path" }
    }, {
        { name = "cmdline" }
    })
})

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
-- Lualine with nvim-tree integration
-------------------------------------------------
require("lualine").setup({
    options = {
        theme = "auto",
        globalstatus = true,
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
    },
    sections = {
        lualine_a = { "mode" },
        lualine_b = { "branch", "diff", "diagnostics" },
        lualine_c = { {
            "filename",
            path = 1,
            symbols = {
                modified = " ●",
                readonly = " ",
                unnamed = "[No Name]",
            },
        } },
        lualine_x = { "encoding", "fileformat", "filetype" },
        lualine_y = { "progress" },
        lualine_z = { "location" },
    },
    extensions = { "nvim-tree" },
})

-------------------------------------------------
-- Enhanced Replace Function
-------------------------------------------------
function _G.smart_replace()
    local word = vim.fn.expand("<cword>")
    local replace_with = vim.fn.input("Replace '" .. word .. "' with: ")
    if replace_with ~= "" then
        vim.cmd("%s/\\<" .. word .. "\\>/" .. replace_with .. "/g")
        print("Replaced all occurrences of '" .. word .. "' with '" .. replace_with .. "'")
    end
end

vim.keymap.set("n", "<leader>rw", "<cmd>lua smart_replace()<CR>", { desc = "Smart replace word" })

function _G.replace_in_selection()
    local replace_with = vim.fn.input("Replace selection with: ")
    if replace_with ~= "" then
        vim.cmd("'<,'>s/" .. vim.fn.getreg('/') .. "/" .. replace_with .. "/g")
    end
end

vim.keymap.set("v", "<leader>rs", ":<C-u>lua replace_in_selection()<CR>", { desc = "Replace in selection" })

-------------------------------------------------
-- Apply Random Theme with Customizations
-------------------------------------------------
-- Function to setup theme with fallbacks
local function setup_theme()
    local success, _ = pcall(function()
        if random_theme == "catppuccin-mocha" then
            require("catppuccin").setup({
                flavour = "mocha",
                integrations = {
                    nvimtree = {
                        enabled = true,
                        show_root = true,
                        transparent_panel = false,
                    },
                    spectre = true,
                },
            })
            vim.cmd.colorscheme("catppuccin")
            
        elseif random_theme == "rose-pine-moon" then
            require("rose-pine").setup({
                variant = "moon",
                dark_variant = "moon",
                styles = {
                    italic = false,
                },
                highlight_groups = {
                    NvimTreeFolderName = { fg = "love" },
                    NvimTreeRootFolder = { fg = "gold" },
                    SpectreSearch = { fg = "rose", bg = "highlight_high" },
                    SpectreReplace = { fg = "love", bg = "highlight_high" },
                }
            })
            vim.cmd.colorscheme("rose-pine")
            
        elseif random_theme == "tokyonight-storm" then
            require("tokyonight").setup({
                style = "storm",
                on_highlights = function(hl, c)
                    hl.NvimTreeFolderIcon = { fg = c.blue }
                    hl.NvimTreeIndentMarker = { fg = c.comment }
                    hl.SpectreSearch = { bg = c.bg_highlight, fg = c.orange }
                    hl.SpectreReplace = { bg = c.bg_highlight, fg = c.red }
                end,
            })
            vim.cmd.colorscheme("tokyonight")
            
        elseif random_theme == "palenight" then
            vim.cmd.colorscheme("palenight")
            
        elseif random_theme == "onedark" then
            require("onedark").setup({
                style = "darker",
                highlights = {
                    NvimTreeFolderName = { fg = "#61afef" },
                    NvimTreeOpenedFolderName = { fg = "#61afef", bold = true },
                },
            })
            vim.cmd.colorscheme("onedark")
            
        elseif random_theme == "dracula" then
            require("dracula").setup({
                overrides = {
                    NvimTreeFolderIcon = { fg = "#8be9fd" },
                    NvimTreeOpenedFolderName = { fg = "#ff79c6" },
                },
            })
            vim.cmd.colorscheme("dracula")
            
        elseif random_theme == "gruvbox-material" then
            vim.g.gruvbox_material_background = "hard"
            vim.g.gruvbox_material_better_performance = 1
            vim.cmd.colorscheme("gruvbox-material")
            
        elseif random_theme == "nightfox" then
            require("nightfox").setup({
                options = {
                    styles = {
                        comments = "italic",
                        keywords = "bold",
                        types = "italic,bold",
                    },
                },
            })
            vim.cmd.colorscheme("nightfox")
            
        elseif random_theme == "monokai-pro" then
            require("monokai-pro").setup({
                filter = "octagon", -- classic, octagon, pro, machine, ristretto, spectrum
                styles = {
                    comment = { italic = true },
                    keyword = { italic = true },
                },
            })
            vim.cmd.colorscheme("monokai-pro")
            
        elseif random_theme == "sonokai" then
            vim.g.sonokai_style = "andromeda"
            vim.g.sonokai_better_performance = 1
            vim.cmd.colorscheme("sonokai")
            
        elseif random_theme == "everforest" then
            vim.g.everforest_background = "hard"
            vim.g.everforest_better_performance = 1
            vim.cmd.colorscheme("everforest")
            
        elseif random_theme == "kanagawa-wave" then
            require("kanagawa").setup({
                theme = "wave",
                overrides = function(colors)
                    return {
                        SpectreSearch = { bg = colors.sumiInk2, fg = colors.springViolet2 },
                        SpectreReplace = { bg = colors.sumiInk2, fg = colors.peachRed },
                    }
                end,
            })
            vim.cmd.colorscheme("kanagawa-wave")
            
        elseif random_theme == "material-deep-ocean" then
            vim.g.material_style = "deep ocean"
            require("material").setup({
                contrast = {
                    terminal = false,
                    sidebars = false,
                    floating_windows = false,
                    cursor_line = false,
                    non_current_windows = false,
                },
                styles = {
                    comments = { italic = true },
                    strings = { bold = true },
                    keywords = { italic = true },
                    functions = { bold = true },
                    variables = {},
                },
                plugins = {
                    "nvim-tree",
                    "spectre",
                },
            })
            vim.cmd.colorscheme("material")
            
        elseif random_theme == "oxocarbon" then
            vim.cmd.colorscheme("oxocarbon")
            
        elseif random_theme == "vscode" then
            require("vscode").setup({
                transparent = false,
                italic_comments = true,
                disable_nvimtree_bg = false,
            })
            vim.cmd.colorscheme("vscode")
            
        elseif random_theme == "onedark-pro" then
            require("onedarkpro").setup({
                theme = "onedark",
                styles = {
                    strings = "NONE",
                    comments = "italic",
                    keywords = "bold",
                    functions = "italic,bold",
                },
            })
            vim.cmd.colorscheme("onedark")
            
        elseif random_theme == "nord" then
            vim.cmd.colorscheme("nord")
            
        elseif random_theme == "melange" then
            vim.cmd.colorscheme("melange")
            
        elseif random_theme == "embark" then
            vim.cmd.colorscheme("embark")
            
        elseif random_theme == "falcon" then
            vim.cmd.colorscheme("falcon")
            
        elseif random_theme == "github_dark" then
            require("github-theme").setup({
                theme_style = "dark",
                function_style = "italic",
                sidebars = { "qf", "vista_kind", "terminal", "packer" },
                colors = {
                    hint = "orange",
                    error = "#ff3333"
                },
                overrides = function(c)
                    return {
                        SpectreSearch = { bg = c.bg_highlight, fg = c.orange },
                        SpectreReplace = { bg = c.bg_highlight, fg = c.red },
                    }
                end,
            })
            vim.cmd.colorscheme("github_dark")
            
        elseif random_theme == "github_dark_dimmed" then
            require("github-theme").setup({
                theme_style = "dark_dimmed",
                function_style = "italic",
            })
            vim.cmd.colorscheme("github_dark_dimmed")
            
        elseif random_theme == "moonlight" then
            vim.cmd.colorscheme("moonlight")
            
        elseif random_theme == "outrun" then
            require("outrun").setup({
                style = "outrun",
            })
            vim.cmd.colorscheme("outrun")
            
        else
            -- Fallback to a default theme
            vim.cmd.colorscheme("habamax")
        end
    end)
    
    if not success then
        startup_print("⚠️  Could not load theme: " .. random_theme .. ". Falling back to habamax.", "theme")
        vim.cmd.colorscheme("habamax")
    end
end

setup_theme()

-- Custom highlight for nvim-tree to match the theme
vim.api.nvim_set_hl(0, "NvimTreeCursorLine", { bg = "#2a2a3a" })
vim.api.nvim_set_hl(0, "NvimTreeVertSplit", { fg = "#1a1a2a", bg = "#1a1a2a" })

-- Auto close nvim-tree when last buffer
vim.api.nvim_create_autocmd("BufEnter", {
    nested = true,
    callback = function()
        if #vim.api.nvim_list_wins() == 1 and vim.api.nvim_buf_get_name(0):match("NvimTree_") ~= nil then
            vim.cmd("quit")
        end
    end
})

-- Print startup help message (if not disabled)
startup_print("✨ Theme set to: " .. random_theme, "help")
startup_print("🔍 Search & Replace: <leader>sr - Spectre | <leader>sw - Search word", "help")
startup_print("📁 File tree: <leader>e | 🔍 Find files: <leader>ff", "help")
