if not nixCats("debug") then
   return
end
-- NOTE: Base debugging setup
-- TODO: To run a debugger, set up or install a language specific config

require("dapui").setup()
require("nvim-dap-virtual-text").setup()
