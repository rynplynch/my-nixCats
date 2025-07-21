-- only execute if our build enabled the lua and dev-tool categories
if not nixCats("lua") and not nixCats("dev") then
   return
end

vim.cmd.packadd("lazydev.nvim")
require('lazydev').setup({})


require("lspconfig").lua_ls.setup {
   settings = {
      capabilities = require('blink-cmp').get_lsp_capabilities(),
      Lua = {
         diagnostics = {
            globals = { "nixCats" }
         }
      }
   }
}
