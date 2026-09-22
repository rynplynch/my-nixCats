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
         -- Every time we write the buffer
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
         print("completion enabled")
         vim.lsp.completion.enable(true, client.id, args.buf, {
            autotrigger = true,
            convert = function(item)
               return { abbr = item.label:gsub('%b()', "") }
            end
         })
         -- vim.keymap.set("i", "<C-space>", vim.lsp.completion.get, { desc = "trigger autocompletion" })
      else
         print("The language server does not support completion " .. client.id)
      end
   end,
})
