return {
	"neovim/nvim-lspconfig",
	event = { "BufReadPre", "BufNewFile" },
	dependencies = {
		{
			"mason.nvim",
			opts = {},
		},
		{
			"mason-org/mason-lspconfig.nvim",
			opts = {
				ensure_installed = {
					"lua_ls",
					"rust_analyzer",
					"gopls",
					"tailwindcss",
				},
				automatic_enable = true,
			},
		},
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"hrsh7th/nvim-cmp",
		"L3MON4D3/LuaSnip",
		"saadparwaiz1/cmp_luasnip",
		"j-hui/fidget.nvim",
	},

	config = function()
		local cmp = require("cmp")
		local cmp_lsp = require("cmp_nvim_lsp")

		local capabilities =
			vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities(), cmp_lsp.default_capabilities())

		----------------------------------------------------------------------
		-- Mason
		----------------------------------------------------------------------

		require("mason").setup()
		require("fidget").setup({})

		----------------------------------------------------------------------
		-- Global LSP capabilities
		----------------------------------------------------------------------

		vim.lsp.config("*", {
			capabilities = capabilities,
		})

		----------------------------------------------------------------------
		-- Lua
		----------------------------------------------------------------------

		vim.lsp.config("lua_ls", {
			settings = {
				Lua = {
					runtime = {
						version = "LuaJIT",
					},

					diagnostics = {
						globals = {
							"vim",
						},
					},

					workspace = {
						library = {
							vim.env.VIMRUNTIME,
							"${3rd}/luv/library",
						},

						checkThirdParty = false,
					},

					format = {
						enable = true,

						defaultConfig = {
							indent_style = "space",
							indent_size = "2",
						},
					},
				},
			},
		})

		----------------------------------------------------------------------
		-- Tailwind
		----------------------------------------------------------------------

		vim.lsp.config("tailwindcss", {
			filetypes = {
				"html",
				"css",
				"scss",
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
				"vue",
				"svelte",
				"heex",
			},

			settings = {
				tailwindCSS = {
					classAttributes = {
						"class",
						"className",
						"classList",
						"ngClass",
					},

					lint = {
						cssConflict = "warning",
						invalidApply = "error",
						invalidConfigPath = "error",
						invalidTailwindDirective = "error",
						recommendedVariantOrder = "warning",
					},

					validate = true,
				},
			},
		})

		----------------------------------------------------------------------
		-- TypeScript-Go / native TypeScript LSP
		----------------------------------------------------------------------

		vim.lsp.config("tsc", {
			cmd = {
				"tsc",
				"--lsp",
				"--stdio",
			},

			filetypes = {
				"javascript",
				"javascriptreact",
				"typescript",
				"typescriptreact",
			},

			root_markers = {
				"tsconfig.json",
				"jsconfig.json",
				"package.json",
				".git",
			},
		})

		vim.lsp.enable("tsc")

		----------------------------------------------------------------------
		-- Completion
		----------------------------------------------------------------------

		local cmp_select = {
			behavior = cmp.SelectBehavior.Select,
		}

		cmp.setup({
			snippet = {
				expand = function(args)
					require("luasnip").lsp_expand(args.body)
				end,
			},

			formatting = {
				format = require("tailwindcss-colorizer-cmp").formatter,
			},

			window = {
				completion = cmp.config.window.bordered({
					border = "rounded",
				}),

				documentation = cmp.config.window.bordered({
					border = "rounded",
				}),
			},

			mapping = cmp.mapping.preset.insert({
				["<C-p>"] = cmp.mapping.select_prev_item(cmp_select),
				["<C-n>"] = cmp.mapping.select_next_item(cmp_select),
				["<C-y>"] = cmp.mapping.confirm({
					select = true,
				}),
				["<C-Space>"] = cmp.mapping.complete(),
			}),

			sources = cmp.config.sources({
				{ name = "copilot" },
				{ name = "nvim_lsp" },
				{ name = "luasnip" },
				{ name = "path" },
			}, {
				{ name = "buffer" },
			}),
		})

		----------------------------------------------------------------------
		-- Diagnostics
		----------------------------------------------------------------------

		vim.diagnostic.config({
			virtual_text = true,
			signs = true,
			underline = true,

			update_in_insert = false,

			float = {
				focusable = false,
				style = "minimal",
				border = "rounded",
				source = true,
				header = "",
				prefix = "",
			},
		})
	end,
}
