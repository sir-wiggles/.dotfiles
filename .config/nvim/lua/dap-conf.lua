local dap = require('dap')
local dapui = require('dapui')
local pbp = require('persistent-breakpoints')

pbp.setup {
    load_breakpoints_event = { "BufReadPost" }
}

local keymap = vim.keymap.set
local home = os.getenv("HOME")
local env = home .. '/.pyenv/versions/debugpy/bin/python'

-- Python ==============================================================================

dap.adapters.python = {
    type = 'executable';
    command = env;
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
    {
        type = 'python';
        request = 'launch';
        name = "Launch file";

        program = "${file}";
        pythonPath = function()
            return env
        end;
    },
}

-- Typescript ==========================================================================

require("dap-vscode-js").setup({
    debugger_path = home .. "/Documents/vscode-js-debug",
    adapters = { 'pwa-node' },
})

for _, language in ipairs({ "typescript" }) do
    dap.configurations[language] = {
        {
            type = "pwa-node",
            request = "launch",
            name = "Launch file",
            program = "${file}",
            cwd = "${workspaceFolder}",
            sourceMaps = true,
            protocol = "inspector",
            console = "integratedTerminal",
            outFiles = { "${workspaceFolder}/dist/**/*.js" },
            resolveSourceMapLocations = {
                "${workspaceFolder}/dist/**/*.js",
                "${workspaceFolder}/**",
                "!**/node_modules/**"
            },
            runtimeExecutable = "ts-node",
            skipFiles = { "<mode_internals>/**" },
            preLaunchTask = "tsc: build - tsconfig.json"
        }
    }
end

-- Generic =============================================================================

local function DebugMappingKeyBindings(state)
    local opts = { noremap = true, silent = true, buffer = true }
    if state == "active" then
        local set = vim.keymap.set
        set("n", "c", "<cmd>lua require('dap').continue()<CR>", opts)
        set("n", "n", "<cmd>lua require('dap').step_over()<CR>", opts)
        set("n", "s", "<cmd>lua require('dap').step_into()<CR>", opts)
        set("n", "o", "<cmd>lua require('dap').step_out()<CR>", opts)
        set("n", "u", "<cmd>lua require('dap').up()<CR>", opts)
        set("n", "d", "<cmd>lua require('dap').down()<CR>", opts)
        set("n", "b", "<cmd>lua require('dap').toggle_breakpoint()<CR>", opts)
        set("n", "r", "<cmd>lua require('dap').repl.open()<CR>", opts)
        -- vim.api.nvim_set_hl(0, 'Normal', {bg='#ffaf00'})
    else
        local del = vim.keymap.del
        del("n", "c", opts)
        del("n", "n", opts)
        del("n", "s", opts)
        del("n", "o", opts)
        del("n", "u", opts)
        del("n", "d", opts)
        del("n", "b", opts)
        del("n", "r", opts)
        -- vim.api.nvim_set_hl(0, 'MiniStatuslineModeNormal', {bg='#3a3a3a'})
    end

end

local opts = { noremap = true, silent = true }

keymap("n", "<leader>b", "<cmd>lua require('persistent-breakpoints.api').toggle_breakpoint()<CR>", opts)
keymap("n", "<leader>ba", "<cmd>lua require('persistent-breakpoints.api').clear_all_breakpoints()<CR>", opts)

vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint' })
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped' })

dap.listeners.after.event_initialized["dapui_config"] = function()
    dapui.open()
    DebugMappingKeyBindings("active")
end

dap.listeners.before.event_terminated["dapui_config"] = function()
    dapui.close()
end

dap.listeners.after.event_terminated["dapui_config"] = function()
    DebugMappingKeyBindings("inactive")
end

dap.listeners.before.event_exited["dapui_config"] = function()
    dapui.close()
end

dapui.setup({})
