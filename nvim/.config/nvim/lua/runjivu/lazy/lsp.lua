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
        local capabilities = vim.tbl_deep_extend(
            "force",
            {},
            vim.lsp.protocol.make_client_capabilities(),
            cmp_lsp.default_capabilities())

        require("mason").setup()
        require("mason-lspconfig").setup {
            ensure_installed = {
                'rust_analyzer', 'pyright', 'yamlls',
                'codeqlls', 'sqlls', 'terraformls', 'tflint'
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
                                    ["kubernetes"] = "*.{yaml,yml}",
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
        require("fidget").setup()
    end
}
