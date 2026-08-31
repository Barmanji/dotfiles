return {
	{
		"nvim-treesitter/nvim-treesitter",
		event = { "BufReadPre", "BufNewFile" },
		branch = "main",
		build = ":TSUpdate",
		-- The new API configures settings via the 'opts' table directly
		opts = {
			highlight = {
				enable = true,
				disable = function(lang, buf)
					if lang == "html" or lang == "css" then
						print("disabled")
						return true
					end

					local max_filesize = 50 * 1024 -- 50 KB
					local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
					if ok and stats and stats.size > max_filesize then
						vim.notify(
							"File larger than 50KB treesitter disabled for performance",
							vim.log.levels.WARN,
							{ title = "Treesitter" }
						)
						return true
					end
				end,
          additional_vim_regex_highlighting = { 'markdown' },
			},
			indent = { enable = true },

			ensure_installed = {
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
				"markdown", -- Critical for definition 'K' windows
				"markdown_inline", -- Critical for definition 'K' windows
			},
			incremental_selection = {
				enable = true,
				keymaps = {
					init_selection = "<C-space>",
					node_incremental = "<C-space>",
					scope_incremental = false,
				},
			},
		},
		-- Use the root module setup to feed opts directly into the new architecture
		config = function(_, opts)
			require("nvim-treesitter").setup(opts)
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
