local functions = require("functions")
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

functions.add_pkg({
	{ src = "catppuccin/nvim", name = "catppuccin" },
	{ src = "vague-theme/vague.nvim" },
	{ src = "nvim-mini/mini.nvim" },
	{ src = "neovim/nvim-lspconfig" },
	{ src = "mason-org/mason.nvim" },
	{ src = "mason-org/mason-lspconfig.nvim" },
	{ src = "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "nvim-treesitter/nvim-treesitter" },
	{ src = "nvim-treesitter/nvim-treesitter-context" },
	{ src = "stevearc/oil.nvim" },
	{ src = "folke/flash.nvim" },
	{ src = "stevearc/conform.nvim" },
	{ src = "folke/trouble.nvim" },
	{ src = "rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "chentoast/marks.nvim" },
	{ src = "nvim-neorg/neorg" },
})

require("nvim-treesitter").install(ts_parsers)
require("treesitter-context").setup({ max_lines = 2 })
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
require("mini.git").setup()
require("mini.diff").setup()
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
require("mini.statusline").setup({
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local location = string.format("%02d:%02d", vim.fn.line("."), vim.fn.virtcol("."))
			local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { diagnostics } },
				"%<", -- Mark general truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- End left alignment
				{ hl = "MiniStatuslineFileinfo", strings = { lsp } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
	use_icons = true,
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
keymap("n", "<leader>pc", functions.pack_clean)

-- Splits navigation
keymap("n", "vs", ":vertical split<CR>")
keymap("n", "sv", ":split<CR>")
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

vim.cmd("colorscheme vague")

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		functions.ts_clean(ts_parsers)
		vim.cmd("TSUpdate")
		vim.cmd("MasonToolsClean")
	end,
})
