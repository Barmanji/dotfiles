return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    -- Recommended for `ask()` and `select()`.
    -- Required for `snacks` provider.
    ---@module 'snacks' <- Loads `snacks.nvim` types for configuration intellisense.
    -- { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  keys = {
    { "<C-a>",   function() require("opencode").ask("@this: ", { submit = true }) end, { desc = "Ask opencode…", mode = { "n", "x" } } },
    { "<C-x>",   function() require("opencode").select() end,                          { desc = "Execute opencode action…", mode = { "n", "x" } } },
    { "<C-.>",   function() require("opencode").toggle() end,                          { desc = "Toggle opencode", mode = { "n", "t" } } },
    { "go",      function() return require("opencode").operator("@this ") end,         { desc = "Add range to opencode", expr = true, mode = { "n", "x" } } },
    { "<S-C-u>", function() require("opencode").command("session.half.page.up") end,   { desc = "Scroll opencode up" } },
    { "<S-C-d>", function() require("opencode").command("session.half.page.down") end, { desc = "Scroll opencode down" } },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Your configuration, if any — see `lua/opencode/config.lua`, or "goto definition" on the type or field.
    }

    -- Required for `opts.events.reload`.
    vim.o.autoread = true
  end,
}
