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
	{ src = "neovim/nvim-lspconfig" },
	{ src = "mason-org/mason.nvim" },
	{ src = "mason-org/mason-lspconfig.nvim" },
	{ src = "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "nvim-treesitter/nvim-treesitter" },
	{ src = "nvim-mini/mini.nvim" },
	{ src = "stevearc/oil.nvim" },
	{ src = "stevearc/conform.nvim" },
	{ src = "folke/flash.nvim" },
	{ src = "akinsho/toggleterm.nvim" },
	{ src = "rachartier/tiny-inline-diagnostic.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	ensure_installed = mason_pkgs,
	auto_update = true,
})
require("nvim-treesitter").install(ts_parsers)

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
require("mini.splitjoin").setup()
require("mini.comment").setup()
require("mini.cmdline").setup()
require("mini.hipatterns").setup({
	highlighters = {
		fixme = { pattern = "%f[%w]()FIXME()%f[%W]", group = "MiniHipatternsFixme" },
		todo = { pattern = "%f[%w]()TODO()%f[%W]", group = "MiniHipatternsHack" },
		note = { pattern = "%f[%w]()NOTE()%f[%W]", group = "MiniHipatternsNote" },
		hex_color = require("mini.hipatterns").gen_highlighter.hex_color(),
	},
})
require("mini.completion").setup({ scroll_up = "<C-n>", scroll_down = "<C-p>" })
require("mini.statusline").setup({
	use_icons = true,
	content = {
		active = function()
			local mode, mode_hl = MiniStatusline.section_mode({ trunc_width = 120 })
			local diff = MiniStatusline.section_diff({ trunc_width = 75 })
			local diagnostics = MiniStatusline.section_diagnostics({ trunc_width = 75 })
			local filename = MiniStatusline.section_filename({ trunc_width = 140 })
			local lsp = MiniStatusline.section_lsp({ trunc_width = 75 })
			local fileinfo = MiniStatusline.section_fileinfo({ trunc_width = 999 })
			local location = MiniStatusline.section_location({ trunc_width = 75 })
			local search = MiniStatusline.section_searchcount({ trunc_width = 75 })

			return MiniStatusline.combine_groups({
				{ hl = mode_hl, strings = { mode } },
				{ hl = "MiniStatuslineDevinfo", strings = { diff, diagnostics } },
				"%<", -- Mark general truncate point
				{ hl = "MiniStatuslineFilename", strings = { filename } },
				"%=", -- End left alignment
				{ hl = "MiniStatuslineFileinfo", strings = { lsp, fileinfo } },
				{ hl = mode_hl, strings = { search, location } },
			})
		end,
	},
})
require("mini.extra").setup()
require("mini.pick").setup()
keymap("n", ",f", ":Pick files<CR>")
keymap("n", ",g", ":Pick grep_live<CR>")
keymap("n", ",h", ":Pick help<CR>")
keymap("n", ",d", ":Pick diagnostic<CR>")
keymap("n", ",t", ":Pick hipatterns<CR>")

require("oil").setup({
	default_file_explorer = true,
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, _)
			return name == ".."
		end,
	},
})
keymap("n", "<leader>e", ":Oil<CR>")

require("conform").setup({ formatters_by_ft = formatters })
keymap("n", "<leader>lf", require("conform").format)

require("flash").setup({ char = { enabled = true, jump_labels = true } })
keymap({ "n", "v", "o" }, "<leader>s", require("flash").jump)
keymap({ "n", "v", "o" }, "<leader>S", require("flash").treesitter_search)
keymap({ "n", "v", "o" }, "<leader>r", require("flash").remote)

-- disable cursor blink
vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block"
require("toggleterm").setup({ open_mapping = [[<c-\>]], direction = "" })
require("tiny-inline-diagnostic").setup({ preset = "minimal" })

vim.cmd.packadd({ "nvim.undotree" })
keymap({ "n", "v" }, "<leader>u", ":Undotree<CR>")

---------------
--- KEYMAPS ---
---------------

keymap("n", "<leader>q", ":quit<CR>")
keymap("n", "<leader>o", ":update<CR>:source<CR>")
keymap("n", "<leader>w", ":write<CR>")
keymap({ "n", "v" }, "<leader>y", '"+y')
keymap({ "n", "v" }, "<leader>d", '"+d')
keymap({ "n", "v" }, "<leader>c", "zz")
keymap({ "n", "v" }, "<leader>n", ":norm ")
keymap("n", "<leader>pc", functions.pack_clean)

-- Splits navigation
keymap("n", "vs", ":vertical split<CR>")
keymap("n", "sv", ":split<CR>")
keymap("n", "<C-h>", "<C-w>h")
keymap("n", "<C-j>", "<C-w>j")
keymap("n", "<C-k>", "<C-w>k")
keymap("n", "<C-l>", "<C-w>l")

-- Tabs navigation
keymap("n", "<C-t>", "<C-w>T")
for i = 1, 9 do
	keymap("n", "<leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>")
end

require("catppuccin").setup({
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
	colors = {
		bg = "#000000",
		inactiveBg = "#000000",
	},
})

vim.cmd("colorscheme vague")

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		functions.ts_clean(ts_parsers)
		vim.cmd("TSUpdate")
		vim.cmd("MasonToolsClean")
	end,
})
