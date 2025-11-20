-- only execute if our build enabled the lua and dev-tool categories
if not nixCats("lua") or not nixCats("dev") then
   return
end

vim.cmd.packadd("lazydev.nvim")
require('lazydev').setup({})

-- this ammends the default nvim-lspconfig configurations
-- vim.lsp.config will search the /lsp directory, finding the file name 'lua_ls'
vim.lsp.config['lua_ls'] = {
   settings = {
      Lua = {
         runtime = {
            version = 'LuaJIT',
         },
         diagnostics = {
            globals = { "nixCats", "vim" }
         },
         capabilities = require('blink-cmp').get_lsp_capabilities(),
      }
   }
}

vim.lsp.enable('lua_ls')
