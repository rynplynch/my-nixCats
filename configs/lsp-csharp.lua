--  vim.lsp.config('roslyn_ls', {
--     on_attach = function(bufnr, client_id)
--        vim.keymap.set("n", "<C-e>c", function()
--           local user_input = vim.fn.input({ prompt = "Enter input: ", completion = "dir_in_path" })
--           vim.api.nvim_cmd({ cmd = "te", args = { "dotnet run --project " .. user_input } }, {})
--        end, bufnr)
--     end
--  })

vim.lsp.enable('roslyn_ls')
