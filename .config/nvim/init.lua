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

-- stylua: ignore start
local mason_pkgs = {
	"tree-sitter-cli",
	"lua_ls", "stylua",
	"nil", "alejandra",
	"clangd", "clang-format",
	"rust-analyzer",
	"pyright", "black",
	"taplo",
	"bashls", "shfmt", "shellcheck",
	"prettier",
}
local formatters = {
	lua = { "stylua" },
	nix = { "alejandra" },
	c = { "clang-format" }, cpp = { "clang-format" },
	rs = { "rustfmt" },
	py = { "black" },
	toml = { "taplo" },
	sh = { "shfmt", "shellcheck" },
	json = { "prettier" },
}
local ts_parsers = {
	"lua",
	"nix",
	"gitignore",
	"c", "cpp",
	"rust",
	"markdown", "markdown_inline",
	"python",
	"bash",
}
-- stylua: ignore end

vim.pack.add({
	{ src = "https://github.com/vague-theme/vague.nvim" },
	{ src = "https://github.com/neovim/nvim-lspconfig" },
	{ src = "https://github.com/mason-org/mason.nvim" },
	{ src = "https://github.com/mason-org/mason-lspconfig.nvim" },
	{ src = "https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter" },
	{ src = "https://github.com/nvim-treesitter/nvim-treesitter-context" },
	{ src = "https://github.com/nvim-mini/mini.nvim" },
	{ src = "https://github.com/stevearc/oil.nvim" },
	{ src = "https://github.com/stevearc/conform.nvim" },
	{ src = "https://github.com/nvim-lua/plenary.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope.nvim" },
	{ src = "https://github.com/nvim-telescope/telescope-fzf-native.nvim" },
	{ src = "https://github.com/thePrimeagen/harpoon", version = "harpoon2" },
	{ src = "https://github.com/Saghen/blink.cmp", version = "v1" },
	{ src = "https://github.com/folke/flash.nvim" },
	{ src = "https://github.com/akinsho/toggleterm.nvim" },
	{ src = "https://github.com/kawre/neotab.nvim" },
	{ src = "https://github.com/chipsenkbeil/org-roam.nvim" },
	{ src = "https://github.com/nvim-orgmode/orgmode" },
	{ src = "https://github.com/nvim-orgmode/org-bullets.nvim" },
	{ src = "https://github.com/nvim-orgmode/telescope-orgmode.nvim" },
})

require("mason").setup()
require("mason-lspconfig").setup()
require("mason-tool-installer").setup({ ensure_installed = mason_pkgs, auto_update = true })
require("nvim-treesitter").install(ts_parsers)
require("treesitter-context").setup()

