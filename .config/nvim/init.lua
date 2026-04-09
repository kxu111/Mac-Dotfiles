local keymap = vim.keymap.set
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

local mason_pkgs = {
	"tree-sitter-cli",
	"lua_ls",
	"stylua",
	"nil",
	"alejandra",
	"clangd",
	"clang-format",
	"rust-analyzer",
}
local ts_parsers = {
	"lua",
	"markdown",
	"markdown_inline",
	"rust",
	"c",
	"cpp",
	"nix",
}
local formatters = {
	lua = { "stylua" },
	nix = { "alejandra" },
	c = { "clang-format" },
	cpp = { "clang-format" },
	rs = { "rustfmt" },
}

vim.pack.add({
	{ src = "https://github.com/catppuccin/nvim", name = "catppuccin" },
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/nvim-lualine/lualine.nvim" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/folke/trouble.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/catgoose/nvim-colorizer.lua" },
	{ src = "https://github.com/kawre/neotab.nvim" },
	{ src = "https://github.com/rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "https://github.com/chentoast/marks.nvim" },
})

require("nvim-treesitter").install(ts_parsers)
require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = mason_pkgs,
	auto_update = true,
})

require("flash").setup({
	char = {
		enabled = true,
		jump_labels = true,
	},
})
keymap({ "n", "v", "o" }, "<leader>s", require("flash").jump)
keymap({ "n", "v", "o" }, "<leader>S", require("flash").treesitter_search)
keymap({ "n", "v", "o" }, "<leader>r", require("flash").remote)

require("conform").setup({ formatters_by_ft = formatters })
keymap("n", "<leader>lf", require("conform").format)

require("tiny-inline-diagnostic").setup({ preset = "minimal" })
require("marks").setup()

require("toggleterm").setup({
	open_mapping = [[<c-\>]],
	direction = "float",
})

-- for some reason without this line it says "undefined field: setup"
---@diagnostic disable-next-line: undefined-field
require("lualine").setup({
	options = { icons_enabled = true },
	sections = {
		lualine_a = { "mode" },
		lualine_b = { "diagnostics" },
		lualine_c = { "filename" },
		lualine_x = { "lsp_status" },
		lualine_y = {},
		lualine_z = { "location" },
	},
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
keymap("n", "<leader>e", ":Oil<CR>")

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
MiniIcons.tweak_lsp_kind()
require("mini.pairs").setup({
	mappings = {
		["<"] = { action = "open", pair = "<>", neigh_pattern = "^[^\\]" },
		[">"] = { action = "close", pair = "<>", neigh_pattern = "^[^\\]" },
	},
})
require("mini.surround").setup()
require("mini.ai").setup()
require("mini.completion").setup({
	scroll_up = "<C-n>",
	scroll_down = "<C-p>",
})
require("mini.comment").setup()
require("mini.cmdline").setup()
require("mini.splitjoin").setup()
require("mini.pick").setup()
keymap("n", "<leader>f", ":Pick files<CR>")
keymap("n", "<leader>g", ":Pick grep_live<CR>")
keymap("n", "<leader>h", ":Pick help<CR>")

require("trouble").setup()
keymap("n", "<leader>t", ":Trouble diagnostics toggle<CR>")

require("colorizer").setup({
	options = {
		parsers = {
			names = { enable = false },
		},
	},
})
require("neotab").setup({})

vim.cmd.packadd({ "nvim.undotree" })
keymap({ "n", "v" }, "<leader>u", ":Undotree<CR>")

require("catppuccin").setup({
	no_bold = true,
	flavour = "mocha",
	color_overrides = {
		mocha = {
			base = "#000000",
			mantle = "#000000",
			crust = "#000000",
		},
	},
})

require("vague").setup({
	bold = false,
	colors = {
		bg = "#000000",
		inactiveBg = "#000000",
	},
})

keymap("n", "<leader>q", ":quit<CR>")
keymap("n", "<leader>o", ":update<CR>:source<CR>")
keymap("n", "<leader>w", ":write<CR>")
keymap({ "n", "v" }, "<leader>y", '"+y<CR>')
keymap({ "n", "v" }, "<leader>d", '"+d<CR>')
keymap({ "n", "v" }, "<leader>c", "zz")

-- Splits navigation
keymap("n", "vs", ":vertical split<CR>")
keymap("n", "sv", ":split<CR>")
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

vim.cmd("colorscheme vague")

-----------------
--- FUNCTIONS ---
-----------------
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

	print("Removing...")
	vim.pack.del(unused_plugins)
	print("Removed unused plugins")
end
keymap("n", "<leader>pc", pack_clean)

local function ts_clean()
	local ts_dir = vim.fn.stdpath("data") .. "/site/parser"
	local desired = {}
	local installed = {}

	for _, p in ipairs(ts_parsers) do
		desired[p] = true
	end

	for file in vim.fs.dir(ts_dir) do
		if file:match("%.so$") then
			local parser = file:gsub("%.so$", "")
			installed[parser] = true
		end
	end

	for parser, _ in pairs(installed) do
		if not desired[parser] then
			vim.cmd("TSUninstall " .. parser)
		end
	end
end

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		ts_clean()
		vim.cmd("TSUpdate")
		vim.cmd("MasonToolsClean")
	end,
})
