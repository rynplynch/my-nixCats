if not nixCats("org") or not nixCats("dev") then
   return
end

-- configure nix grammar for treesitter
vim.cmd.packadd("vimplugin-treesitter-grammar-org")

