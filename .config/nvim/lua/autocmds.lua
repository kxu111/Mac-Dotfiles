vim.api.nvim_create_autocmd("PackChanged", {
	callback = function(ev)
		local name, kind = ev.data.spec.name, ev.data.kind
		if name == "nvim-treesitter" and kind == "update" then
			vim.cmd("TSUpdate")
		end
		if name == "blink.cmp" and kind == "install" or kind == "update" then
			vim.cmd("BlinkCmp build")
		end
		if name == "telescope-fzf-native.nvim" and kind == "install" or kind == "update" then
			vim.system({ "make" }, { vim.fn.stdpath("data") .. "/site/pack/core/opt/telescope-fzf-native.nvim" })
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	group = vim.api.nvim_create_augroup("highlight-yank", { clear = true }),
	callback = function()
		vim.hl.on_yank()
	end,
})
