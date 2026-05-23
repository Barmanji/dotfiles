--vim.opt.guicursor = ""


vim.opt.nu = true
vim.opt.relativenumber = true
vim.opt.tabstop = 4
vim.opt.softtabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.smartindent = true
vim.opt.autoindent = true

vim.opt.wrap = true

-- Enable folding ( setup in nvim-ufo )
vim.o.foldenable = true     -- Enable folding by default
vim.o.foldmethod = "manual" -- Default fold method (change as needed)
vim.o.foldlevel = 99        -- Open most folds by default
vim.o.foldcolumn = "0"

vim.opt.swapfile = false
vim.opt.backup = false
vim.opt.undodir = os.getenv("HOME") .. "/.vim/undodir"
vim.opt.undofile = true

vim.opt.termguicolors = true

vim.opt.scrolloff = 8
vim.opt.signcolumn = "yes"
vim.opt.isfname:append("@-@")

vim.opt.updatetime = 50

--vim.opt.colorcolumn = "80"
vim.opt.ignorecase = true
vim.opt.smartcase = true

-- backspace
vim.opt.backspace = { "start", "eol", "indent" }

-- clipboard
vim.opt.clipboard:append("unnamedplus") --use system clipboard as default
vim.opt.hlsearch = true
vim.opt.incsearch = true

-- for easy mouse resizing, just incase
vim.opt.mouse = "a"

-- gets rid of line with white spaces
vim.g.editorconfig = true

-- life saver
vim.g.netrw_browse_split = 0
vim.g.netrw_banner = 0
vim.g.netrw_winsize = 25