require("mini.icons").setup()
MiniIcons.mock_nvim_web_devicons()
require("mini.pairs").setup({
	mappings = {
		["<"] = { action = "open", pair = "<>" },
		[">"] = { action = "close", pair = "<>" },
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
require("mini.cmdline").setup({ autocomplete = { enable = false } })
require("mini.statusline").setup()
require("mini.move").setup({
	mappings = {
		left = "H",
		right = "L",
		down = "J",
		up = "K",
	},
})

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
})
vim.keymap.set("n", "-", "<Cmd>Oil<CR>", { desc = "Open Oil" })

require("conform").setup({
	formatters_by_ft = formatters,
	format_on_save = {
		lsp_format = "fallback",
		timeout_ms = 500,
	},
})

require("telescope").setup({
	defaults = {
		preview = { treesitter = true },
		sorting_strategy = "ascending",
		path_displays = { "smart" },
		-- borderchars = { "", "", "", "", "", "", "", "" },
		layout_config = {
			width = 400,
			height = 100,
			preview_width = 0.4,
			prompt_position = "top",
			preview_cutoff = 40,
		},
	},
})
require("telescope").load_extension("fzf")
require("telescope").load_extension("orgmode")

local builtin = require("telescope.builtin")
local ext = require("telescope").extensions.orgmode
local function pick_all()
	require("telescope.builtin").find_files({ no_ignore = true })
end
vim.keymap.set("n", "<Leader>f", "", { noremap = true, silent = true, desc = "Telescope" })
vim.keymap.set("n", "<Leader>ff", builtin.find_files, { desc = "Files" })
vim.keymap.set("n", "<Leader>fa", pick_all, { desc = "ALL files" })
vim.keymap.set("n", "<Leader>fb", builtin.buffers, { desc = "Buffers" })
vim.keymap.set("n", "<Leader>fl", builtin.live_grep, { desc = "Grep" })
vim.keymap.set("n", "<Leader>fh", builtin.help_tags, { desc = "Help" })
vim.keymap.set("n", "<Leader>fm", builtin.man_pages, { desc = "Man pages" })
vim.keymap.set("n", "<Leader>fd", builtin.diagnostics, { desc = "Diagnostics" })
-- vim.keymap.set("n", "<Leader>fl", builtin.treesitter, { desc = "Treesitter search" })

vim.keymap.set("n", "<Leader>o", "", { noremap = true, silent = true, desc = "Org telescope" })
vim.keymap.set("n", "<Leader>oh", ext.search_headings, { desc = "Files & Headlines" })
vim.keymap.set("n", "<Leader>ot", ext.search_tags, { desc = "Tags" })
vim.keymap.set("n", "<Leader>or", ext.refile_heading, { desc = "Refile" })
vim.keymap.set("n", "<Leader>oi", ext.insert_link, { desc = "Insert link" })

local harpoon = require("harpoon")
harpoon:setup()
vim.keymap.set("n", "<Leader>h", "", { noremap = true, silent = true, desc = "Harpoon" })
-- stylua: ignore start
vim.keymap.set("n", "<Leader>ha", function() harpoon:list():add() end, { desc = "Add to list" })
vim.keymap.set("n", "<Leader>hr", function() harpoon:list():remove() end, { desc = "Remove from list" })
vim.keymap.set("n", "<C-e>", function() harpoon.ui:toggle_quick_menu(harpoon:list()) end)

for i =	1, 4 do
	vim.keymap.set("n", "<Leader>h" .. i, function() harpoon:list():select(i) end,
	{ desc = "Go to harpoon item " .. i })
end
-- stylua: ignore end

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
		documentation = { auto_show = true, auto_show_delay_ms = 100 },
		ghost_text = { enabled = true },
	},
	sources = {
		per_filetype = { org = { "orgmode" } },
		providers = {
			orgmode = { name = "Orgmode", module = "orgmode.org.autocompletion.blink", fallbacks = { "buffer" } },
		},
	},
})

require("flash").setup({ modes = { char = { enabled = false } } })
vim.keymap.set({ "n", "v", "o" }, "<Leader>s", require("flash").jump, { desc = "Flash jump" })
vim.keymap.set({ "n", "v", "o" }, "<Leader>S", require("flash").treesitter_search, { desc = "Flash treesitter" })
vim.keymap.set({ "n", "v", "o" }, "<Leader>r", require("flash").remote, { desc = "Flash remote" })

vim.o.guicursor = "n-v-c-sm:block,i-ci-ve:ver25,r-cr-o:hor20,t:block" -- disable cursor blink
require("toggleterm").setup({ open_mapping = [[<c-\>]], direction = "float" })

require("neotab").setup({})

vim.cmd.packadd("nvim.undotree")
vim.keymap.set("n", "<Leader>u", "<Cmd>Undotree<CR>", { desc = "Toggle undotree" })

vim.cmd.packadd("nohlsearch")
vim.keymap.set("n", "<ESC>", "<Cmd>nohlsearch<CR>", { noremap = true, silent = true })

require("orgmode").setup({
	org_agenda_files = "~/notes/**/*",
	org_default_notes_file = "~/notes/refile.org",
})
require("org-roam").setup({
	directory = "~/notes",
})
require("org-bullets").setup()
vim.lsp.enable("org")

