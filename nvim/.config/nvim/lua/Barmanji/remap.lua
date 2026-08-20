vim.g.mapleader = ' '
-- vim.keymap.set("n", "<leader>pv", vim.cmd.Ex) Now doing with Oil

vim.keymap.set('v', 'J', ":m '>+1<CR>gv=gv")
vim.keymap.set('v', 'K', ":m '<-2<CR>gv=gv")


vim.keymap.set('n', 'J', 'mzJ`z')
vim.keymap.set('n', '<C-d>', '<C-d>zz')
vim.keymap.set('n', '<C-u>', '<C-u>zz')
vim.keymap.set('n', 'n', 'nzzzv')
vim.keymap.set('n', 'N', 'Nzzzv')

vim.keymap.set('n', '<leader>h', ':nohlsearch<CR>')
vim.keymap.set('n', '<leader>lr', '<cmd>LspRestart<cr>')

-- greatest remap ever
vim.keymap.set('x', '<leader>p', [["_dP]])

-- next greatest remap ever : asbjornHaland
vim.keymap.set({ 'n', 'v' }, '<leader>y', [["+y]]) -- copied to system clip
vim.keymap.set('n', '<leader>Y', [["+Y]])

vim.keymap.set({ 'n', 'v' }, '<leader>d', [["_d]])

vim.keymap.set('n', '<leader>ss', function()
  vim.cmd 'so'
end)

-- This is going to get me cancelled
vim.keymap.set('i', '<C-c>', '<Esc>')

-- vim.keymap.set("n", "Q", "<nop>")
vim.keymap.set('n', '<C-f>', '<cmd>silent !tmux neww ~/scripts/tmux_sessionizer<CR>') -- TODO Gotta work on this

--these 4 below cmds are fucking my normal window tab manuvering so i commented em!
--Quickfix my ass
vim.keymap.set('n', '<C-k>', '<cmd>cnext<CR>zz')
vim.keymap.set('n', '<C-j>', '<cmd>cprev<CR>zz')
vim.keymap.set('n', '<leader>k', '<cmd>lnext<CR>zz')
vim.keymap.set('n', '<leader>j', '<cmd>lprev<CR>zz')

vim.keymap.set('n', '<leader>s', [[:%s/\<<C-r><C-w>\>/<C-r><C-w>/gI<Left><Left><Left>]])
vim.keymap.set('n', '<leader>cx', '<cmd>!chmod u+x %<CR>', { silent = true })

vim.keymap.set('n', '<leader>F', vim.lsp.buf.format)

vim.keymap.set('n', '<leader>mr', '<cmd>CellularAutomaton make_it_rain<CR>')
vim.keymap.set('n', '<leader>ms', '<cmd>CellularAutomaton scramble<CR>')

-- This tells Neovim to treat Tab and Ctrl-I as different keys if the terminal supports it
vim.keymap.set('n', '<leader><Tab>', 'za', { desc = 'Toggle fold' })

vim.keymap.set('n', '<leader>x', '<cmd>close<CR>', { desc = 'Close current split' })

-- Copy filepath to the clipboard - I LVOE THIS
vim.keymap.set('n', '<leader>fp', function()
  local filePath
  local ok, oil = pcall(require, 'oil')
  if ok and vim.bo.filetype == 'oil' then
    filePath = oil.get_current_dir()
  else
    filePath = vim.fn.expand '%:~'
  end
  vim.fn.setreg('+', filePath)
  print('File path copied to clipboard: ' .. filePath)
end, { desc = 'Copy file path to clipboard' })

-- Toggle LSP diagnostics visibility
local isLspDiagnosticsVisible = true
vim.keymap.set('n', '<leader>lx', function()
  isLspDiagnosticsVisible = not isLspDiagnosticsVisible
  vim.diagnostic.config {
    virtual_text = isLspDiagnosticsVisible,
    underline = isLspDiagnosticsVisible,
  }
end, { desc = 'Toggle LSP diagnostics' })

vim.keymap.set('n', '<leader>ce', function()
vim.cmd('Copilot enable')
  print ('Copilot enabled')
end, { desc = 'Enabled Copilot' })

vim.keymap.set('n', '<leader>cd', function()
  vim.cmd('Copilot disable')
  print ('Copilot disabled')
end, { desc = 'Disabled Copilot' })


-- Wilder is a bitch -> GIVE MULTIPLE KEY JESUS
vim.keymap.set('c', '<Tab>', function()
    local w = require('wilder')
    return w.in_context() and w.next() or '<Tab>'
end, { expr = true })

vim.keymap.set('c', '<S-Tab>', function()
    local w = require('wilder')
    return w.in_context() and w.previous() or '<S-Tab>'
end, { expr = true })
