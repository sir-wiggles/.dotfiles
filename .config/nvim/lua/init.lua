-- must be set before plugins that deal with colors
vim.api.nvim_set_option("termguicolors", true)

require("cmp-conf").setup()
require("lsp-conf").setup()
require("git-conf")
require("dap-conf")
require("colorizer").setup()
require("mason").setup({})
require("mason-lspconfig").setup({})
require("mini.bufremove").setup({})
require("mini.comment").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.jump").setup({})
require("mini.surround").setup({})
require("mini.tabline").setup({})
require("nvim-tree").setup()
require('telescope').setup({
    defaults = {
        layout_strategy = 'vertical',
        layout_config = { height = 0.95 },
    }
})

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1

-- ===========================================
-- ====== nvim-treesitter configuration ======
-- ===========================================
require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "vim", "lua", "javascript", "go", "json", "typescript" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})


-- -------------------------------------------

-- ===========================================
-- ========== lualine configuration ==========
-- ===========================================

require("lualine").setup({
    options = { theme = "gruvbox" },
    sections = {
        -- lualine_b = { "diff" },
        lualine_c = { "filename", require('lsp-conf').active },
    },
    extensions = { "quickfix", "man", "nvim-dap-ui" }
})
