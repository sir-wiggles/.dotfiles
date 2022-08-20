local keymap = vim.keymap.set
local api = vim.api

----------------- LSP servers --------------------------
local servers = {
    pyright = {
        analysis = {
            typeCheckingMode = "off",
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
}

-------------- LSP functions --------------------------
local function keymappings(_, bufnr)
    local opts = { noremap = true, silent = true }

    keymap("n", "K", vim.lsp.buf.hover, { buffer = bufnr })
    keymap("n", "[d", "<cmd>lua vim.diagnostic.goto_prev()<CR>", opts)
    keymap("n", "]d", "<cmd>lua vim.diagnostic.goto_next()<CR>", opts)
    keymap("n", "[e", "<cmd>lua vim.diagnostic.goto_prev({severity = vim.diagnostic.severity.ERROR})<CR>", opts)
    keymap("n", "]e", "<cmd>lua vim.diagnostic.goto_next({severity = vim.diagnostic.severity.ERROR})<CR>", opts)

    keymap('n', '<space>e', '<cmd>lua vim.diagnostic.open_float()<CR>', opts)

    keymap("n", "gd", "<Cmd>lua vim.lsp.buf.definition()<CR>", opts)
    keymap("n", "gD", "<Cmd>lua vim.lsp.buf.declaration()<CR>", opts)
    keymap("n", "gh", "<cmd>lua vim.lsp.buf.signature_help()<CR>", opts)
    keymap("n", "gI", "<cmd>Telescope lsp_implementations<CR>", opts)
    keymap("n", "gb", "<cmd>lua vim.lsp.buf.type_definition()<CR>", opts)

    local expr_opts = { noremap = true, expr = true }
    keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], expr_opts)
    keymap("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr_opts)
end

local function highlighting(client, bufnr)
    if client.server_capabilities.documentHighlightProvider then
        local lsp_highlight_grp = api.nvim_create_augroup("LspDocumentHighlight", { clear = true })
        api.nvim_create_autocmd("CursorHold", {
            callback = function()
                vim.schedule(vim.lsp.buf.document_highlight)
            end,
            group = lsp_highlight_grp,
            buffer = bufnr,
        })
        api.nvim_create_autocmd("CursorMoved", {
            callback = function()
                vim.schedule(vim.lsp.buf.clear_references)
            end,
            group = lsp_highlight_grp,
            buffer = bufnr,
        })
    end
end

local function lsp_handlers()
    local diagnostics = {
        Error = " ",
        Hint = " ",
        Information = " ",
        Question = " ",
        Warning = " ",
    }
    local signs = {
        { name = "DiagnosticSignError", text = diagnostics.Error },
        { name = "DiagnosticSignWarn", text = diagnostics.Warning },
        { name = "DiagnosticSignHint", text = diagnostics.Hint },
        { name = "DiagnosticSignInfo", text = diagnostics.Info },
    }
    for _, sign in ipairs(signs) do
        vim.fn.sign_define(sign.name, { texthl = sign.name, text = sign.text, numhl = sign.name })
    end

    -- LSP handlers configuration
    local config = {
        float = {
            focusable = true,
            style = "minimal",
            border = "rounded",
        },

        diagnostic = {
            virtual_text = false, -- disable inline error text
            signs = {
                active = signs,
            },
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

local function on_attach(client, bufnr)
    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")
    api.nvim_buf_set_option(bufnr, "completefunc", "v:lua.MiniCompletion.completefunc_lsp")

    vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]

    if client.server_capabilities.definitionProvider then
        api.nvim_buf_set_option(bufnr, "tagfunc", "v:lua.vim.lsp.tagfunc")
    end

    keymappings(client, bufnr)
    -- highlighting(client, bufnr)
end

----------------------------- LSP Setup -------------------------
local capabilities = vim.lsp.protocol.make_client_capabilities()
capabilities.textDocument.completion.completionItem.snippetSupport = true

lsp_handlers()

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
