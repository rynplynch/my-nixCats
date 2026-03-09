-- only execute if our build enabled the lua and dev-tool categories
if not nixCats("lua") or not nixCats("dev") then
   return
end

-- this ammends the default nvim-lspconfig configurations
-- vim.lsp.config will search the /lsp directory, finding the file name 'lua_ls'
vim.lsp.config('lua_ls', {
   on_init = function(client)
      if client.workspace_folders then
         local path = client.workspace_folders[1].name
         if
             path ~= vim.fn.stdpath('config')
             and (vim.uv.fs_stat(path .. '/.luarc.json') or vim.uv.fs_stat(path .. '/.luarc.jsonc'))
         then
            return
         end
      end

      client.config.settings.Lua = vim.tbl_deep_extend('force', client.config.settings.Lua, {
         runtime = {
            -- Tell the language server which version of Lua you're using (most
            -- likely LuaJIT in the case of Neovim)
            version = 'LuaJIT',
            -- Tell the language server how to find Lua modules same way as Neovim
            -- (see `:h lua-module-load`)
            path = {
               'lua/?.lua',
               'lua/?/init.lua',
            },
         },
         -- Make the server aware of Neovim runtime files
         workspace = {
            checkThirdParty = true,
            library = {
               vim.env.VIMRUNTIME,
            },
         },
      })
   end,
   settings = {
      Lua = {
         runtime = {
            version = 'LuaJIT',
         },
         diagnostics = {
            globals = { "nixCats" }
         },
      }
   }
})


vim.lsp.enable('lua_ls')

-- if lua is enable, configure debugger
if nixCats("debug") then
   local dap = require("dap")
   dap.configurations.lua = {
      {
         type = 'nlua',
         request = 'attach',
         name = "Attach to running Neovim instance",
      }
   }

   dap.adapters.nlua = function(callback, config)
      callback({ type = 'server', host = config.host or "127.0.0.1", port = config.port or 8086 })
   end

   vim.keymap.set('n', '<leader>dl', function()
      require "osv".launch({ port = 8086 })
   end, { noremap = true })

   vim.keymap.set('n', '<leader>dw', function()
      local widgets = require "dap.ui.widgets"
      widgets.hover()
   end)

   vim.keymap.set('n', '<leader>df', function()
      local widgets = require "dap.ui.widgets"
      widgets.centered_float(widgets.frames)
   end)
end
