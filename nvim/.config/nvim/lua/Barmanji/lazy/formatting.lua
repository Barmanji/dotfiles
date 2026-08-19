return {
  {
    'stevearc/conform.nvim',
    event = { 'BufReadPre', 'BufNewFile' },
    config = function()
      local conform = require 'conform'

      conform.setup {
        formatters = {
          ['markdown-toc'] = {
            condition = function(_, ctx)
              for _, line in ipairs(vim.api.nvim_buf_get_lines(ctx.buf, 0, -1, false)) do
                if line:find '<!%-%- toc %-%->' then
                  return true
                end
              end
            end,
          },
          ['markdownlint-cli2'] = {
            condition = function(_, ctx)
              local diag = vim.tbl_filter(function(d)
                return d.source == 'markdownlint'
              end, vim.diagnostic.get(ctx.buf))
              return #diag > 0
            end,
          },
        },
        formatters_by_ft = {
          javascript = { 'prettier' },
          typescript = { 'prettier' },
          javascriptreact = { 'prettier' },
          typescriptreact = { 'prettier' },
          rust = { 'rustfmt', lsp_format = 'fallback' },
          css = { 'prettier' },
          scss = { 'prettier' },
          html = { 'prettier' },
          json = { 'prettier' },
          yaml = { 'prettier' },
          lua = { 'stylua' },
          python = { 'black' },
          java = { 'prettier' },
          graphql = { 'prettier' },
          liquid = { 'prettier' },
          svelte = { 'prettier' },
          prisma = { "prismaFmt", lsp_format='fallback' },
          markdown = { 'prettier' },
          ['markdown.mdx'] = { 'prettier', 'markdownlint-cli2', 'markdown-toc' },
        },
        -- format_on_save = {
        --     lsp_fallback = true,
        --     async = false,
        --     timeout_ms = 1000,
        -- },
      }

      -- Configure individual formatters
      conform.formatters.prettier = {
        args = {
          '--stdin-filepath',
          '$FILENAME',
          '--tab-width',
          '2',
          '--use-tabs',
          'false',
        },
      }
      conform.formatters.shfmt = {
        prepend_args = { '-i', '4' },
      }

      vim.keymap.set({ 'n', 'v' }, '<leader>f', function()
        conform.format {
          lsp_fallback = true,
          async = false,
          timeout_ms = 1000,
        }
      end, { desc = ' Prettier Format whole file or range (in visual mode) with' })
    end,
  },
  -- NOTE: Dressing for Renames
  {
    'stevearc/dressing.nvim',
    event = 'VeryLazy',
  },
      { -- FOR not having `vim` undefined Error:
    'folke/lazydev.nvim',
    ft = 'lua', -- only load on lua files
    opts = {
      library = {
        -- Load luvit types when the `vim.uv` word is found
        { path = 'luvit-meta/library', words = { 'vim%.uv' } },
      },
    },
  },

}
