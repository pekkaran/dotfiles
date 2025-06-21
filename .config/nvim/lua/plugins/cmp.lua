return {
  -- <https://github.com/hrsh7th/nvim-cmp>
  "hrsh7th/nvim-cmp",
  dependencies = {
    "hrsh7th/cmp-nvim-lsp",
    "L3MON4D3/LuaSnip",
    "saadparwaiz1/cmp_luasnip"
  },
  config = function()
    local cmp = require("cmp")
    cmp.setup({
      snippet = {
        expand = function(args)
          require("luasnip").lsp_expand(args.body)
        end,
      },
      window = {
        documentation = cmp.config.disable,
      },
      completion = {
        autocomplete = false, -- Do not trigger automatically.
      },
      mapping = cmp.mapping.preset.insert({
        ['<Tab>'] = cmp.mapping(function(fallback)
          local ls = require("luasnip")
          if cmp.visible() then
            cmp.select_next_item()
          else
            cmp.complete() -- Manually trigger.
            -- Expand the first suggestion.
            -- cmp.select_next_item({ behavior = cmp.SelectBehavior.Select })
            -- cmp.select_prev_item({ behavior = cmp.SelectBehavior.Insert })
          end
        end, { 'i', 's' }),

        ['<S-Tab>'] = cmp.mapping(function(fallback)
          local ls = require("luasnip")
          if cmp.visible() then
            cmp.select_prev_item()
          end
        end, { 'i', 's' }),

        ['<CR>'] = cmp.mapping.confirm({ select = true }),
      }),
      sources = {
        { name = 'nvim_lsp' },
        { name = 'luasnip' },
        { name = 'buffer' },
      },
      -- sources = cmp.config.sources({
      --   { name = 'nvim_lsp' },
      --   { name = 'luasnip' },
      -- },
      -- {
      --   { name = 'buffer' },
      -- }),
    })
  end
}
