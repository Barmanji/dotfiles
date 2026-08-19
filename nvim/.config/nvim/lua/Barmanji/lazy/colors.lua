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
    -- Apply a default theme on startup (Tokyonight)
    {
        "folke/tokyonight.nvim",
        lazy = false,
        priority = 1000,
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
    },

    -- Install extra themes but load them lazily (keep <leader>th picker working)
    { "rebelot/kanagawa.nvim", event = 'VeryLazy' },  -- Japan-inspired art
    { "rmehri01/onenord.nvim", event = 'VeryLazy' },  -- Cool nordic colors
    { "sainnhe/edge", event = 'VeryLazy' },  -- Balanced light & dark
    { "EdenEast/nightfox.nvim", event = 'VeryLazy' }, -- Multiple variants
    { "erikbackman/brightburn.vim", event = 'VeryLazy' },
    { "ellisonleao/gruvbox.nvim", name = "gruvbox", event = 'VeryLazy' },
    { "rose-pine/neovim", name = "rose-pine", event = 'VeryLazy' },
}