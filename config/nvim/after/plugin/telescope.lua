-- Telescope might not always be installed
local builtin
pcall(function()
  builtin = require('telescope.builtin')
end)
if builtin == nil then
  return
end

-- find file
vim.keymap.set('n', '<leader>ff', builtin.find_files)

-- find git file
vim.keymap.set('n', '<leader>fgf', builtin.git_files)

-- find pattern
vim.keymap.set('n', '<leader>fp', function()
	builtin.grep_string {
    search = vim.fn.input("Find pattern: ")
  }
end)
