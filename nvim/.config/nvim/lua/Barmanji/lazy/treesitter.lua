return {
  {
    'nvim-treesitter/nvim-treesitter',
    event = { 'BufReadPre', 'BufNewFile' },
    branch = 'master',
    build = ':TSUpdate',
    config = function()
      -- import nvim-treesitter plugin
      require('nvim-treesitter.configs').setup {
        highlight = {
          -- `false` will disable the whole extension
          enable = true,
          disable = function(lang, buf)
            if lang == 'html' then
              print 'disabled'
              return true
            end

            local max_filesize = 100 * 1024 -- 100 KB
            local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
            if ok and stats and stats.size > max_filesize then
              vim.notify('File larger than 100KB treesitter disabled for performance', vim.log.levels.WARN, { title = 'Treesitter' })
              return true
            end
          end,

          -- Setting this to true will run `:h syntax` and tree-sitter at the same time.
          -- Set this to `true` if you depend on "syntax" being enabled (like for indentation).
          -- Using this option may slow down your editor, and you may see some duplicate highlights.
          -- Instead of true it can also be a list of languages
          additional_vim_regex_highlighting = { 'markdown' },
        },

        -- enable indentation
        indent = { enable = true },

        -- ensure these languages parsers are installed
        ensure_installed = {
          'javascript',
          'typescript',
          'tsx',
          'go',
          'html',
          'css',
          'python',
          'bash',
          'lua',
          'vimdoc',
          'c',
          'rust',
        'prisma'
        },
        incremental_selection = {
          enable = true,
          keymaps = {
            init_selection = '<C-space>',
            node_incremental = '<C-space>',
            scope_incremental = false,
          },
        },
        additional_vim_regex_highlighting = false,
      }
    end,
  },
  -- NOTE: js,ts,jsx,tsx Auto Close Tags
  {
    'nvim-treesitter/nvim-treesitter-context',
    event = 'VeryLazy', -- or set to same events as treesitter
    config = function()
      require('treesitter-context').setup {
        enable = true, -- Enable this plugin (default is true)
        throttle = true, -- Performance optimization
        max_lines = 1, -- How many lines to show at top (set 0 for unlimited)
        patterns = { -- Custom patterns for context
          default = {
            'class',
            'function',
            'method',
          },
        },
      }
    end,
  },
}
