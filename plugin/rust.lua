if not nixCats("rust") or not nixCats("dev") then
   return
end

-- configure rust grammar for treesitter
vim.cmd.packadd("nvim-treesitter-grammar-rust")
local grammar_path = nixCats.pawsible('allPlugins.opt.nvim-treesitter-grammar-rust')
vim.treesitter.language.add('rust', { path = grammar_path .. '/parser/rust.so' })
vim.treesitter.language.register('rust', { 'rs' })

vim.lsp.enable('rust_analyzer')
