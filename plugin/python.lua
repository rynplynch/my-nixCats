if not nixCats("python") or not nixCats("dev") then
   return
end

vim.lsp.enable('pylsp')
