--[[
function ColorMyPencils(color)
	color = color or "rose-pine"
	vim.cmd.colorscheme(color)
	vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
	vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
end

ColorMyPencils()
]]--
require('rose-pine').setup({

	-- Change specific vim highlight groups
	-- https://github.com/rose-pine/neovim/wiki/Recipes
	highlight_groups = {

		-- Blend colours against the "base" background
		CursorLine = { bg = 'foam', blend = 1 }
	}
})

-- Set colorscheme after options

vim.cmd('colorscheme rose-pine')
vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
