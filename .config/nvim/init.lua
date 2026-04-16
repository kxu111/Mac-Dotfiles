local map = vim.keymap.set
local functions = require("functions")
vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.cursorline = true
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
	{ src = "vague-theme/vague.nvim" },
	{ src = "neovim/nvim-lspconfig" },
	{ src = "mason-org/mason.nvim" },
	{ src = "mason-org/mason-lspconfig.nvim" },
	{ src = "WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "nvim-treesitter/nvim-treesitter" },
	{ src = "nvim-treesitter/nvim-treesitter-context" },
	{ src = "nvim-mini/mini.nvim" },
	{ src = "stevearc/oil.nvim" },
	{ src = "nvim-lua/plenary.nvim" },
	{ src = "nvim-telescope/telescope.nvim" },
	{ src = "Saghen/blink.cmp", branch = "v1" },
	{ src = "stevearc/conform.nvim" },
	{ src = "folke/flash.nvim" },
	{ src = "kawre/neotab.nvim" },
	{ src = "nvim-orgmode/orgmode" },
	{ src = "nvim-orgmode/org-bullets.nvim" },
	{ src = "nvim-orgmode/telescope-orgmode.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({ ensure_installed = mason_pkgs, auto_update = true })
require("nvim-treesitter").setup({
	ensure_installed = { ts_parsers },
	hightlight = { enable = true },
})
require("treesitter-context").setup()

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
require("mini.pairs").setup({
	mappings = {
		["<"] = { action = "open", pair = "<>", neigh_pattern = "^[^\\]" },
		[">"] = { action = "close", pair = "<>", neigh_pattern = "^[^\\]" },
	},
})
require("mini.surround").setup()
require("mini.git").setup()
require("mini.diff").setup()
require("mini.clue").setup({
	triggers = { { mode = { "n", "v" }, keys = "<Leader>" } },
	window = { delay = 150 },
})
require("mini.ai").setup()
require("mini.splitjoin").setup()
require("mini.comment").setup()
require("mini.statusline").setup()
require("mini.cmdline").setup({ autocomplete = { enable = false } })

require("oil").setup({
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, bufnr)
			if name == ".." then
				return bufnr
			end
		end,
	},
})
map("n", "<Leader>e", "<Cmd>Oil<CR>", { desc = "Open Oil" })
map("n", "-", "<Cmd>Oil<CR>", { desc = "Open Oil" })

require("telescope").setup({
	defaults = {
		preview = { treesitter = true },
		sorting_strategy = "ascending",
		path_displays = { "smart" },
		layout_config = {
			width = 400,
			height = 100,
			preview_width = 0.4,
			prompt_position = "top",
			preview_cutoff = 40,
		},
	},
})
require("telescope").load_extension("orgmode")

local builtin = require("telescope.builtin")
local ext = require("telescope").extensions.orgmode
local function pick_all()
	require("telescope.builtin").find_files({ no_ignore = true })
