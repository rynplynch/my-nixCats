if not nixCats("org") or not nixCats("dev") then
   return
end

-- configure nix grammar for treesitter
vim.cmd.packadd("vimplugin-treesitter-grammar-org")

-- use nixCats utility function to get grammars install location in the nix store
local grammar_path = nixCats.pawsible('allPlugins.opt.vimplugin-treesitter-grammar-org')

-- configure neovim's native treesitter functionality
vim.treesitter.language.add('org', { path = grammar_path .. '/parser/org.so' })
vim.treesitter.language.register('org', { 'org' })

require('orgmode').setup({
   org_agenda_files = '~/orgfiles/**/*',
   org_default_notes_file = '~/orgfiles/refile.org',
})

require("org-roam").setup({
   directory = "~/org_roam_files",
   -- optional
   org_files = {
      '~/orgfiles/**/*'
   }
})

require('pdf-preview').setup()
