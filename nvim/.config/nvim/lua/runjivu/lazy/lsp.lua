return {
    'neovim/nvim-lspconfig',
    dependencies = {
        --- Uncomment these if you want to manage LSP servers from neovim
        "williamboman/mason.nvim",
        "williamboman/mason-lspconfig.nvim",

        -- Autocompletion
        "hrsh7th/nvim-cmp",
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
        "j-hui/fidget.nvim",
    },

    config = function()
        local cmp_lsp = require("cmp_nvim_lsp")
        -- not sure what da fuq this does
        local capabilities = cmp_lsp.default_capabilities()

        require("mason").setup()
        require("mason-lspconfig").setup {
            ensure_installed = {
                'rust_analyzer', 'pyright', 'yamlls', 'helm_ls', 'lua_ls',
                'codeqlls', 'sqlls', 'terraformls', 'tflint', 'kotlin_lsp'
            },
            handlers = {
                function(server_name) -- default handler (optional)
                    require("lspconfig")[server_name].setup({
                        capabilities = capabilities
                    })
                end,
                ["lua_ls"] = function()
                    local lspconfig = require("lspconfig")
                    lspconfig.lua_ls.setup {
                        capabilities = capabilities,
                        settings = {
                            Lua = {
                                runtime = { version = "Lua 5.1" },
                                diagnostics = {
                                    globals = { "bit", "vim", "it", "describe", "before_each", "after_each" },
                                }
                            }
                        }
                    }
                end,
                ["terraformls"] = function()
                    require("lspconfig").terraformls.setup {
                        capabilities = capabilities,
                        filetypes = { "terraform", "terraform-vars", "tf" },
                    }
                end,
                ["helm_ls"] = function()
                    require("lspconfig").helm_ls.setup {
                        capabilities = capabilities,
                        filetypes = { "helm" },
                        settings = {
                            ['helm-ls'] = {
                                yamlls = {
                                    path = "yaml-language-server",
                                },
                            }
                        }
                    }
                end,

                ["yamlls"] = function()
                    require('lspconfig').yamlls.setup {
                        capabilities = capabilities,
                        settings = {
                            redhat = {
                                telemetry = {
                                    enabled = false,
                                },
                            },
                            yaml = {
                                trace = {
                                    server = "verbose",
                                },
                                completion = true,
                                hover = true,
                                validate = true,
                                format = {
                                    enable = true,
                                },
                                schemaStore = {
                                    -- Must disable built-in schemaStore support to use
                                    -- schemas from SchemaStore.nvim plugin
                                    enable = false,
                                    -- Avoid TypeError: Cannot read properties of undefined (reading "length")
                                    url = "",
                                },
                                schemas = {
                                    ["kubernetes"] = "*.k8s.{yaml,yml}",
                                    -- JSON & YAML schemas http://schemastore.org/json/
                                    ["https://json.schemastore.org/github-action"] = ".github/action.{yml,yaml}",
                                    ["https://json.schemastore.org/github-workflow"] = ".github/workflows/*.{yml,yaml}"
                                }
                            }
                        },
                    }
                end,
                --[[ enable this when needed, needs to set up codeql repo
                codeqlls = function()
                    require('lspconfig').codeqlls.setup {
                        settings = {
                            codeQL = {
                                additional_packs = {"/opt/homebrew/Caskroom/codeql/2.18.1/codeql/codeql-repo"}
                            }
                        },
                        on_attach = lsp_zero.on_attach
                    }
                end,
                ]] --
            }
        }

        vim.api.nvim_create_autocmd('LspAttach', {
            group = vim.api.nvim_create_augroup('UserLspConfig', {}),
            callback = function(ev)
                local opts = {buffer = ev.buf}
                vim.keymap.set("n", "<leader>gd", function() vim.lsp.buf.definition() end, opts)
                vim.keymap.set("n", "K", function() vim.lsp.buf.hover() end, opts)
                vim.keymap.set("n", "<leader>vws", function() vim.lsp.buf.workspace_symbol() end, opts)
                vim.keymap.set("n", "<leader>vd", function() vim.diagnostic.open_float() end, opts)
                vim.keymap.set("n", "[d", function() vim.diagnostic.goto_next() end, opts)
                vim.keymap.set("n", "]d", function() vim.diagnostic.goto_prev() end, opts)
                vim.keymap.set("n", "<leader>vca", function() vim.lsp.buf.code_action() end, opts)
                vim.keymap.set("n", "<leader>vrr", function() vim.lsp.buf.references() end, opts)
                vim.keymap.set("n", "<leader>vrn", function() vim.lsp.buf.rename() end, opts)
                vim.keymap.set("i", "<C-h>", function() vim.lsp.buf.signature_help() end, opts)
            end,
        })

        require("fidget").setup()
    end
}
