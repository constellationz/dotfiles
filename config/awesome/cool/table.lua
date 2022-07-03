-- Courtesy of: http://lua-users.org/wiki/SaveTableToFile

local TAB = "\t"
local NEWLINE = "\n"

local function exportstring(s)
	return string.format("%q", s)
end

-- Save a table to a file.
---@param tbl table The table to safe
---@param filename string The file to save to (relative to this file)
---@return string? err Returns an error if one happened
local function save(tbl, filename)
	-- Try opening the file
	local file, err = io.open(filename, "wb")
	if err then
		return err
	end

	-- Initialize variables for save procedure
	local tables, lookup = {tbl}, {[tbl] = 1}
	file:write("return {" .. NEWLINE)

	-- Write each table to the file
	for idx, t in ipairs(tables) do
		file:write(TAB .. " -- Table " .. idx .. NEWLINE)
		file:write(TAB .. "{" .. NEWLINE)
		local handled = {}
		for i, v in ipairs(t) do
			-- Only handle value
			handled[i] = true
			local stype = type(v)
			if stype == "table" then
				if not lookup[v] then
					table.insert(tables, v)
					lookup[v] = #tables
				end
				file:write(TAB .. "{" .. lookup[v] .. "}," .. NEWLINE)
			elseif stype == "string" then
				file:write(TAB .. exportstring(v) .. "," .. NEWLINE)
			elseif stype == "number" then
				file:write(TAB .. tostring(v) .. "," .. NEWLINE)
			end
		end

		for i, v in pairs(t) do
			-- Escape handled values
			if not handled[i] then
				local str = ""
				local stype = type(i)
				-- handle index
				if stype == "table" then
					if not lookup[i] then
						table.insert(tables, i)
						lookup[i] = #tables
					end
					str = TAB .. TAB .. "[{" .. lookup[i] .. "}] = "
				elseif stype == "string" then
					str = TAB .. TAB .. "[" .. exportstring(i) .. "] = "
				elseif stype == "number" then
					str = TAB .. TAB .. "[" .. tostring(i) .. "] = "
				end

				if str ~= "" then
					-- Handle value
					stype = type(v)
					if stype == "table" then
						if not lookup[v] then
							table.insert(tables, v)
							lookup[v] = #tables
						end
						file:write(str .. "{" .. lookup[v] .. "}," .. NEWLINE)
					elseif stype == "string" then
						file:write(str .. exportstring(v) .. "," .. NEWLINE)
					elseif stype == "number" then
						file:write(str .. tostring(v) .. "," .. NEWLINE)
					end
				end
			end
		end
		file:write(TAB .. "}," .. NEWLINE)
	end
	file:write("}")
	file:close()
end

-- Load a table from a file.
---@param file string The file to load
---@return table The table that was loaded, if any.
local function load(file)
	-- Try loading the file
	local ftables, err = loadfile(file)
	if err then
		return nil
	end

	-- Read from the file
	local tables = ftables()
	for idx = 1, #tables do
		local tolinki = {}
		for i, v in pairs(tables[idx]) do
			if type(v) == "table" then tables[idx][i] = tables[v[1]] end
			if type(i) == "table" and tables[i[1]] then
				table.insert(tolinki, {i, tables[i[1]]})
			end
		end

		-- Link indices
		for _, v in ipairs(tolinki) do
			tables[idx][v[2]], tables[idx][v[1]] = tables[idx][v[1]], nil
		end
	end
	return tables[1]
end

return {
	save = save,
	load = load
}
