-- lua/Barmanji/lazy/fold-collapse.lua
-- zA, zr, zm
return {
  {
    'kevinhwang91/nvim-ufo',
    dependencies = { 'kevinhwang91/promise-async' },
    event = "VeryLazy",
    init = function()
      -- SETTINGS
      vim.o.foldcolumn = '0'
      vim.o.foldlevel = 99
      vim.o.foldlevelstart = 99
      vim.o.foldenable = true

      -- PERSISTENCE: Save folds on close, load on open
      vim.opt.viewoptions:remove('cursor') -- don't save cursor position in the view
      vim.opt.viewoptions:remove('options') -- don't save local options

      vim.api.nvim_create_autocmd({ 'BufWinLeave' }, {
        pattern = '*.*',
        callback = function() vim.cmd('silent! mkview') end,
      })
      vim.api.nvim_create_autocmd({ 'BufWinEnter' }, {
        pattern = '*.*',
        callback = function() vim.cmd('silent! loadview') end,
      })
      -- COLORS: Define your custom colors here
      vim.api.nvim_set_hl(0, 'UfoFoldArrow', { fg = '#7aa2f7', bold = true }) -- colored Arrow
      vim.api.nvim_set_hl(0, 'UfoFoldCount', { fg = '#7aa2f7', bold = true }) -- colored Number

      vim.opt.fillchars = {
        foldopen = '',
        foldclose = '',
        foldsep = ' ',
        fold = ' ',
      }
      vim.opt.foldtext = ''

      -- KEYMAPS
      vim.keymap.set('n', 'zR', function()
        local ok, ufo = pcall(require, 'ufo')
        if ok then ufo.openAllFolds() end
      end)

      vim.keymap.set('n', 'zM', function()
        local ok, ufo = pcall(require, 'ufo')
        if ok then ufo.closeAllFolds() end
      end)

      -- Fold React/Next.js Functions only
      vim.keymap.set('n', '<leader>zf', function()
        local ok, ufo = pcall(require, 'ufo')
        if ok then ufo.closeFoldsWith(2) end
      end, { desc = 'Fold functions but keep internals open' })

      -- Peek mapping
      vim.keymap.set('n', '<leader>K', function()
        local ok, ufo = pcall(require, 'ufo')
        if ok and ufo.peekFoldedLinesUnderCursor then
          if ufo.peekFoldedLinesUnderCursor() then return end
        end
        if vim.lsp and vim.lsp.buf then pcall(vim.lsp.buf.hover) end
      end)
    end,

    config = function()
      local ufo = require('ufo')

      -- HANDLER: Colored Arrow and Number
      local handler = function(virtText, lnum, endLnum, width, truncate)
        local newVirtText = {}
        local arrow = ' 󰁂'
        local lnCount = (' %d '):format(endLnum - lnum)

        local suffixWidth = vim.fn.strdisplaywidth(arrow .. lnCount)
        local targetWidth = width - suffixWidth
        local curWidth = 0

        for _, chunk in ipairs(virtText) do
          local chunkText = chunk[1]
          local chunkWidth = vim.fn.strdisplaywidth(chunkText)
          if targetWidth > curWidth + chunkWidth then
            table.insert(newVirtText, chunk)
          else
            chunkText = truncate(chunkText, targetWidth - curWidth)
            table.insert(newVirtText, { chunkText, chunk[2] })
            chunkWidth = vim.fn.strdisplaywidth(chunkText)
            if curWidth + chunkWidth < targetWidth then
              lnCount = lnCount .. (' '):rep(targetWidth - curWidth - chunkWidth)
            end
            break
          end
          curWidth = curWidth + chunkWidth
        end

        table.insert(newVirtText, { arrow, 'UfoFoldArrow' })
        table.insert(newVirtText, { lnCount, 'UfoFoldCount' })
        return newVirtText
      end

      ufo.setup({
        provider_selector = function() return { 'treesitter', 'indent' } end,
        fold_virt_text_handler = handler,
      })
    end,
  },
}
