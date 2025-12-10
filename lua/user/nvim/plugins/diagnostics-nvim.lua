--[[
=====================================================================
                      DIAGNOSTICS.NVIM
=====================================================================
Красивое отображение диагностики с водяным текстом (virtual text).

Показывает ошибки и предупреждения в виде красивого текста
справа от строки кода с иконками.

GitHub: https://github.com/WhoIsSethDaniel/mason-tool-installer.nvim
=====================================================================
--]]

return {
  "folke/lsp-colors.nvim",
  event = "VeryLazy",
  
  config = function()
    -- Настраиваем красивые цвета для диагностики
    require("lsp-colors").setup({
      Error = "#db4b4b",
      Warning = "#dba000",
      Information = "#0db9d7",
      Hint = "#10b981",
    })
  end,
}
