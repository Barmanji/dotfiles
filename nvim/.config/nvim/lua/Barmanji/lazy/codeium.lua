return {
  "Exafunction/windsurf.nvim",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "hrsh7th/nvim-cmp", -- Optional: only if you want it to play nice with nvim-cmp
  },
  config = function()
    require("codeium").setup({
      -- Explicitly disable the chat/sidebar features to keep it lightweight
      enable_chat = false,
      virtual_text = {
        enabled = true,
        key_bindings = {
          -- Cycle through suggestions if needed
          next = "<M-]>",
          prev = "<M-[>",
          -- The main accept keybind
          accept = "<Tab>",
          clear = "<C-x>",
        }
      }
    })
  end
}


