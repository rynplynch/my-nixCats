if not nixCats("dev") then
   return
end

-- creating pairs of "" '' () {}
require('mini.pairs').setup()
-- for interacting with textobjects
require('mini.ai').setup()

-- file manipulation using a buffer interface
require("oil").setup()
vim.keymap.set("n", "-", "<cmd>Oil<CR>")

-- UI for git
vim.keymap.set("n", "<leader>-", "<cmd>LazyGit<cr>", { desc = "LazyGit" })

-- searching for files in project, keymaps, text in files and the help doc
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>sk", require("telescope.builtin").keymaps)
vim.keymap.set("n", "<leader>sg", require("telescope.builtin").live_grep)
vim.keymap.set("n", "<leader>sh", require("telescope.builtin").help_tags)

-- extending neovims builtin autocompletion
require("blink.cmp").setup({
   keymap = { preset = "default" },
   appearance = {
      nerd_font_variant = "mono",
   },
   signature = { enabled = true },
})

-- shared configuration for all language servers
vim.api.nvim_create_autocmd('LspAttach', {
   group = vim.api.nvim_create_augroup('my.lsp', {}),
   callback = function(args)
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      -- check if the language server has formatting functionality
      if client:supports_method('textDocument/formatting') then
         -- Everytime we write the buffer
         vim.api.nvim_create_autocmd('BufWritePre', {
            group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
            buffer = args.buf,
            callback = function()
               vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
            end,
         })
      else
         print("The language server does not support formatting " .. client.id)
      end
   end,
})
