vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.swapfile = false
vim.o.wrap = false
vim.o.signcolumn = "yes"
vim.o.winborder = "rounded"
vim.o.termguicolors = true
vim.o.undofile = true
vim.o.undodir = vim.fn.stdpath("data") .. "/undo"

local lsp_servers = { "lua_ls", "stylua", "nil", "alejandra", "clangd", "clang-format", "pyright", "black" }
local formatters = {
	lua = { "stylua" },
	nix = { "alejandra" },
	c = { "clang-format" },
	py = { "black" },
}

-- install plugins
vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/echasnovski/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/catgoose/nvim-colorizer.lua" },
})

-- undotree
vim.cmd.packadd("nvim.undotree")
vim.keymap.set({ "n", "v", "x" }, "<leader>u", ":Undotree<CR>")

require("colorizer").setup()

-- load lsp
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({ ensure_installed = lsp_servers })
vim.lsp.config("lua_ls", {
	settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } },
})

-- configure flash.nvim
require("flash").setup({
	char = {
		enabled = true,
		jump_labels = true,
	},
})
vim.keymap.set({ "n", "x", "o" }, "<leader>s", require("flash").jump)

-- setup formatter
require("conform").setup({
	formatters_by_ft = formatters,
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
require("mini.pairs").setup()
require("mini.pick").setup()
require("mini.surround").setup()
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")

-- autocomplete
require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust" },
})

-- diagnostics
require("trouble").setup()
vim.keymap.set("n", "<leader>t", ":Trouble diagnostics toggle<CR>")

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

-- centre screen
vim.keymap.set({ "n", "v", "x" }, "<leader>c", "zz")

-- quit files
vim.keymap.set({ "n", "v", "x" }, "<leader>q", ":quit<CR>")

-- write files
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")

-- copy to system clipboard
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>')
