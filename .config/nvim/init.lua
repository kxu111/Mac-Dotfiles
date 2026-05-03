vim.g.mapleader = " "
vim.o.number = true
vim.o.relativenumber = true
vim.o.tabstop = 4
vim.o.wrap = false
vim.o.swapfile = false
vim.o.winborder = "rounded"
vim.o.signcolumn = "yes"
vim.o.termguicolors = true
vim.o.splitright = true
vim.o.smartindent = true
vim.o.undofile = true

vim.pack.add({
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/nvim-tree/nvim-web-devicons" },
	-- { src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/ibhagwan/fzf-lua" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1" },
	{ src = "https://codeberg.org/andyg/leap.nvim" },
	-- { src = "https://github.com/kawre/neotab.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({
	auto_update = true,
	ensure_installed = {
		"tree-sitter-cli",
		"lua_ls",
		"stylua",
		"nil",
		"alejandra",
		"clangd",
		"clang-format",
		"rust-analyzer",
	},
})
local ts_parsers = {
	"lua",
	"nix",
	"c",
	"cpp",
	"rust",
}
require("nvim-treesitter").install(ts_parsers)
require("conform").setup({
	format_on_save = { lsp_format = "fallback", timeout_ms = 500 },
	formatters_by_ft = {
		lua = { "stylua" },
		nix = { "alejandra" },
		c = { "clang-format" },
		cpp = { "clang-format" },
		rs = { "rustfmt" },
	},
})

-- require("mini.icons").setup()
-- MiniIcons.mock_nvim_web_devicons()
-- require("mini.pairs").setup({
-- 	mappings = { ["<"] = { action = "open", pair = "<>" }, [">"] = { action = "close", pair = "<>" } },
-- })
-- require("mini.surround").setup({
-- 	mappings = {
-- 		add = "gsa",
-- 		delete = "gsd",
-- 		find = "gsf",
-- 		find_left = "gsF",
-- 		highlight = "gsh",
-- 		replace = "gsr",
-- 	},
-- })
-- require("mini.ai").setup()
-- require("mini.comment").setup()
-- require("mini.splitjoin").setup()
-- require("mini.move").setup({ mappings = { left = "H", right = "L", down = "J", up = "K" } })
-- require("mini.statusline").setup()
-- require("mini.clue").setup({
-- 	triggers = {
-- 		{ mode = "n", keys = "<Leader>f" },
-- 		{ mode = { "n", "v" }, keys = "gs" },
-- 	},
-- 	window = { delay = 0 },
-- })

require("fzf-lua").setup({
	defaults = { formatter = "path.dirname_first" }, -- show greyed-out directory before filename
	winopts = {
		border = "none",
		fullscreen = true,
		preview = {
			border = "rounded",
			scrollbar = false,
		},
	},
})
vim.keymap.set("n", "<Leader>f", "", { noremap = true, silent = true, desc = "Fzf" })
vim.keymap.set("n", "<Leader>ff", "<Cmd>FzfLua files<CR>", { desc = "Find files" })
vim.keymap.set("n", "<Leader>fh", "<Cmd>FzfLua helptags<CR>", { desc = "Search helptags" })
vim.keymap.set("n", "<Leader>fb", "<Cmd>FzfLua buffers<CR>", { desc = "Search buffers" })
vim.keymap.set("n", "<Leader>fl", "<Cmd>FzfLua live_grep<CR>", { desc = "Live grep" })
vim.keymap.set("n", "<Leader>ft", "<Cmd>FzfLua diagnostics_document<CR>", { desc = "Search diagnostics" })
vim.keymap.set("n", "<Leader>fd", "<Cmd>FzfLua lsp_definitions<CR>", { desc = "Find definition" })
vim.keymap.set("n", "<Leader>fv", "<Cmd>FzfLua lsp_references<CR>", { desc = "Find references" })
vim.keymap.set("n", "<Leader>fr", "<Cmd>FzfLua resume<CR>", { desc = "Resume fzf" })

require("oil").setup({
	delete_to_trash = true,
	skip_confirm_for_simple_edits = true,
	view_options = {
		show_hidden = true,
		is_always_hidden = function(name, bufnr)
			if name == ".." or name == ".DS_Store" then
				return bufnr
			end
		end,
	},
	keymaps = {
		["<C-h>"] = false,
	},
})
vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { desc = "Open Oil" })

