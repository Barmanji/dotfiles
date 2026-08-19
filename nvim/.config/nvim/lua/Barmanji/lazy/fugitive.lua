return {
    "tpope/vim-fugitive",
    keys = {
        { "<leader>gs", "<cmd>Git<CR>" },
        { "gu", "<cmd>diffget //2<CR>" },
        { "gh", "<cmd>diffget //3<CR>" },
    },
    config = function()
        vim.keymap.set("n", "<leader>gs", vim.cmd.Git)

        local ThePrimeagen_Fugitive = vim.api.nvim_create_augroup("ThePrimeagen_Fugitive", {})

        local autocmd = vim.api.nvim_create_autocmd
        autocmd("BufWinEnter", {
            group = ThePrimeagen_Fugitive,
            pattern = "*",
            callback = function()
                if vim.bo.ft ~= "fugitive" then
                    return
                end

                local bufnr = vim.api.nvim_get_current_buf()
                local opts = { buffer = bufnr, remap = false }
                vim.keymap.set("n", "<leader>p", function()
                    vim.cmd.Git('push')
                end, opts)

                -- rebase always
                vim.keymap.set("n", "<leader>P", function()
                    vim.cmd.Git({ 'pull', '--rebase' })
                end, opts)

                -- NOTE: It allows me to easily set the branch i am pushing and any tracking
                -- needed if i did not set the branch up correctly
                vim.keymap.set("n", "<leader>t", ":Git push -u origin ", opts);
            end,
        })


        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
    end,
    -- {
    --     "NeogitOrg/neogit",
    --     dependencies = {
    --         "nvim-lua/plenary.nvim",  -- required
    --         "sindrets/diffview.nvim", -- optional - Diff integration
    --         -- Only one of these is needed.
    --         "nvim-telescope/telescope.nvim",
    --     },
    --     config = true,
    --     keys = {
    --         { "<leader>ng", "<cmd>Neogit<cr>", desc = "Opens Neogit" },
    --     },
    --     -- neogit keymaps
    --     vim.keymap.set("n", "<leader>gc", ":Neogit commit<CR>", { silent = true, noremap = true }),
    --     -- vim.keymap.set("n", "<leader>gbr", ":Telescope git_branches<CR>", {silent = true, noremap = true})
    -- },
    --
}
