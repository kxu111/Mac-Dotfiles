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

function M.opts(input)
	return { desc = input, noremap = true, silent = true }
end

return M