require("blink.cmp").setup({
	completion = {
		menu = {
			scrollbar = false,
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
				},
			},
		},
		documentation = { auto_show = true, auto_show_delay_ms = 50 },
		ghost_text = { enabled = true },
	},
})

vim.keymap.set({ "n", "v", "o" }, "s", "<Plug>(leap-forward)")
vim.keymap.set({ "n", "v", "o" }, "S", "<Plug>(leap-backward)")
vim.keymap.set({ "x", "o" }, "an", function()
	require("leap.treesitter").select({
		opts = require("leap.user").with_traversal_keys("n", "N"),
	})
end)
vim.keymap.set({ "n", "x", "o" }, "R", function()
	require("leap.remote").action()
end)

-- require("neotab").setup({})

vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<Leader>u", "<Cmd>Undotree<CR>", { desc = "Toggle undotree" })

vim.cmd.packadd("nohlsearch")
vim.keymap.set("n", "<ESC>", "<Cmd>nohlsearch<CR>", { noremap = true, silent = true })

vim.cmd("filetype plugin indent on")

vim.keymap.set("n", "<Leader>q", "<Cmd>quit<CR>", { desc = "Quit the buffer" })
vim.keymap.set("n", "<Leader><C-q>", "<Cmd>qa!<CR>", { desc = "Write + quit all" })
vim.keymap.set("n", "<Leader>w", "<Cmd>write<CR>", { desc = "Write to the buffer" })
vim.keymap.set("n", "<Leader>o", "<Cmd>update<CR><Cmd>source<CR>", { desc = "Source the buffer" })

vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>d", '"+d', { desc = "Delete to clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>Y", '"+y$', { desc = "Yank to clip til end of line" })
vim.keymap.set({ "n", "v" }, "<Leader>D", '"+d$', { desc = "Delete to clip til end of line" })

vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "<C-u>", "<C-u>zz")

vim.keymap.set("n", "<Leader>v", "<Cmd>vertical split<CR>", { desc = "Vertical split" })
vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-t>", "<C-w>T", { desc = "Open buf in new tab" })
for i = 1, 9 do
	vim.keymap.set("n", "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end

vim.keymap.set({ "n", "v" }, "<C-n>", ":norm ")
vim.keymap.set({ "n", "v" }, "<C-s>", [[:s/\V]], { desc = "Enter substitute mode in selection" })

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

	vim.pack.del(unused_plugins)
end

local function ts_clean(parsers)
	local desired = {}
	local installed = {}

	for _, p in ipairs(parsers) do
		desired[p] = true
	end

	for file in vim.fs.dir(vim.fn.stdpath("data") .. "/site/parser") do
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

local function clean_all()
	pack_clean()
	ts_clean(ts_parsers)
	vim.cmd("MasonToolsClean")
end

vim.keymap.set("n", "<Leader>c", clean_all, { desc = "Clean unused pkgs" })

vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if kind ~= "install" then
			clean_all()
		end
		if name == "nvim-treesitter" and kind == "update" then
			vim.cmd("TSUpdate")
		end
		if name == "blink.cmp" and kind == "update" then
			vim.cmd("BlinkCmp build")
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank()
	end,
})

vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		vim.api.nvim_set_hl(0, "StatusLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

		vim.api.nvim_set_hl(0, "FzfLuaBorder", { link = "Comment" })

		vim.defer_fn(function()
			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "none" })
			vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "none" })
			vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", {
				fg = vim.api.nvim_get_hl(0, { name = "Constant" }).fg,
				bg = vim.api.nvim_get_hl(0, { name = "CursorLine" }).bg,
			})
			vim.api.nvim_set_hl(
				0,
				"BlinkCmpLabelMatch",
				{ fg = vim.api.nvim_get_hl(0, { name = "String" }).fg, bold = true }
			)
			vim.api.nvim_set_hl(0, "BlinkCmpSource", { link = "Normal" })
			vim.api.nvim_set_hl(0, "BlinkCmpDoc", { link = "Normal" })
			vim.api.nvim_set_hl(0, "BlinkCmpKind", { link = "Comment" })
		end, 200)
	end,
})
vim.cmd("colorscheme vague")
