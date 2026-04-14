local M = {}

function M.add_pkg(opts)
	for _, plugin in ipairs(opts) do
		if type(plugin) == "string" then -- WARNING: untested code!
			plugin = { src = plugin }
		end
		local src = plugin.src

		if src and type(src) == "string" and not src:match("^https?://") then
			src = "https://github.com/" .. src
			plugin.src = src
		end
	end
	vim.pack.add(opts)
end

function M.pack_clean()
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

function M.ts_clean(ts_parsers)
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

-- THE FOLLOWING CODE IS FROM https://github.com/nvim-mini/mini.nvim/discussions/2173
local widths = { 60, 20, 10 }
function M.ensure_center_layout(ev)
	local state = MiniFiles.get_explorer_state()
	if state == nil then
		return
	end

	-- Compute "depth offset" - how many windows are between this and focused
	local path_this = vim.api.nvim_buf_get_name(ev.data.buf_id):match("^minifiles://%d+/(.*)$")
	local depth_this
	for i, path in ipairs(state.branch) do
		if path == path_this then
			depth_this = i
		end
	end
	if depth_this == nil then
		return
	end
	local depth_offset = depth_this - state.depth_focus

	-- Adjust config of this event's window
	local i = math.abs(depth_offset) + 1
	local win_config = vim.api.nvim_win_get_config(ev.data.win_id)
	win_config.width = i <= #widths and widths[i] or widths[#widths]

	win_config.col = math.floor(0.5 * (vim.o.columns - widths[1]))
	for j = 1, math.abs(depth_offset) do
		local sign = depth_offset == 0 and 0 or (depth_offset > 0 and 1 or -1)
		-- widths[j+1] for the negative case because we don't want to add the center window's width
		local prev_win_width = (sign == -1 and widths[j + 1]) or widths[j] or widths[#widths]
		-- Add an extra +2 each step to account for the border width
		win_config.col = win_config.col + sign * (prev_win_width + 2)
	end

	win_config.height = depth_offset == 0 and 25 or 20
	win_config.row = math.floor(0.5 * (vim.o.lines - win_config.height))
	win_config.border = { "🭽", "▔", "🭾", "▕", "🭿", "▁", "🭼", "▏" }
	vim.api.nvim_win_set_config(ev.data.win_id, win_config)
end

-- TAKEN FROM https://www.reddit.com/r/neovim/comments/1q2vwvz/macos_quick_look_with_minifiles/
function M.qpreview()
	local path = (MiniFiles.get_fs_entry() or {}).path
	if path == nil then
		return vim.notify("Cursor is not on valid entry")
	end
	vim.system({ "qlmanage", "-p", path }, {}, function(result)
		if result.code ~= 0 then
			vim.notify("'qlmanage -p' failed with code: " .. result.code)
			vim.notify("Stderr:\n" .. result.stderr)
		end
	end)
end

return M