end
map("n", "<Leader>f", "", functions.opts("Telescope"))
map("n", "<Leader>ff", builtin.find_files, { desc = "Files" })
map("n", "<Leader>fa", pick_all, { desc = "ALL files" })
map("n", "<Leader>fb", builtin.buffers, { desc = "Buffers" })
map("n", "<Leader>fg", builtin.live_grep, { desc = "Grep" })
map("n", "<Leader>fh", builtin.help_tags, { desc = "Help" })
map("n", "<Leader>fm", builtin.man_pages, { desc = "Man pages" })
map("n", "<Leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
map("n", "<leader>oh", ext.search_headings, { desc = "Files & Headlines" })
map("n", "<leader>ot", ext.search_tags, { desc = "Tags" })
map("n", "<leader>or", ext.refile_heading, { desc = "Refile" })
map("n", "<leader>oi", ext.insert_link, { desc = "Insert link" })

require("blink.cmp").setup({
	fuzzy = {
		prebuilt_binaries = { force_version = "v*" },
	},
	completion = {
		menu = {
			draw = {
				columns = {
					{ "source_name", "label", "label_description", gap = 2 },
					{ "kind_icon", "kind", gap = 2 },
				},
				components = {
					source_name = {
						text = function(ctx)
							return "[" .. ctx.source_name .. "]"
						end,
					},
					kind_icon = {
						text = function(ctx)
							local kind_icon, _, _ = require("mini.icons").get("lsp", ctx.kind)
							return kind_icon
						end,
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
					kind = {
						highlight = function(ctx)
							local _, hl, _ = require("mini.icons").get("lsp", ctx.kind)
							return hl
						end,
					},
				},
			},
		},
		documentation = { auto_show = true, auto_show_delay_ms = 100 },
		ghost_text = { enabled = true },
	},
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
	appearance = { use_nvim_cmp_as_default = true },
})

require("conform").setup({ formatters_by_ft = formatters })
map("n", "<Leader>l", "", functions.opts("Conform"))
map("n", "<Leader>lf", require("conform").format, { desc = "Format" })

require("flash").setup({ modes = { char = { enabled = false } } })
map({ "n", "v", "o" }, "<Leader>s", require("flash").jump, { desc = "Flash jump" })
map({ "n", "v", "o" }, "<Leader>S", require("flash").treesitter_search, { desc = "Flash treesitter" })
map({ "n", "v", "o" }, "<Leader>r", require("flash").remote, { desc = "Flash remote" })

require("neotab").setup({})

vim.cmd.packadd({ "nvim.undotree" })
map("n", "<Leader>u", "<Cmd>Undotree<CR>", { desc = "Toggle undotree" })

require("orgmode").setup({
	org_agenda_files = "~/orgfiles/**/*",
	org_default_notes_file = "~/orgfiles/refile.org",
})
vim.lsp.enable("org")
require("org-bullets").setup()
map("n", "<Leader>o", "", functions.opts("Org"))

---------------
--- KEYMAPS ---
---------------
map("n", "<Leader>q", "<Cmd>quit<CR>", { desc = "Quit the buffer" })
map("n", "<Leader>Q", "<Cmd>wqa<CR>", { desc = "Write + quit all" })
map("n", "<Leader>w", "<Cmd>update<CR>", { desc = "Write to the buffer" })
map("n", "<Leader>z", "<Cmd>update<CR><Cmd>source<CR>", { desc = "Source the buffer" })

map({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to clipboard" })
map({ "n", "v" }, "<Leader>d", '"+d', { desc = "Delete to clipboard" })

map({ "n", "v" }, "<C-d>", "<C-d>zz")
map({ "n", "v" }, "C-u", "<C-u>zz")

map("n", "<ESC>", "<Cmd>nohlsearch<CR>", functions.opts(""))
map({ "n", "v" }, "<Leader>n", ":norm ", { desc = "<Cmd>norm" })
map({ "n", "v" }, "<C-s>", [[:s/\V]], { desc = "Enter substitute mode in selection" })

map("n", "<Leader>p", "", functions.opts("Pack"))
map("n", "<Leader>pc", functions.pack_clean, { desc = "Clean plugins" })

map("n", "<Leader>vs", "<Cmd>vertical split<CR><C-w>l", { desc = "Vertical split" })
map("n", "<Leader>v", "", functions.opts("Vertical split"))

map("n", "<C-h>", "<C-w>h")
map("n", "<C-j>", "<C-w>j")
map("n", "<C-k>", "<C-w>k")
map("n", "<C-l>", "<C-w>l")

map("n", "<C-t>", "<C-w>T")
for i = 1, 5 do
	map("n", "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end

-- QUICKFIX MAPS
vim.keymap.set("n", "<leader>a", function()
	local filename = vim.fn.expand("%:p")
	local qf_item = { filename = filename, lnum = 1, col = 1, text = vim.fn.getline(1):sub(1, 80) }
	local qf_list = vim.fn.getqflist()
	table.insert(qf_list, qf_item)
	vim.fn.setqflist(qf_list, "r")
end, { desc = "Add file to QF list" })
map({ "n" }, "<C-q>", "<Cmd>copen<CR>", { desc = "Open QF list" })
vim.api.nvim_create_autocmd("BufWinEnter", {
	pattern = "*",
	group = vim.api.nvim_create_augroup("qf", { clear = true }),
	callback = function()
		if vim.bo.buftype == "quickfix" then
			map("n", "<C-q>", ":ccl<cr>", { buffer = true, silent = true })
			map("n", "dd", function()
				local idx = vim.fn.line(".")
				local qflist = vim.fn.getqflist()
				table.remove(qflist, idx)
				vim.fn.setqflist(qflist, "r")
			end, { buffer = true })
		end
	end,
})
for i = 1, 9 do
	map("n", "<Leader>c" .. i, ":cc " .. i .. "<CR>")
end

-------------------
--- COLORSCHEME ---
-------------------
require("vague").setup({
	on_highlights = function(hl, c)
		hl.BlinkCmpMenu = { bg = c.bg }
		hl.BlinkCmpMenuSelection = { fg = c.constant, bg = c.line }
		hl.BlinkCmpLabel = { fg = c.comment }
		hl.BlinkCmpDoc = { bg = c.bg }
	end,
})

vim.cmd("colorscheme vague")
vim.cmd("hi statusline guibg=NONE")
vim.cmd("hi TabLine guibg=NONE")

----------------
--- AUTOCMDS ---
----------------
vim.api.nvim_create_autocmd("PackChanged", {
	callback = function()
		functions.ts_clean(ts_parsers)
		vim.cmd("TSUpdate")
		vim.cmd("MasonToolsClean")
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
