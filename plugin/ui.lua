if not nixCats("ui") then
   return
end

vim.cmd.colorscheme("onedark")

require("lualine").setup({
   options = {
      icons_enabled = false,
      theme = "onedark",
      component_separators = "|",
      section_separators = "",
   },
   sections = {
      lualine_c = {
         {
            "filename",
            path = 1,
            status = true,
         },
      },
   },
   inactive_sections = {
      lualine_b = {
         {
            "filename",
            path = 3,
            status = true,
         },
      },
      lualine_x = { "filetype" },
   },
   tabline = {
      lualine_a = { "buffers" },
      lualine_b = { "lsp_progress" },
      lualine_z = { "tabs" },
   },
})
