-- configure nix grammar for treesitter
-- vim.cmd.packadd("nvim-treesitter-grammar-nix")
-- local grammar_path = nixCats.pawsible('allPlugins.opt.nvim-treesitter-grammar-nix')
-- vim.treesitter.language.add('nix', { path = grammar_path .. '/parser/nix.so' })
-- vim.treesitter.language.register('nix', { 'nix' })

vim.lsp.config('nil_ls', {
   -- Command and arguments to start the server.
   cmd = { 'nil' },
   -- Filetypes to automatically attach to.
   filetypes = { 'nix' },
   -- Sets the "workspace" to the directory where any of these files is found.
   -- Files that share a root directory will reuse the LSP server connection.
   -- Nested lists indicate equal priority, see |vim.lsp.Config|.
   root_markers = { { 'default.nix', 'flake.nix' }, '.git' },
   settings = {
      ['nil'] = {
         formatting = {
            -- tell nil_ls what command to use when formatting
            command = { "nixpkgs-fmt" }
         }
      }
   }
})

vim.lsp.enable('nil_ls')
