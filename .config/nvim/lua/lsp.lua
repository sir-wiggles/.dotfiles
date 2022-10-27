local keymap = vim.keymap.set
local api = vim.api

local exports = {}

local servers = {
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true
                }
            }
        },
    },
    sumneko_lua = {
        settings = {
            Lua = {
                runtime = {
                    version = "LuaJIT",
                    path = vim.split(package.path, ";"),
                },
                diagnostics = {
                    globals = { "vim" },
                },
                workspace = {
                    library = api.nvim_get_runtime_file("", true),
                },
                telemetry = { enable = false },
            },
        },
    },
    vimls = {
        settings = {}
    },
    gopls = {
        settings = {}
    },
    tsserver = {
        settings = {}
    }
}

local function handlers()
    local diagnostics = { Error = " ", Hint = " ", Information = " ", Question = " ", Warning = " " }
    local signs = {
        { name = "DiagnosticSignError", text = diagnostics.Error },
        { name = "DiagnosticSignWarn", text = diagnostics.Warning },
        { name = "DiagnosticSignHint", text = diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = diagnostics.Info },
    }
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end

    local config = {
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
        },

        diagnostic = {
            virtual_text = false, -- disable inline error text
            signs = { active = signs },
            underline = true,
            update_in_insert = false,
            severity_sort = true,
            float = {
                focusable = true,
                style = "minimal",
                border = "rounded",
                source = "always",
                header = "",
                prefix = "",
            },
        },
    }

    vim.diagnostic.config(config.diagnostic)
    vim.lsp.handlers["textDocument/hover"] = vim.lsp.with(vim.lsp.handlers.hover, config.float)
    vim.lsp.handlers["textDocument/signatureHelp"] = vim.lsp.with(vim.lsp.handlers.signature_help, config.float)
end

local function on_attach(_, bufnr)
    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]

    local opts = { noremap = true, silent = true }

    keymap("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
    keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

    keymap("n", "<space>e", "<cmd>lua vim.diagnostic.open_float()<CR>", opts)
    keymap("n", "<space>rn", "<cmd>lua vim.lsp.buf.rename()<CR>", opts)

    keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    keymap("n", "gI", "<cmd>lua vim.lsp.buf.implementation()<CR>", opts)
    keymap("n", "gb", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

end

local function omnifunc()
    local bufnr = vim.api.nvim_get_current_buf()

    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")
    api.nvim_buf_set_option(bufnr, "completefunc", "v:lua.MiniCompletion.completefunc_lsp")

    local expr_opts = { noremap = true, expr = true }
    keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], expr_opts)
    keymap("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr_opts)
end

function go_org_imports(wait_ms)
    local params = vim.lsp.util.make_range_params()
    params.context = { only = { "source.organizeImports" } }
    local result = vim.lsp.buf_request_sync(0, "textDocument/codeAction", params, wait_ms)
    for cid, res in pairs(result or {}) do
        for _, r in pairs(res.result or {}) do
            if r.edit then
                local enc = (vim.lsp.get_client_by_id(cid) or {}).offset_encoding or "utf-16"
                vim.lsp.util.apply_workspace_edit(r.edit, enc)
            end
        end
    end
end

vim.cmd([[ autocmd BufWritePre *.go lua go_org_imports() ]])

exports.active = function()
    local buf_clients = vim.lsp.buf_get_clients()
    if next(buf_clients) == nil then
        return "轢"
    end
    local buf_client_names = {}
    for _, client in pairs(buf_clients) do
        table.insert(buf_client_names, client.name)
    end
    return "歷" .. table.concat(buf_client_names, ", ")
end

exports.setup = function()
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities.textDocument.completion.completionItem.snippetSupport = false

    handlers()
    omnifunc()

    local opts = {
        on_attach = on_attach,
        capabilities = capabilities,
        flags = {
            debounce_text_changes = 150,
        },
    }

    local lspconfig = require("lspconfig")
    for server_name, config in pairs(servers) do
        local extended_opts = vim.tbl_deep_extend("force", opts, config or {})
        lspconfig[server_name].setup(extended_opts)
    end
end

return exports
