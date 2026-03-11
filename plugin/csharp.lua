if not nixCats("csharp") or not nixCats("dev") then
   return
end

vim.lsp.config('roslyn_ls', {
   on_attach = function(bufnr, client_id)
      vim.keymap.set("n", "<C-e>c", function()
         local user_input = vim.fn.input({ prompt = "Enter input: ", completion = "dir_in_path" })
         vim.api.nvim_cmd({ cmd = "te", args = { "dotnet run --project " .. user_input } }, {})
      end, bufnr)
   end
})

--- configure nix grammar for treesitter
vim.cmd.packadd("nvim-treesitter-grammar-c_sharp")
local grammar_path = nixCats.pawsible('allPlugins.opt.nvim-treesitter-grammar-c_sharp')
vim.treesitter.language.add('c_sharp', { path = grammar_path .. '/parser/c_sharp.so' })
vim.treesitter.language.register('c_sharp', { 'cs' })

vim.lsp.enable('roslyn_ls')