--------------------
--- MISC KEYMAPS ---
--------------------
vim.keymap.set("n", "<Leader>q", "<Cmd>quit<CR>", { desc = "Quit the buffer" })
vim.keymap.set("n", "<Leader>Q", "<Cmd>wqa<CR>", { desc = "Write + quit all" })
vim.keymap.set("n", "<Leader>w", "<Cmd>write<CR>", { desc = "Write to the buffer" })
vim.keymap.set("n", "<Leader>z", "<Cmd>update<CR><Cmd>source<CR>", { desc = "Source the buffer" })

vim.keymap.set({ "n", "v" }, "<Leader>y", '"+y', { desc = "Copy to clipboard" })
vim.keymap.set({ "n", "v" }, "<Leader>d", '"+d', { desc = "Delete to clipboard" })

vim.keymap.set({ "n", "v" }, "<C-d>", "<C-d>zz")
vim.keymap.set({ "n", "v" }, "C-u", "<C-u>zz")

vim.keymap.set("n", "<Leader>v", "", { noremap = true, silent = true, desc = "Split" })
vim.keymap.set("n", "<Leader>vs", "<Cmd>vertical split<CR><C-w>l", { desc = "Vertical" })

vim.keymap.set("n", "<C-h>", "<C-w>h")
vim.keymap.set("n", "<C-j>", "<C-w>j")
vim.keymap.set("n", "<C-k>", "<C-w>k")
vim.keymap.set("n", "<C-l>", "<C-w>l")

vim.keymap.set("n", "<C-t>", "<C-w>T", { desc = "Open buf in new tab" })
for i = 1, 9 do
	vim.keymap.set("n", "<Leader>" .. i, "<Cmd>tabnext " .. i .. "<CR>", { desc = "Go to tab " .. i })
end

vim.keymap.set({ "n", "v" }, "<C-s>", [[:s/\V]], { desc = "Enter substitute mode in selection" })

vim.keymap.set({ "n", "v" }, "<C-c>", "zz", { desc = "Enter substitute mode in selection" })
vim.keymap.set("i", "<C-c>", "<C-o>zz", { desc = "Enter substitute mode in selection" })

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

	local choice = vim.fn.confirm("Remove unused plugins: ", "&Yes\n&No", 2)
	if choice == 1 then
		vim.pack.del(unused_plugins)
	end
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

vim.keymap.set("n", "<Leader>p", "", { noremap = true, silent = true, desc = "Clean" })
vim.keymap.set("n", "<Leader>pc", clean_all, { desc = "All" })

-------------------
--- COLORSCHEME ---
-------------------
vim.api.nvim_create_autocmd("ColorScheme", {
	pattern = "*",
	callback = function()
		local hl = vim.api.nvim_get_hl
		local bg = hl(0, { name = "Normal", link = false }).bg
		local line = hl(0, { name = "CursorLine", link = false }).bg
		local constant = hl(0, { name = "Constant", link = false }).fg
		local string_color = hl(0, { name = "String", link = false }).fg
		local comment = hl(0, { name = "Comment", link = false }).fg

		vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
		vim.api.nvim_set_hl(0, "LineNr", { fg = comment, bg = "none" })
		vim.api.nvim_set_hl(0, "SignColumn", { bg = "none" })
		vim.api.nvim_set_hl(0, "statusline", { bg = "none" })
		vim.api.nvim_set_hl(0, "TabLine", { bg = "none" })
		vim.api.nvim_set_hl(0, "MiniStatuslineFilename", { bg = "none" })

		vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })
		vim.api.nvim_set_hl(0, "FloatBorder", { bg = "none" })

		vim.defer_fn(function()
			vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = "none" })
			vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { bg = "none" })
			vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { fg = constant, bg = line })
			vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = string_color, bold = true })
			vim.api.nvim_set_hl(0, "BlinkCmpSource", { bg = bg })
			vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = bg })
			vim.api.nvim_set_hl(0, "BlinkCmpKind", { fg = comment })
		end, 200)
	end,
})
vim.cmd("colorscheme vague")

----------------
--- AUTOCMDS ---
----------------
vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
