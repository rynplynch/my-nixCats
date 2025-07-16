if not nixCats("nix") and not nixCats("dev") then
   return
end

-- configure nix grammar for treesitter
vim.cmd.packadd("vimplugin-treesitter-grammar-nix")
local grammar_path = nixCats.pawsible('allPlugins.opt.vimplugin-treesitter-grammar-nix')
vim.treesitter.language.add('nix', { path = grammar_path .. '/parser/nix.so' })
vim.treesitter.language.register('nix', { 'nix' })

require("lspconfig").nil_ls.setup {
   settings = {
      capabilities = require('blink-cmp').get_lsp_capabilities(),
      ['nil'] = {
         formatting = {
            -- tell nil_ls what command to use when formatting
            command = { "nixpkgs-fmt" }
         }
      }
   }
}
