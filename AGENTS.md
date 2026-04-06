# AGENTS.md - Dotfiles Development Guidelines

## Overview

This is a dotfiles repository containing configuration files for various tools: Neovim, Tmux, Hyprland, Ghostty, Kitty, and more. The primary "code" component is the Neovim Lua configuration.

---

## Build, Lint, Test Commands

### Neovim Configuration

```bash
# Validate Neovim config on startup
nvim --headless -c "quit" 2>&1

# Check for Lua syntax errors
luac -p ~/.config/nvim/lua/Barmanji/**/*.lua

# Run Neovim health check
nvim --headless -c "checkhealth" -c "quit"

# Lua linter (if luacheck installed)
luacheck ~/.config/nvim/lua/Barmanji/
```

### Shell Scripts

```bash
# Lint shell scripts with shellcheck
shellcheck scripts/*.sh

# Syntax check bash scripts
bash -n scripts/script-name.sh
```

### Running a Single Test

There are no automated tests in this repository.

---

## Code Style Guidelines

### Neovim Lua

#### File Structure

```lua
-- Header: Module requires
local M = {}
local lspconfig = require 'lspconfig'

-- Key mappings (grouped by mode)
local keymap = vim.keymap.set

-- Main configuration functions
function M.setup()
  -- Implementation
end

-- Return module
return M
```

#### Naming Conventions

- **Variables/functions**: `snake_case` (e.g., `setup_lsp`, `buffer_options`)
- **Modules**: `PascalCase` for module names, `snake_case` for filenames
- **File organization**: `lua/Barmanji/<category>/<feature>.lua`
  - Example: `lazy/lsp.lua`, `lazy/treesitter.lua`
- **Keymap names**: Descriptive, prefix with mode (e.g., `n_`, `v_`, `i_`)

#### Imports and Requires

```lua
-- Always use local references for performance
local keymap = vim.keymap.set
local fn = vim.fn
local opt = vim.opt
local cmd = vim.cmd

-- Group requires together at top of file
local lspconfig = require 'lspconfig'
local null_ls = require 'null-ls'
```

#### Formatting

- 2 spaces indentation (no tabs)
- Max line length: 100 characters (soft)
- Trailing commas in tables
- Use `vim.tbl_extend` or `vim.tbl_deep_extend` for merging configs
- Prefer early returns to reduce nesting

```lua
-- Good
if not has_plugin('some-plugin') then
  return
end

-- Avoid
if has_plugin('some-plugin') then
  -- nested code
end
```

#### Options and Settings

```lua
-- Use vim.opt for options
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true

-- Use vim.g for global variables
vim.g.mapleader = ' '

-- Use vim.cmd for commands
vim.cmd 'highlight! link CursorLine Normal'
```

#### Keybinding Definitions

```lua
-- Group by mode with clear comments
-- Normal mode
keymap('n', '<leader>ff', ':Telescope find_files<CR>', { desc = 'Find files' })
keymap('n', '<leader>fg', ':Telescope live_grep<CR>', { desc = 'Grep files' })

-- Insert mode
keymap('i', 'jj', '<Esc>', { desc = 'Exit insert mode' })

-- Visual mode
keymap('v', '<', '<gv', { desc = 'Indent left' })
keymap('v', '>', '>gv', { desc = 'Indent right' })
```

Always include `desc` option for keymaps to enable which-key integration.

#### LSP Configuration

```lua
-- Always pass capabilities to LSP servers
lspconfig.tsserver.setup {
  capabilities = capabilities,
  on_attach = on_attach,
  -- Settings
}

-- Capabilities should be built from basic to extended
local capabilities = vim.tbl_deep_extend(
  'force',
  {},
  vim.lsp.protocol.make_client_capabilities(),
  require('cmp_nvim_lsp').default_capabilities()
)
```

#### Plugin Configuration

```lua
-- Use lazy.nvim plugin spec format
return {
  'neovim/nvim-lspconfig',
  dependencies = { 'williamboman/mason.nvim' },
  config = function()
    -- Configuration
  end,
}
```

#### Error Handling

```lua
-- Validate plugin availability before using
local ok, module = pcall(require, 'some-module')
if not ok then
  vim.notify('Module not found: some-module', vim.log.levels.ERROR)
  return
end

-- Use pcall for unsafe operations
local success, result = pcall(some_function, args)
if not success then
  vim.notify('Error: ' .. result, vim.log.levels.ERROR)
end
```

### Shell Scripts

- Use `#!/usr/bin/env bash` or `#!/usr/bin/env zsh`
- Always quote variables: `"$variable"` not `$variable`
- Use `set -euo pipefail` for strict error handling
- Functions: `function_name()` not `function function_name`

### Configuration Files (Hyprland, Waybar, etc.)

- Follow each tool's native syntax
- Use comments to explain non-obvious settings
- Group related settings together
- Keep files reasonably sized (< 300 lines each)

---

## Repository Structure

```
dotfiles/
├── nvim/.config/nvim/     # Neovim config (main code)
├── scripts/               # Shell scripts
├── hypr/                  # Hyprland config
├── ghostty/               # Ghostty config
├── kitty/                 # Kitty config
├── waybar/                # Waybar config
├── tmux/                  # Tmux config
└── ...
```

---

## Common Tasks

### Adding a New Plugin

1. Add plugin to `lazy_init.lua` or relevant lazy config file
2. Create config file in `lua/Barmanji/lazy/`
3. Follow LSP/keymap conventions above

### Modifying Keybindings

1. Find the relevant file in `lua/Barmanji/`
2. Add/update keymap with `desc` option
3. Test with `:map` command in Neovim

### Adding LSP Server

1. Edit `lua/Barmanji/lazy/lsp.lua`
2. Add server config following pattern in file
3. Ensure capabilities are passed correctly

---

## Notes

- This is a personal dotfiles repository - prioritize clarity and maintainability
- Changes should work across systems where possible
- Test changes in isolated environment before committing
- Keep Neovim startup time reasonable (< 200ms)