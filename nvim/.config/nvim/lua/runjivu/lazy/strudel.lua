return {
  "gruvw/strudel.nvim",
  build = "npm install",
  config = function()
    local strudel = require("strudel")
    strudel.setup({
        update_on_save = false
    })
    -- Strudel keymaps
    vim.keymap.set("n", "<leader>sl", strudel.launch, { desc = "Launch Strudel" })
    vim.keymap.set("n", "<leader>sq", strudel.quit, { desc = "Quit Strudel" })
    vim.keymap.set("n", "<leader>st", strudel.toggle, { desc = "Strudel Toggle Play/Stop" })
    vim.keymap.set("n", "<leader>su", strudel.update, { desc = "Strudel Update" })
    vim.keymap.set("n", "<leader>sb", strudel.set_buffer, { desc = "Strudel set current buffer" })
    vim.keymap.set("n", "<leader>sx", strudel.execute, { desc = "Strudel set current buffer and update" })
    -- Auto-update on save for JavaScript/Strudel files
    --vim.api.nvim_create_autocmd("BufWritePost", {
    --  pattern = "*.str",
    --  callback = function()
    --    strudel.update()
    --  end,
    --})
  end,
}
