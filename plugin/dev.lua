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
vim.keymap.set("n", "<leader>-", "<cmd>Neogit<cr>", { desc = "Launch Neogit" })

-- searching for files in project, keymaps, text in files and the help doc
vim.keymap.set("n", "<leader>sf", require("telescope.builtin").find_files)
vim.keymap.set("n", "<leader>sd", function()
   return require("telescope.builtin").find_files({ hidden = true })
end)
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

vim.cmd [[set completeopt+=menuone,noselect,popup]]
vim.o.winborder = "";


-- view markdown files with the Preview command
require("preview").setup();

-- shared configuration for all language servers
-- listen for 'LspAttach' event, execute this before server attaches
vim.api.nvim_create_autocmd('LspAttach', {
   -- creating a new group for the auto commands
   group = vim.api.nvim_create_augroup('my.lsp', {}),
   -- callback function that gets called with arguments about the starting server
   callback = function(args)
      -- get the ls client object
      local client = assert(vim.lsp.get_client_by_id(args.data.client_id))

      -- check if the language server has formatting functionality
      if client:supports_method('textDocument/formatting') then
         -- Everytime we write the buffer
         vim.api.nvim_create_autocmd('BufWritePre', {
            -- set group equal to the one we created above
            group = vim.api.nvim_create_augroup('my.lsp', { clear = false }),
            -- set buffer so we only format the current buffer
            buffer = args.buf,
            callback = function()
               -- ask the ls to format the current buffer
               vim.lsp.buf.format({ bufnr = args.buf, id = client.id, timeout_ms = 1000 })
            end,
         })
      else
         print("The language server does not support formatting " .. client.id)
      end
      if client:supports_method('textDocument/completion') then
         vim.lsp.completion.enable(true, client.id, args.buf, {
            autotrigger = true,
            convert = function(item)
               return { abbr = item.label:gsub('%b()', '') }
            end
         })
      else
         print("The language server does not support completion " .. client.id)
      end
   end,
})
