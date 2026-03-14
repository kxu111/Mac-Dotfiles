vim.o.number = true
vim.o.relativenumber = true
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "

vim.keymap.set('n', '<leader>o', ':update<CR> :source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')
vim.keymap.set('n', '<leader>cd', ':Ex<CR>')
vim.keymap.set('n', '<leader>lf', vim.lsp.buf.format) 

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
})

vim.lsp.enable("lua_ls")

require("catppuccin").setup({
	flavour = "mocha",
	color_overrides = {
		mocha = {
			base = "#000000",
			mantle = "#000000",
			crust = "#000000",
		}
	}
})
vim.cmd("colorscheme catppuccin-nvim")
