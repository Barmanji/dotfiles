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
        -- vim.lsp.document_color.enable(false, e.buf)
        local opts = { buffer = e.buf }
        -- Automatically close location list and quickfix windows with q
        -- vim.keymap.set("n", "<leader>q", function()
        --     local win = vim.api.nvim_get_current_win()
        --     local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win), 'filetype')
        --
        --     -- If it's a location list (LSP) or quickfix window, close it
        --     if filetype == "qf" or filetype == "loclist" then
        --         vim.cmd("q") -- Close window with :q
        --     else
        --         -- Don't show a message or interfere with other windows
        --         -- Simply let Vim handle the normal behavior for non-LSP windows
        --         -- You could optionally add more custom behavior here if desired
        --         return
        --     end
        -- end, { noremap = true, silent = true })

        -- Your existing mapping for "gd" (LSP definition)
        vim.keymap.set("n", "gd", function()
            vim.lsp.buf.definition()
        end, opts)
        -- vim.keymap.set("n", "gD", function() vim.lsp.buf.peek_definition() end, opts) -- Opens in a floating window if supported
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

-- 1. Kill it globally right now
vim.lsp.document_color.enable(false)

-- 2. Intercept the server trying to turn it back on later
vim.lsp.handlers['client/registerCapability'] = (function(overridden)
    return function(err, res, ctx)
        local result = overridden(err, res, ctx)
        local client = vim.lsp.get_client_by_id(ctx.client_id)
        if client then
            for bufnr, _ in pairs(client.attached_buffers) do
                vim.lsp.document_color.enable(false, bufnr)
            end
        end
        return result
    end
end)(vim.lsp.handlers['client/registerCapability'])

-- 3. Safety net for every time you switch buffers
vim.api.nvim_create_autocmd({ "BufEnter", "LspAttach" }, {
    group = BarmanjiGroup,
    callback = function(args)
        vim.lsp.document_color.enable(false, args.buf)
    end,
})
