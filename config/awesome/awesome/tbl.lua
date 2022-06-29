-- Functions that deal with tables.

local tbl = {}

-- Do something for everything in the table.
---@param this_table table
---@param callback function
function tbl.foreach(this_table, callback)
    for _, v in pairs (this_table) do
        callback(v)
    end
end

-- Map elements to a new table.
---@param this_table table
---@param transform function
---@return table
function tbl.map(this_table, transform)
    local new_tbl = {}
    for i, v in pairs (this_table) do
        new_tbl[i] = transform(v)
    end
    return new_tbl
end

-- Return whether a key is in the table or not
---@param key any
---@param this_tbl table
---@return number index Where the value is
function tbl.has(key, this_tbl)
    for i, v in pairs (this_tbl) do
        if v == key then
            return i
        end
    end
end

return tbl

-- vim: filetype=lua:expandtab:shiftwidth=4:tabstop=8:softtabstop=4:textwidth=80