vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- execute current file
vim.keymap.set({ "n" }, "<leader><leader>x", '<cmd>source %<CR>')
vim.keymap.set({ "n" }, "<leader>x", ':.lua<CR>')
vim.keymap.set({ "v" }, "<leader>x", ':lua<CR>')

-- Sets how neovim will display certain whitespace characters in the editor.
--  See `:help 'list'`
--  and `:help 'listchars'`
vim.opt.list = true
vim.opt.listchars = { tab = "» ", trail = "·", nbsp = "␣" }

-- enable spell check highlighting
vim.o.spell = true
vim.o.spelllang = "en_us"

-- hide links in orgmode
vim.o.conceallevel = 2
-- also hide links while cursor is over them in normal mode
vim.o.concealcursor = 'n'

-- Set highlight on search
vim.opt.hlsearch = true
vim.keymap.set("n", "<Esc>", "<cmd>nohlsearch<CR>")

-- Minimal number of screen lines to keep above and below the cursor.
vim.opt.scrolloff = 10

-- Make line numbers default
vim.wo.number = true

-- stops line wrapping from being confusing
vim.o.breakindent = true

-- Save undo history
vim.o.undofile = true

-- Case-insensitive searching UNLESS \C or capital in search
vim.o.ignorecase = true
vim.o.smartcase = true

-- Keep signcolumn on by default
vim.wo.signcolumn = "yes"
vim.wo.relativenumber = true

-- Decrease update time
vim.o.updatetime = 250
vim.o.timeoutlen = 300

-- NOTE: You should make sure your terminal supports this
vim.o.termguicolors = true

vim.g.netrw_liststyle = 0
vim.g.netrw_banner = 0

-- [[ Highlight on yank ]]
-- See `:help vim.highlight.on_yank()`
local highlight_group = vim.api.nvim_create_augroup("YankHighlight", { clear = true })
vim.api.nvim_create_autocmd("TextYankPost", {
   callback = function()
      vim.hl.on_yank()
   end,
   group = highlight_group,
   pattern = "*",
})

-- Keymaps for better default experience
-- See `:help vim.keymap.set()`
vim.keymap.set("v", "J", ":m '>+1<CR>gv=gv", { desc = "Moves Line Down" })
vim.keymap.set("v", "K", ":m '<-2<CR>gv=gv", { desc = "Moves Line Up" })
vim.keymap.set("n", "<C-d>", "<C-d>zz", { desc = "Scroll Down" })
vim.keymap.set("n", "<C-u>", "<C-u>zz", { desc = "Scroll Up" })
vim.keymap.set("n", "n", "nzzzv", { desc = "Next Search Result" })
vim.keymap.set("n", "N", "Nzzzv", { desc = "Previous Search Result" })
vim.keymap.set("n", "<leader><leader>[", "<cmd>bprev<CR>", { desc = "Previous buffer" })
vim.keymap.set("n", "<leader><leader>]", "<cmd>bnext<CR>", { desc = "Next buffer" })
vim.keymap.set("n", "<leader><leader>l", "<cmd>b#<CR>", { desc = "Last buffer" })
vim.keymap.set("n", "<leader><leader>d", "<cmd>bdelete<CR>", { desc = "delete buffer" })

-- Remap for dealing with word wrap
vim.keymap.set("n", "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true })
vim.keymap.set("n", "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true })

-- Diagnostic keymaps
vim.keymap.set("n", "<leader>e", vim.diagnostic.open_float, { desc = "Open floating diagnostic message" })
vim.keymap.set("n", "<leader>q", vim.diagnostic.setloclist, { desc = "Open diagnostics list" })

-- Sync clipboard between OS and Neovim.
-- But it constantly clobbers your system clipboard whenever you delete anything.
--  See `:help 'clipboard'`
-- vim.o.clipboard = 'unnamedplus'
-- You should instead use these keybindings to use the clipboard so that they are still easy to use, but dont conflict
vim.keymap.set({ "v", "x", "n" }, "<leader>y", '"+y', { noremap = true, silent = true, desc = "Yank to clipboard" })
vim.keymap.set(
   { "n", "v", "x" },
   "<leader>Y",
   '"+yy',
   { noremap = true, silent = true, desc = "Yank line to clipboard" }
)
vim.keymap.set({ "n", "v", "x" }, "<leader>p", '"+p', { noremap = true, silent = true, desc = "Paste from clipboard" })
vim.keymap.set(
   "i",
   "<C-p>",
   "<C-r><C-p>+",
   { noremap = true, silent = true, desc = "Paste from clipboard from within insert mode" }
)
vim.keymap.set(
   "x",
   "<leader>P",
   '"_dP',
   { noremap = true, silent = true, desc = "Paste over selection without erasing unnamed register" }
)
