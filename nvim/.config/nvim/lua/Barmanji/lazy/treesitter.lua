return {
	{
		"nvim-treesitter/nvim-treesitter",
		branch = "main",
		lazy = false,
		build = ":TSUpdate",

		config = function()
			local ts = require("nvim-treesitter")

			-- Where parsers and their queries are installed.
			ts.setup({
				install_dir = vim.fn.stdpath("data") .. "/site",
			})

			-- Parsers we want available.
			local parsers = {
				"javascript",
				"typescript",
				"tsx",
				"go",
				"html",
				"css",
				"python",
				"bash",
				"lua",
				"vimdoc",
				"c",
				"rust",
				"prisma",
				"markdown",
				"markdown_inline",
			}

			-- Install/update parsers.
			ts.install(parsers)

			-- Enable Treesitter features when a supported filetype opens.
			vim.api.nvim_create_autocmd("FileType", {
				pattern = {
					"javascript",
					"javascriptreact",
					"typescript",
					"typescriptreact",
					"go",
					"html",
					"css",
					"python",
					"bash",
					"lua",
					"vimdoc",
					"c",
					"rust",
					"prisma",
					"markdown",
				},

				callback = function(args)
					local buf = args.buf

					-- Preserve your 50 KB performance safeguard.
					local filename = vim.api.nvim_buf_get_name(buf)
					local ok, stats = pcall(vim.uv.fs_stat, filename)

					if ok and stats and stats.size > 50 * 1024 then
						vim.notify(
							"File larger than 50KB: Treesitter disabled for performance",
							vim.log.levels.WARN,
							{ title = "Treesitter" }
						)
						return
					end

					-- Native Neovim Treesitter highlighting.
					vim.treesitter.start(buf)

					-- Treesitter indentation.
					--
					-- nvim-treesitter documents this as experimental,
					-- so only enable it when the language actually has
					-- an indent query.
					local lang = vim.treesitter.language.get_lang(args.match)

					if lang and vim.treesitter.query.get(lang, "indents") then
						vim.bo[buf].indentexpr =
							"v:lua.require'nvim-treesitter'.indentexpr()"
					end

					-- Treesitter folds.
					vim.wo[0][0].foldexpr =
						"v:lua.vim.treesitter.foldexpr()"
					vim.wo[0][0].foldmethod = "expr"
				end,
			})
		end,
	},

	{
		"nvim-treesitter/nvim-treesitter-context",
		event = "VeryLazy",

		config = function()
			require("treesitter-context").setup({
				enable = true,
				throttle = true,
				max_lines = 1,

				patterns = {
					default = {
						"class",
						"function",
						"method",
					},
				},
			})
		end,
	},
}
