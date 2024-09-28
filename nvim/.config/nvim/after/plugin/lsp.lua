local lsp_zero = require('lsp-zero')

lsp_zero.on_attach(function(client, bufnr)
  local opts = {buffer = bufnr, remap = false}

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
end)

require('mason').setup({})
require('mason-lspconfig').setup({
    ensure_installed = {'rust_analyzer', 'pyright', 'yamlls', 'codeqlls', 'sqlls'},
    handlers = {
        lsp_zero.default_setup,
        lua_ls = function()
            local lua_opts = lsp_zero.nvim_lua_ls()
            require('lspconfig').lua_ls.setup(lua_opts)
        end,
        yamlls = function()
            require('lspconfig').yamlls.setup {
                settings = {
                    yaml = {
                        schemas = {
                            kubernetes = "*.k8s.{yaml, yml}",
                            ["https://json.schemastore.org/kustomization.json"] = "kustomization.yaml"
                        },
                    },
                },
                on_attach = lsp_zero.on_attach
            }
        end,
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
--        sqlls = function()
--            require('lspconfig').sqlls.setup{
--                on_attach = function(client, bufnr)
--                    -- Enable formatting capability
--                    client.server_capabilities.documentFormattingProvider = true
--
--                    -- Format on save (optional)
--                    if client.server_capabilities.documentFormattingProvider then
--                        vim.cmd([[
--                            augroup LspFormatting
--                                autocmd! * <buffer>
--                                autocmd BufWritePre <buffer> lua vim.lsp.buf.format()
--                            augroup END
--                        ]])
--                    end
--
--                    -- Your existing on_attach function
--                    lsp_zero.on_attach(client, bufnr)
--                end,
--                settings = {
--                    sqlLanguageServer = {
--                        formatter = {
--                            -- Specify the formatter you installed
--                            -- For `sql-formatter` (installed via npm)
--                            executablePath = 'sql-formatter',
--
--                            -- For `sqlfmt` (installed via pip), use:
--                            -- executablePath = 'sqlfmt',
--                        },
--                    },
--                },
--                root_dir = function(fname)
--                    return vim.fn.getcwd()
--                end,
--            }
--        end,
    }
})

lsp_zero.configure('pyright', {
    settings = {
        python = {
            analysis = {
                autoSearchPaths = true,
                diagnosticMode = "workspace",
                useLibraryCodeForTypes = true
            }
        }
    }
})

local cmp = require('cmp')
local cmp_select = {behavior = cmp.SelectBehavior.Select}

-- Custom cmp_format function
local function custom_cmp_format(opts)
  opts = opts or {}
  local maxwidth = opts.max_width or false
  local details = type(opts.details) == 'boolean' and opts.details or false

  local fields = details
      and { 'abbr', 'kind', 'menu' }
      or { 'abbr', 'menu', 'kind' }

  return {
    fields = fields,
    format = function(entry, item)
      local n = entry.source.name
      local label = ''

      if opts.menu and opts.menu[n] then
        label = opts.menu[n]
      elseif n == 'nvim_lsp' then
        label = '[LSP]'
      elseif n == 'nvim_lua' then
        label = '[nvim]'
      else
        label = string.format('[%s]', n)
      end

      if details and item.menu ~= nil then
        item.menu = string.format('%s %s', label, item.menu)
      else
        item.menu = label
      end

      if maxwidth and #item.abbr > maxwidth then
        local last = item.kind == 'Snippet' and '~' or ''
        item.abbr = string.format('%s%s', string.sub(item.abbr, 1, maxwidth), last)
      end

      return item
    end,
  }
end

cmp.setup({
  sources = {
    {name = 'path'},
    {name = 'vim-dadbod-completion'},
    {name = 'nvim_lsp'},
    {name = 'nvim_lua'},
    {name = 'luasnip', keyword_length = 2},
    {name = 'buffer', keyword_length = 3},
  },
 formatting = custom_cmp_format({
    menu = {
      ['vim-dadbod-completion'] = '[DB]',
      buffer                    = '[BUF]',
      nvim_lsp                  = '[LSP]',
      nvim_lua                  = '[API]',
      path                      = '[PATH]',
      luasnip                   = '[SNIP]',
      -- Add other sources as needed
    },
    -- Additional options can be set here
    -- max_width = 50,
    -- details = true,
  }),
  mapping = cmp.mapping.preset.insert({
    ['<C-p>'] = cmp.mapping.select_prev_item(cmp_select),
    ['<C-n>'] = cmp.mapping.select_next_item(cmp_select),
    ['<C-y>'] = cmp.mapping.confirm({ select = true }),
    ['<C-Space>'] = cmp.mapping.complete(),
  }),
})
