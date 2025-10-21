if not nixCats("org") or not nixCats("dev") then
   return
end

-- configure nix grammar for treesitter
vim.cmd.packadd("vimplugin-treesitter-grammar-org")

-- use nixCats utility function to get grammars install location in the nix store
local grammar_path = nixCats.pawsible('allPlugins.opt.vimplugin-treesitter-grammar-org')

