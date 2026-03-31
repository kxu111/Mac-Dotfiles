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
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://codeberg.org/andyg/leap.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
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

-- setup formatter
require("conform").setup({
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		c = { "clang-format" },
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

-- toggleterm
require("toggleterm").setup({
	open_mapping = [[<c-\>]],
	direction = "float",
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
	columns = { "icon" },
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, _)
			return name == ".."
		end,
	},
	win_options = { wrap = false },
})
vim.keymap.set("n", "<leader>e", ":Oil<CR>")

-- mini.nvim
require("mini.pick").setup()
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")

require("mini.pairs").setup()
require("mini.surround").setup()

-- autocomplete
require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust" },
})

-- diagnostics
require("trouble").setup()
vim.keymap.set("n", "<leader>d", ":Trouble diagnostics toggle<CR>")

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

-- functions
local function pack_clean()
	local active_plugins = {}
	local unused_plugins = {}

	for _, plugin in ipairs(vim.pack.get()) do
		active_plugins[plugin.spec.name] = plugin.active
	end

	for _, plugin in ipairs(vim.pack.get()) do
		if not active_plugins[plugin.spec.name] then
			table.insert(unused_plugins, plugin.spec.name)
		end
	end

	if #unused_plugins == 0 then
		print("No unused plugins.")
		return
	end

	local choice = vim.fn.confirm("Remove unused plugins?", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
end
vim.keymap.set("n", "<leader>pc", pack_clean)
