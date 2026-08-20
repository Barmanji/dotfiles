require("Barmanji.set")
require("Barmanji.remap")
require("Barmanji.lazy_init")

local augroup = vim.api.nvim_create_augroup
local BarmanjiGroup = augroup('Barmanji', {})

local autocmd = vim.api.nvim_create_autocmd
local yank_group = augroup('HighlightYank', {})

function R(name)
    require("plenary.reload").reload_module(name)
end

vim.filetype.add({
    extension = {
        templ = 'templ',
    }
})

autocmd('TextYankPost', {
    group = yank_group,
    pattern = '*',
    callback = function()
        vim.highlight.on_yank({
            higroup = 'IncSearch',
            timeout = 40,
        })
    end,
})

autocmd({ "BufWritePre" }, {
    group = BarmanjiGroup,
    pattern = "*",
    command = [[%s/\s\+$//e]],
})

autocmd('LspAttach', {
    group = BarmanjiGroup,
    callback = function(e)
        local opts = { buffer = e.buf }
        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        vim.keymap.set("n", "K",            function() vim.lsp.buf.hover({ border = "rounded" }) end, opts)
        vim.keymap.set("n", "<leader>vws",  function() vim.lsp.buf.workspace_symbol() end, opts)
        vim.keymap.set("n", "<leader>vde",  function() vim.lsp.buf.declaration() end, opts)
        vim.keymap.set("n", "<leader>vd",   function() vim.diagnostic.open_float() end, opts)
        vim.keymap.set("n", "<leader>vca",  function() vim.lsp.buf.code_action() end, opts)
        vim.keymap.set("n", "<leader>vrr",  function() vim.lsp.buf.references() end, opts)
        vim.keymap.set("n", "<leader>vrn",  function() vim.lsp.buf.rename() end, opts)
        vim.keymap.set("i", "<C-h>",        function() vim.lsp.buf.signature_help({border= "rounded"}) end, opts)
    end
})

-- GOD FUCKING DAMN WORKAROUND TO DISABLE FUCKING TAILWIND COLORIZER - I AM MAD
-- Disable LSP document colors
-- vim.lsp.document_color.enable(false)

-- Safety net for every time you switch buffers
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
    group = BarmanjiGroup,
    callback = function(args)
        vim.lsp.document_color.enable(false, args.buf)
    end,
})

-- For snacks.indent to fucking WORK
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})
