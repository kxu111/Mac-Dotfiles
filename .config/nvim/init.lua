vim.o.number = true
vim.o.relativenumber = true
vim.o.signcolumn = "yes"
vim.o.wrap = false
vim.o.tabstop = 4
vim.o.swapfile = false
vim.g.mapleader = " "
vim.o.winborder = "rounded"

-- writing files keymaps
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set("n", "<leader>q", ":quit<CR>")

-- faster up + down navigation
vim.keymap.set("n", "<C-d>", "<C-d>zz") -- zz centres the page
vim.keymap.set("n", "<C-u>", "<C-u>zz")

-- copy to system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>')

-- install plugins
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/echasnovski/mini.pick" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://codeberg.org/andyg/leap.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
})

-- load lsp
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = {
		"lua_ls",
		"stylua",
		"nil_ls",
		"alejandra",
		"clangd",
		"clang-format",
	},
})
vim.lsp.config("lua_ls", {
	settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } },
})

-- set formatters
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
	},
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})

-- configure lualine
require("lualine").setup({
	options = { icons = true },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "lsp_status" },
		lualine_y = {},
		lualine_z = { "location" },
	},
})

-- setup leap
vim.keymap.set({ "n", "x", "o" }, "s", "<Plug>(leap)")

-- icons
require("nvim-web-devicons").setup({
	color_icons = true,
	variant = "dark",
})

-- configure oil
require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	columns = {
		"icon",
	},
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, _)
			return name == ".."
		end,
	},
	win_options = {
		wrap = false,
	},
})
vim.keymap.set("n", "<leader>e", ":Oil<CR>")

-- fuzzy finding
require("mini.pick").setup()
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")

-- catppuccin overrides
require("catppuccin").setup({
	flavour = "mocha",
	color_overrides = {
		mocha = {
			base = "#000000",
			mantle = "#000000",
			crust = "#000000",
		},
	},
	no_bold = true,
})
vim.cmd("colorscheme catppuccin-nvim")

-- autocomplete!
vim.api.nvim_create_autocmd("LspAttach", {
	group = vim.api.nvim_create_augroup("my.lsp", {}),
	callback = function(args)
		local client = assert(vim.lsp.get_client_by_id(args.data.client_id))
		if client:supports_method("textDocument/completion") then
			-- Optional: trigger autocompletion on EVERY keypress. May be slow!
			local chars = {}
			for i = 32, 126 do
				table.insert(chars, string.char(i))
			end
			client.server_capabilities.completionProvider.triggerCharacters = chars
			vim.lsp.completion.enable(true, client.id, args.buf, { autotrigger = true })
		end
	end,
})
vim.cmd([[set completeopt+=menuone,noselect,popup]])
