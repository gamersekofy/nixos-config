-- Change leader key to space
vim.g.mapleader = ' '

vim.o.clipboard = 'unnamedplus'

vim.o.tabstop = 4
vim.o.shiftwidth = 4

vim.o.termguicolors = true

-- vim.cmd.colorscheme "catppuccin"
require("Comment").setup()

local builtin = require('telescope.builtin')
vim.keymap.set('n', '<leader> ', builtin.find_files, { desc = 'Telescope find files' })
vim.keymap.set('n', '<leader>/', builtin.live_grep, { desc = 'Telescope live grep' })
vim.keymap.set('n', '<leader>fb', builtin.buffers, { desc = 'Telescope buffers' })
vim.keymap.set('n', '<leader>fh', builtin.help_tags, { desc = 'Telescope help tags' })
