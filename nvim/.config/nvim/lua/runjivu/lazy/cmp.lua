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

return {
    "hrsh7th/nvim-cmp",
    dependencies = {
        "hrsh7th/cmp-nvim-lsp",
        "hrsh7th/cmp-buffer",
        "hrsh7th/cmp-path",
        "hrsh7th/cmp-nvim-lua",
        "saadparwaiz1/cmp_luasnip",
        "L3MON4D3/LuaSnip",
    },
    config = function()
        local cmp = require('cmp')
        local cmp_select = {behavior = cmp.SelectBehavior.Select}

        cmp.setup({
            snippet = {
                expand = function(args)
                    require('luasnip').lsp_expand(args.body) -- For `luasnip` users.
                end,
            },
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
    end
}
