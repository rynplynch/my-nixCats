if not nixCats("ui") then
   return
end

vim.cmd.colorscheme("onedark")

require("lualine").setup({
   options = {
      theme = "onedark",
   },
   sections = {
      lualine_y = { "os.date('%a')", 'data', "require'lsp-status'.status()" },
      lualine_z = { 'os.date("!%I:%M:%S", os.time())', 'data', "require'lsp-status'.status()" }
   },
   tabline = {
      lualine_a = { "buffers" },
      lualine_b = { "lsp_progress" },
      lualine_z = { "tabs" },
   },
})
