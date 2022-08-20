-- must be set before plugins that deal with colors
vim.api.nvim_set_option("termguicolors", true)

require("lsp").setup()
require("colorizer").setup()
require("mason").setup({})
require("mason-lspconfig").setup({})
require("mini.bufremove").setup({})
require("mini.comment").setup({})
require("mini.completion").setup({})
require("mini.cursorword").setup({})
require("mini.indentscope").setup({})
require("mini.jump").setup({})
require("mini.surround").setup({})
require("mini.tabline").setup({})

-- ===========================================
-- ====== nvim-treesitter configuration ======
-- ===========================================
require("nvim-treesitter.configs").setup({
    ensure_installed = { "python", "vim", "lua", "javascript", "go" },
    highlight = {
        enable = true,
        additional_vim_regex_highlighting = false,
    },
})
-- -------------------------------------------

-- ===========================================
-- ========== fzf-lua configuration ==========
-- ===========================================
-- override the default action of sending selections to quickfix and just
-- edit the files.
local actions = require("fzf-lua.actions")
require("fzf-lua").setup({
    actions = {
        files = {
            ["default"] = actions.file_edit,
            ["ctrl-s"]  = actions.file_split,
            ["ctrl-v"]  = actions.file_vsplit,
            ["ctrl-t"]  = actions.file_tabedit,
            ["alt-q"]   = actions.file_sel_to_qf,
        },
    },
})
-- -------------------------------------------

-- ===========================================
-- ======== mini.base16 configuration ========
-- ===========================================
local palettes = {
    dark = {
        base00 = "#262626", -- # ----
        base01 = "#3a3a3a", -- # ---
        base02 = "#4e4e4e", -- # --
        base03 = "#8a8a8a", -- # -
        base04 = "#949494", -- # +
        base05 = "#dab997", -- # ++
        base06 = "#d5c4a1", -- # +++
        base07 = "#ebdbb2", -- # ++++
        base08 = "#d75f5f", -- # red
        base09 = "#ff8700", -- # orange
        base0A = "#ffaf00", -- # yellow
        base0B = "#afaf00", -- # green
        base0C = "#85ad85", -- # aqua/cyan
        base0D = "#83adad", -- # blue
        base0E = "#d485ad", -- # purple
        base0F = "#d65d0e", -- # brown
    },
    light = {
        base00 = "#fbf1c7", -- # ----
        base01 = "#ebdbb2", -- # ---
        base02 = "#d5c4a1", -- # --
        base03 = "#bdae93", -- # -
        base04 = "#665c54", -- # +
        base05 = "#504945", -- # ++
        base06 = "#3c3836", -- # +++
        base07 = "#282828", -- # ++++
        base08 = "#9d0006", -- # red
        base09 = "#af3a03", -- # orange
        base0A = "#b57614", -- # yellow
        base0B = "#79740e", -- # green
        base0C = "#427b58", -- # aqua/cyan
        base0D = "#076678", -- # blue
        base0E = "#8f3f71", -- # purple
        base0F = "#d65d0e", -- # brown
    }
}

require("mini.base16").setup({
    palette = palettes["dark"],
    use_cterm = true,
})
-- -------------------------------------------

-- ===========================================
-- ========== lualine configuration ==========
-- ===========================================
-- this plugin must be called after mini.base16
require("lualine").setup({
    options = { theme = "gruvbox" },
    sections = { lualine_c = { "filename", require('lsp').active } }
})
