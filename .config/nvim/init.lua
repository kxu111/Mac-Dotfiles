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

local lsp_servers =
	{ "lua_ls", "stylua", "nil", "alejandra", "clangd", "clang-format", "pyright", "black", "rust-analyzer" }
local formatters = {
	lua = { "stylua" },
	nix = { "alejandra" },
	c = { "clang-format" },
	py = { "black" },
	rs = { "rustfmt" },
}

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
	{ src = "https://github.com/numToStr/Comment.nvim" },
	{ src = "https://github.com/mluders/comfy-line-numbers.nvim" },
})

vim.cmd.packadd("nvim.undotree")
vim.keymap.set({ "n", "v", "x" }, "<leader>u", ":Undotree<CR>")

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = lsp_servers,
	auto_update = true,
})
vim.lsp.config("lua_ls", {
	settings = { Lua = { workspace = { library = vim.api.nvim_get_runtime_file("", true) } } },
})

require("flash").setup({
	char = {
		enabled = true,
		jump_labels = true,
	},
})
vim.keymap.set({ "n", "x", "o" }, "<leader>s", require("flash").jump)

require("conform").setup({
	formatters_by_ft = formatters,
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})

---@diagnostic disable-next-line: undefined-field -- for some reason without this line it says "undefined field: setup"
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

require("toggleterm").setup({
	open_mapping = [[<c-\>]],
	direction = "float",
})

require("nvim-web-devicons").setup({
	color_icons = true,
	variant = "dark",
})

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

require("mini.pairs").setup()
require("mini.surround").setup()
require("mini.pick").setup()
vim.keymap.set("n", "<leader>f", ":Pick files<CR>")
vim.keymap.set("n", "<leader>h", ":Pick help<CR>")
vim.keymap.set("n", "<leader>g", ":Pick grep_live<CR>")

require("blink.cmp").setup({
	fuzzy = { implementation = "prefer_rust_with_warning" },
})

require("trouble").setup()
vim.keymap.set("n", "<leader>t", ":Trouble diagnostics toggle<CR>")

require("colorizer").setup({
	options = {
		parsers = {
			names = { enable = false },
		},
	},
})
require("Comment").setup()
require("comfy-line-numbers").setup()

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

vim.keymap.set({ "n", "v", "x" }, "<leader>q", ":quit<CR>")
vim.keymap.set("n", "<leader>o", ":update<CR>:source<CR>")
vim.keymap.set("n", "<leader>w", ":write<CR>")
vim.keymap.set({ "n", "v", "x" }, "<leader>y", '"+y<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>d", '"+d<CR>')
vim.keymap.set({ "n", "v", "x" }, "<leader>c", "zz")
