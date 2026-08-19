function ColorMyPencils(color)
    color = color or "tokyonight-moon"
    vim.cmd.colorscheme(color)

    -- Line number colors
    vim.api.nvim_set_hl(0, 'LineNrAbove', { fg = '#636DA6' })
    vim.api.nvim_set_hl(0, 'LineNrBelow', { fg = '#636DA6' })
    vim.api.nvim_set_hl(0, 'LineNr', { fg = 'white' })

    -- Transparent background
    vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
    vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

    -- Diagnostic highlights
    vim.api.nvim_set_hl(0, 'DiagnosticUnnecessary', { fg = '#808080' })
end

return {
    -- ✅ Install all themes but apply only one dynamically
    { "folke/tokyonight.nvim" },   -- Soft blues & purples
    -- { "catppuccin/nvim", name = "catppuccin" },  -- Pastel, smooth -- FIX: ISSUE VIM COMPILER
    { "rebelot/kanagawa.nvim" },  -- Japan-inspired art
    { "rmehri01/onenord.nvim" },  -- Cool nordic colors
    { "sainnhe/edge" },  -- Balanced light & dark
    { "EdenEast/nightfox.nvim" }, -- Multiple variants
    { "erikbackman/brightburn.vim" },
    { "ellisonleao/gruvbox.nvim", name = "gruvbox" },
    { "rose-pine/neovim", name = "rose-pine" },
    { "folke/tokyonight.nvim", lazy = false, priority = 1000 },

    -- ✅ Apply a default theme on startup (Tokyonight)
    {
        "folke/tokyonight.nvim",
        config = function()
            require("tokyonight").setup({
                style = "moon",
                transparent = true,
                terminal_colors = true,
                styles = {
                    comments = { italic = false },
                    keywords = { italic = false },
                    sidebars = "dark",
                    floats = "transparent",
                },
            })
            ColorMyPencils("tokyonight-moon") -- Set default theme
        end
    }
}
