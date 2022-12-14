local keymap = vim.keymap.set
local api = vim.api

local exports = {}

local capabilities = require('cmp_nvim_lsp').default_capabilities(vim.lsp.protocol.make_client_capabilities())
capabilities.textDocument.completion.completionItem.snippetSupport = true

local servers = {
    pyright = {
        settings = {
            python = {
                analysis = {
                    autoSearchPaths = true,
                    diagnosticMode = "workspace",
                    useLibraryCodeForTypes = true,
                },
                venvPath = "/Users/jeffor/Library/Caches/pypoetry/virtualenvs/",
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
                    checkThirdParty = false,
                },
                telemetry = { enable = false },
            },
        },
    },
    vimls = {
        settings = {}
    },
    gopls = {
        capabilities = capabilities,
        settings = {
            gopls = {
                experimentalPostfixCompletions = true,
                analyses = {
                    unusedparams = true,
                    shadow = true,
                },
                gofumpt = true,
                staticcheck = true,
            },
        },
        init_options = {
            usePlaceholders = true,
        }
    },
    tsserver = {
        settings = {}
    },
    graphql = {
        settings = {}
    },
}


local function handlers()
    local sign = function(opts)
        vim.fn.sign_define(opts.name, {
            texthl = opts.name,
            text = opts.text,
            numhl = ''
        })
    end

    sign({ name = 'DiagnosticSignError', text = '✘' })
    sign({ name = 'DiagnosticSignWarn', text = '▲' })
    sign({ name = 'DiagnosticSignHint', text = '⚑' })
    sign({ name = 'DiagnosticSignInfo', text = '' })

    -- local diagnostics = { Error = " ", Hint = " ", Information = " ", Question = " ", Warning = " " }

    vim.diagnostic.config({
        virtual_text = false,
        severity_sort = true,
        float = {
            border = 'rounded',
            source = 'always',
            header = '',
            prefix = '',
        },
    })


    vim.lsp.handlers['textDocument/hover'] = vim.lsp.with(
        vim.lsp.handlers.hover,
        { border = 'rounded' }
    )

    vim.lsp.handlers['textDocument/signatureHelp'] = vim.lsp.with(
        vim.lsp.handlers.signature_help,
        { border = 'rounded' }
    )

    vim.lsp.handlers["textDocument/references"] = require("telescope.builtin").lsp_references

    require('lspconfig.ui.windows').default_options = {
        border = 'rounded'
    }
end

vim.api.nvim_create_autocmd('LspAttach', {
    desc = 'LSP actions',
    callback = function()
        vim.cmd [[autocmd BufWritePre <buffer> lua vim.lsp.buf.formatting_sync()]]

        local opts = { noremap = true, silent = true }

        keymap("n", "K", vim.lsp.buf.hover, opts)
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
        keymap("n", "gr", "<cmd>lua vim.lsp.buf.references()<cr>", opts)
    end
})

local function omnifunc()
    local bufnr = vim.api.nvim_get_current_buf()

    api.nvim_buf_set_option(bufnr, "omnifunc", "v:lua.MiniCompletion.completefunc_lsp")
    api.nvim_buf_set_option(bufnr, "completefunc", "v:lua.MiniCompletion.completefunc_lsp")

    local expr_opts = { noremap = true, expr = true }
    keymap("i", "<Tab>", [[pumvisible() ? "\<C-n>" : "\<Tab>"]], expr_opts)
    keymap("i", "<S-Tab>", [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], expr_opts)
end

function GoImports(wait_ms)
    local params = vim.lsp.util.make_range_params()

    params.context = { only = { "source.organizeImports" } }
    params.context = { source = { organizeImports = true } }

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

vim.cmd([[ autocmd BufWritePre *.go lua GoImports() ]])

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
    local lspconfig = require("lspconfig")

    handlers()
    omnifunc()

    local opts = {
        flags = {
            debounce_text_changes = 150,
        },
    }

    for server_name, config in pairs(servers) do
        local extended_opts = vim.tbl_deep_extend("force", opts, config or {})
        lspconfig[server_name].setup(extended_opts)
    end
end

return exports
