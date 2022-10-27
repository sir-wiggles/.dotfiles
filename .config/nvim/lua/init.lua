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


local dap = require('dap')

local venv = os.getenv("VIRTUAL_ENV")
local env = '/Users/jeffor/.pyenv/versions/3.10.7/envs/test/bin/python'
dap.adapters.python = {
  type = 'executable';
  command = env;
  args = { '-m', 'debugpy.adapter' };
}

local dap = require('dap')
dap.configurations.python = {
  {
    -- The first three options are required by nvim-dap
    type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
    request = 'launch';
    name = "Launch file";

    -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

    program = "${file}"; -- This configuration will launch the current file if used.
    pythonPath = function()
      -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
      -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
      -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
      local cwd = vim.fn.getcwd()
      if vim.fn.executable(cwd .. '/venv/bin/python') == 1 then
        return cwd .. '/venv/bin/python'
      elseif vim.fn.executable(cwd .. '/.venv/bin/python') == 1 then
        return cwd .. '/.venv/bin/python'
      else
        return env
        -- return '/usr/bin/python'
      end
    end;
  },
}

require("dapui").setup({
  icons = { expanded = "▾", collapsed = "▸", current_frame = "▸" },
  mappings = {
    -- Use a table to apply multiple mappings
    expand = { "<CR>", "<2-LeftMouse>" },
    open = "o",
    remove = "d",
    edit = "e",
    repl = "r",
    toggle = "t",
  },
  -- Expand lines larger than the window
  -- Requires >= 0.7
  expand_lines = vim.fn.has("nvim-0.7") == 1,
  -- Layouts define sections of the screen to place windows.
  -- The position can be "left", "right", "top" or "bottom".
  -- The size specifies the height/width depending on position. It can be an Int
  -- or a Float. Integer specifies height/width directly (i.e. 20 lines/columns) while
  -- Float value specifies percentage (i.e. 0.3 - 30% of available lines/columns)
  -- Elements are the elements shown in the layout (in order).
  -- Layouts are opened in order so that earlier layouts take priority in window sizing.
  layouts = {
    {
      elements = {
      -- Elements can be strings or table with id and size keys.
        { id = "scopes", size = 0.25 },
        "breakpoints",
        "stacks",
        "watches",
      },
      size = 40, -- 40 columns
      position = "left",
    },
    {
      elements = {
        "repl",
        "console",
      },
      size = 0.25, -- 25% of total lines
      position = "bottom",
    },
  },
  controls = {
    -- Requires Neovim nightly (or 0.8 when released)
    enabled = true,
    -- Display controls in this element
    element = "repl",
    icons = {
      pause = "",
      play = "",
      step_into = "",
      step_over = "",
      step_out = "",
      step_back = "",
      run_last = "↻",
      terminate = "□",
    },
  },
  floating = {
    max_height = nil, -- These can be integers or a float between 0 and 1.
    max_width = nil, -- Floats will be treated as percentage of your screen.
    border = "single", -- Border style. Can be "single", "double" or "rounded"
    mappings = {
      close = { "q", "<Esc>" },
    },
  },
  windows = { indent = 1 },
  render = {
    max_type_length = nil, -- Can be integer or nil.
    max_value_lines = 100, -- Can be integer or nil.
  }
})

local dap, dapui = require("dap"), require("dapui")
dap.listeners.after.event_initialized["dapui_config"] = function()
  dapui.open()
end
dap.listeners.before.event_terminated["dapui_config"] = function()
  dapui.close()
end
dap.listeners.before.event_exited["dapui_config"] = function()
  dapui.close()
end

