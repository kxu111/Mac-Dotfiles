vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"

-- writing files keymaps
vim.keymap.set('n', '<leader>o', ':update<CR>:source<CR>')
vim.keymap.set('n', '<leader>w', ':write<CR>')
vim.keymap.set('n', '<leader>q', ':quit<CR>')

-- copy to system clipboard
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>y', '"+y<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>d', '"+d<CR>')

-- fast splits
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>vs', ':vs<CR>')
vim.keymap.set({ 'n', 'v', 'x' }, '<leader>hs', ':sv<CR>')

-- install plugins
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim",                name = "catppuccin" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

-- load plugins
require "mason".setup()

-- configure file explorer
require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, _)
			return name == '..' or name == '.git'
		end,
	},
	win_options = {
		wrap = false,
	}
})
vim.keymap.set('n', '<leader>e', ":Oil<CR>")

-- configure treesitter
require "nvim-treesitter".install({
	ensure_installed = { "python", "nix" },
	highlight = { enable = true },
})

-- fuzzy finding
require "mini.pick".setup()
vim.keymap.set('n', '<leader>f', ":Pick files<CR>")
vim.keymap.set('n', '<leader>h', ":Pick help<CR>")

-- lsp servers
vim.lsp.enable({ "lua_ls", "basedpyright", "nil", "clang" })
vim.lsp.config("lua_ls", {
	settings = {
		Lua = {
			workspace = {
				library = vim.api.nvim_get_runtime_file("", true),
			},
		}
	}
})

-- code formatters
require("conform").setup({
	formatters_by_ft = {
		json = { "prettier" },
		jsonc = { "prettier" },
		nix = { "alejandra" },
		c = { "clang-format" },
		cpp = { "clang-format" },
	},
	format_after_save = {
		async = true,
		lsp_format = "fallback",
	},
})

-- catppuccin overrides
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

-- autocomplete!
vim.api.nvim_create_autocmd('LspAttach', {
	group = vim.api.nvim_create_augroup('my.lsp', {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method('textDocument/completion') then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}; for i = 32, 126 do table.insert(chars, string.char(i)) end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.cmd [[set completeopt+=menuone,noselect,popup]]
