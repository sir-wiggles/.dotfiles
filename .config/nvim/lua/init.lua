local fn = vim.fn
local install_path = fn.stdpath('data') .. '/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
    packer_bootstrap = fn.system({ 'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim',
        install_path })
    vim.cmd [[packadd packer.nvim]]
end

require('packer').startup(function(use)
    vim.api.nvim_set_option("termguicolors", true)
    require("lsp").setup()

    use 'wbthomason/packer.nvim'

    use { 'alexghergh/nvim-tmux-navigation', config = function()
        local nvim_tmux_nav = require('nvim-tmux-navigation')
        nvim_tmux_nav.setup {
            disable_when_zoomed = false -- defaults to false
        }

        vim.keymap.set('n', "<C-h>", nvim_tmux_nav.NvimTmuxNavigateLeft)
        vim.keymap.set('n', "<C-j>", nvim_tmux_nav.NvimTmuxNavigateDown)
        vim.keymap.set('n', "<C-k>", nvim_tmux_nav.NvimTmuxNavigateUp)
        vim.keymap.set('n', "<C-l>", nvim_tmux_nav.NvimTmuxNavigateRight)
        vim.keymap.set('n', "<C-\\>", nvim_tmux_nav.NvimTmuxNavigateLastActive)
        vim.keymap.set('n', "<C-Space>", nvim_tmux_nav.NvimTmuxNavigateNext)
    end }

    use 'kyazdani42/nvim-web-devicons'

    use { 'nvim-lualine/lualine.nvim', config = function()
        require("lualine").setup({
            options = { theme = "gruvbox" },
            sections = { lualine_c = { "filename", require('lsp').active } }
        })
    end }

    use 'neovim/nvim-lspconfig'

    use { 'ibhagwan/fzf-lua', branch = 'main', config = function()
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
    end }

    use 'kdheepak/lazygit.nvim'

    use { 'williamboman/mason.nvim', config = function()
        require("mason").setup({})
    end }

    use { 'williamboman/mason-lspconfig.nvim', config = function()
        require("mason-lspconfig").setup({})
    end }

    use { 'nvim-treesitter/nvim-treesitter', run = ':TSUpdate', config = function()
        require("nvim-treesitter.configs").setup({
            ensure_installed = { "python", "vim", "lua", "javascript", "go", "c" },
            highlight = {
                enable = true,
                additional_vim_regex_highlighting = false,
            },
        })
    end }

    use { 'norcalli/nvim-colorizer.lua', config = function()
        require("colorizer").setup()
    end }


    use { 'echasnovski/mini.nvim', branch = 'stable', config = function()
        require("mini.bufremove").setup({})
        require("mini.comment").setup({})
        require("mini.completion").setup({})
        require("mini.cursorword").setup({})
        require("mini.indentscope").setup({})
        require("mini.jump").setup({})
        require("mini.surround").setup({})
        require("mini.tabline").setup({})
    end }


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

    if packer_bootstrap then
        require('packer').sync()
    end

end)

vim.cmd [[packadd packer.nvim]]

vim.cmd [[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost plugins.lua source <afile> | PackerCompile
  augroup end
]]
