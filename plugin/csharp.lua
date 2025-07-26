if not nixCats("csharp") or not nixCats("dev") then
   return
end

-- configure nix grammar for treesitter
vim.cmd.packadd("vimplugin-treesitter-grammar-c_sharp")
local grammar_path = nixCats.pawsible('allPlugins.opt.vimplugin-treesitter-grammar-c_sharp')
vim.treesitter.language.add('c_sharp', { path = grammar_path .. '/parser/c_sharp.so' })
vim.treesitter.language.register('c_sharp', { 'cs' })
