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

autocmd("LspAttach", {
	group = BarmanjiGroup,

	callback = function(e)
		local opts = { buffer = e.buf }

		vim.keymap.set("n", "gd", vim.lsp.buf.definition, opts)

		vim.keymap.set("n", "K", function()
			vim.lsp.buf.hover({ border = "rounded" })
		end, opts)

		vim.keymap.set("n", "<leader>vws", vim.lsp.buf.workspace_symbol, opts)
		vim.keymap.set("n", "<leader>vde", vim.lsp.buf.declaration, opts)
		vim.keymap.set("n", "<leader>vd", vim.diagnostic.open_float, opts)
		vim.keymap.set("n", "<leader>vca", vim.lsp.buf.code_action, opts)
		vim.keymap.set("n", "<leader>vrr", vim.lsp.buf.references, opts)
		vim.keymap.set("n", "<leader>vrn", vim.lsp.buf.rename, opts)

		vim.keymap.set("i", "<C-h>", function()
			vim.lsp.buf.signature_help({ border = "rounded" })
		end, opts)

		-- Disable Tailwind document colors
		local client = vim.lsp.get_client_by_id(e.data.client_id)

		if client and client.name == "tailwindcss" then
			vim.lsp.document_color.enable(false, {
				bufnr = e.buf,
			})
		end
	end,
})
-- Safety net for every time you switch buffers
vim.api.nvim_create_autocmd("LspAttach", {
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        if client and client.name == "tailwindcss" then
            vim.lsp.document_color.enable(false, { bufnr = args.buf })
        end
    end,
})
--
-- For snacks.indent to fucking WORK
vim.api.nvim_create_autocmd("FileType", {
  pattern = { "javascript", "javascriptreact", "typescript", "typescriptreact", "json" },
  callback = function()
    vim.bo.shiftwidth = 2
    vim.bo.tabstop = 2
    vim.bo.expandtab = true
  end,
})

