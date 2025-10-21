if not nixCats("org") or not nixCats("dev") then
   return
end

-- configure nix grammar for treesitter
vim.cmd.packadd("vimplugin-treesitter-grammar-org")

-- use nixCats utility function to get grammars install location in the nix store
local grammar_path = nixCats.pawsible('allPlugins.opt.vimplugin-treesitter-grammar-org')

-- configure neovim's native treesitter functionality
 im.treesitter.language.add('org', { path = grammar_path .. '/parser/org.so' })
vim.treesitter.language.register('org', { 'org' })

