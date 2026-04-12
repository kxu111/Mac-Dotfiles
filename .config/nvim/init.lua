local map = vim.keymap.set
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

require("functions").add_pkg({
	{ src = "catppuccin/nvim", name = "catppuccin" },
	{ src = "vague-theme/vague.nvim" },
	{ src = "neovim/nvim-lspconfig" },
	{ src = "mason-org/mason.nvim" },
	{ src = "mason-org/mason-lspconfig.nvim" },
	{ src = "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "nvim-treesitter/nvim-treesitter" },
	{ src = "nvim-mini/mini.nvim" },
	{ src = "stevearc/oil.nvim" },
	{ src = "nvim-lualine/lualine.nvim" },
	{ src = "nvim-lua/plenary.nvim" },
	{ src = "nvim-telescope/telescope.nvim" },
	{ src = "Saghen/blink.cmp", version = "v1.10.2" },
	{ src = "stevearc/conform.nvim" },
	{ src = "folke/flash.nvim" },
	{ src = "akinsho/toggleterm.nvim" },
	{ src = "rachartier/tiny-inline-diagnostic.nvim" },
	{ src = "chentoast/marks.nvim" },
	{ src = "nvim-orgmode/orgmode" },
	{ src = "nvim-orgmode/telescope-orgmode.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({ ensure_installed = mason_pkgs, auto_update = true })
require("nvim-treesitter").install(ts_parsers)

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
require("mini.git").setup()
require("mini.diff").setup()
require("mini.pairs").setup({
	mappings = {
		["<"] = { action = "open", pair = "<>", neigh_pattern = "^[^\\]" },
		[">"] = { action = "close", pair = "<>", neigh_pattern = "^[^\\]" },
	},
})
require("mini.surround").setup()
require("mini.clue").setup({
	triggers = { { mode = { "n", "v" }, keys = "<Leader>" } },
	window = { delay = 150 },
})
require("mini.ai").setup()
require("mini.splitjoin").setup()
require("mini.comment").setup()
require("mini.cmdline").setup()

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
map("n", "-", "<Cmd>Oil<CR>")

require("lualine").setup({ ---@diagnostic disable-line: undefined-field
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

require("telescope").setup({
	defaults = {
		preview = { treesitter = true },
		sorting_strategy = "ascending",
		path_displays = { "smart" },
		borderchars = { "", "", "", "", "", "", "", "" },
		layout_config = {
			height = 100,
			width = 400,
			prompt_position = "top",
			preview_cutoff = 40,
		},
	},
})
require("telescope").load_extension("orgmode")

local builtin = require("telescope.builtin")
local org = require("telescope").extensions.orgmode
map("n", "<Leader>f", "", { desc = "Telescope" })
map("n", "<Leader>ff", builtin.find_files, { desc = "Files" })
map("n", "<Leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<Leader>fg", builtin.live_grep, { desc = "Grep" })
map("n", "<Leader>fh", builtin.help_tags, { desc = "Help" })
map("n", "<Leader>fd", builtin.diagnostics, { desc = "Diagnostics" })

require("blink.cmp").setup({
	sources = {
		per_filetype = {
			org = { "orgmode" },
		},
		providers = {
			orgmode = {
				name = "Orgmode",
				module = "orgmode.org.autocompletion.blink",
				fallbacks = { "buffer" },
			},
		},
	},
})

require("conform").setup({ formatters_by_ft = formatters })
map("n", "<Leader>l", "", { desc = "Conform" })
map("n", "<Leader>lf", require("conform").format, { desc = "Format" })

require("flash").setup({ char = { enabled = true, jump_labels = true } })
map({ "n", "v", "o" }, "<Leader>s", require("flash").jump, { desc = "Flash jump" })
map({ "n", "v", "o" }, "<Leader>S", require("flash").treesitter_search, { desc = "Flash treesitter" })
map({ "n", "v", "o" }, "<Leader>r", require("flash").remote, { desc = "Flash remote" })

vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block" -- disable cursor blink
require("toggleterm").setup({ open_mapping = [[<c-\>]], direction = "float" })

require("tiny-inline-diagnostic").setup({ preset = "minimal" })

require("marks").setup()

vim.cmd.packadd({ "nvim.undotree" })
map("n", "<Leader>u", "<Cmd>Undotree<CR>", { desc = "Toggle undotree" })

require("orgmode").setup({})

---------------
--- KEYMAPS ---
---------------
map("n", "<Leader>q", "<Cmd>quit<CR>", { desc = "Quit the buffer" })
map("n", "<Leader>s", "<Cmd>update<CR><Cmd>source<CR>", { desc = "Source the buffer" })
map("n", "<Leader>w", "<Cmd>update<CR>", { desc = "Write the buffer" })
map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to clipboard" })
map({ "n", "v" }, "<Leader>d", '"+d', { desc = "Delete to clipboard" })
map({ "n", "v" }, "<Leader>c", "zz", { desc = "Centre the screen" })
map({ "n", "v" }, "<Leader>n", ":norm ", { desc = "<Cmd>norm" })
map("n", "<Leader>p", "", { desc = "Pack" })
map("n", "<Leader>pc", require("functions").pack_clean, { desc = "Clean plugins" })

-- Splits navigation
map("n", "vs", "<Cmd>vertical split<CR>")
map("n", "sv", "<Cmd>split<CR>")
map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

-- Tabs navigation
map("n", "<C-t>", "<C-w>T")
for i = 1, 5 do
	map("n", "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end

-- Filler maps (for mini.clue)
map("n", "<Leader>o", "", { desc = "org" })

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
	on_highlights = function(hl, c)
		-- available options: fg, bg, gui, sp
		hl.BlinkCmpMenu = { bg = c.bg }
		hl.BlinkCmpKind = { bg = c.bg }
	end,
})

vim.cmd("colorscheme vague")

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		require("functions").ts_clean(ts_parsers)
		vim.cmd("TSUpdate")
		vim.cmd("MasonToolsClean")
	end,
})
