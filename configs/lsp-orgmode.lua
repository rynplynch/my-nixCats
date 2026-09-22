require('orgmode').setup({
   org_agenda_files = { '~/orgfiles/**/*', '~/org_roam_files/daily/' },
   org_default_notes_file = '~/orgfiles/refile.org',
   win_split_mode = { 'float' }
})

vim.lsp.enable('org')

require("org-roam").setup({
   directory = "~/org_roam_files",
   -- optional
   org_files = {
      '~/orgfiles/**/*'
   }
})

require('org-bullets').setup()
