local dap = require('dap')
local keymap = vim.keymap.set
local env = '~/pyenv/versions/debugpy/bin/python'
local env = '/Users/jeffor/.pyenv/versions/debugpy/bin/python'
dap.adapters.python = {
    type = 'executable';
    command = env;
    args = { '-m', 'debugpy.adapter' };
}

dap.configurations.python = {
    {
        -- The first three options are required by nvim-dap
        type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
        request = 'launch';
        name = "Launch file";

        -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options
        program = "${file}"; -- This configuration will launch the current file if used.
        pythonPath = function()
            return env
        end;
    },
}

local function DebugMappingKeyBindings(state)
    local opts = { noremap = true, silent = true }
    if state == 1 then
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

-- pause = "",
-- play = "",
-- step_into = "",
-- step_over = "",
-- step_out = "",
-- step_back = "",
-- run_last = "↻",
-- terminate = "□",

keymap("n", "<leader>b", "<cmd>lua require('dap').toggle_breakpoint()<CR>", {noremap= true, silent = true})
vim.fn.sign_define('DapBreakpoint', { text = '', texthl = 'DapBreakpoint'})
vim.fn.sign_define('DapStopped', { text = '', texthl = 'DapStopped'})

dap.listeners.after.event_initialized["dapui_config"] = function()
    DebugMappingKeyBindings(1)
end
dap.listeners.after.event_terminated["dapui_config"] = function()
    DebugMappingKeyBindings(0)
end

