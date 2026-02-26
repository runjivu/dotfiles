return {
    "tpope/vim-fugitive",
    config = function()
        vim.keymap.set('n', '<leader>gs', vim.cmd.Git)
        vim.keymap.set("n", "gu", "<cmd>diffget //2<CR>")
        vim.keymap.set("n", "gh", "<cmd>diffget //3<CR>")
        
        -- Override P key in fugitive summary buffer to use pull --rebase && push
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'fugitive',
            callback = function()
                vim.keymap.set('n', 'p', ':Git pushup<CR>', { buffer = true })
            end,
        })
    end
}
