require("telescope").setup({
   defaults = {
      results_title = false,
      sorting_strategy = "ascending",
      layout_strategy = "vertical",
      layout_config = {
         preview_cutoff = 1,       -- Preview should always show (unless previewer = false)
      },
   }
})

-- searching for files in project, keymaps, text in files and the help doc
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>sF", function()
   require("telescope.builtin").find_files({ cwd = '~', hidden = true })
end)
vim.keymap.set("n", "<leader>sd", function()
   return require("telescope.builtin").find_files({ hidden = true })
end)
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps)
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags)
