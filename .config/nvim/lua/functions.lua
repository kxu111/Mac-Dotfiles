local function add_pkg(opts)
	for _, plugin in ipairs(opts) do
		local src = plugin.src

		if src and type(src) == "string" and not src:match("^https?://") then
			src = "https://github.com/" .. src
			plugin.src = src
		end
	end
	vim.pack.add(opts)
end

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

local function ts_clean(ts_parsers)
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

return {
	add_pkg = add_pkg,
	pack_clean = pack_clean,
	ts_clean = ts_clean,
}
