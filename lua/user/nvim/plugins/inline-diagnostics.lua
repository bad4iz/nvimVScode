--[[
=====================================================================
                    INLINE DIAGNOSTICS
=====================================================================
Красивое отображение диагностики в виде водяного текста справа.

Показывает ошибки и предупреждения как в AstroNvim:
  - Красивые иконки
  - Цветной текст
  - Водяной стиль (virtual text)

GitHub: https://github.com/rachartier/tiny-inline-diagnostic.nvim
=====================================================================
--]]

return {
  "rachartier/tiny-inline-diagnostic.nvim",
  event = "VeryLazy",
  
  priority = 1000,
  
  opts = {
    -- Включить плагин
    enabled = true,
    
    -- Показывать диагностику при вводе
    enable_on_insert = true,
    
    -- Показывать в виртуальном тексте
    show_source = true,
    
    -- Иконки для диагностики
    signs = {
      left = "",
      right = "",
      diag = "●",
      arrow = "  ",
      up_arrow = "  ",
      vertical = " │ ",
      vertical_end = " └ ",
    },
    
    -- Форматирование сообщения
    format = nil, -- Использовать стандартный формат
    
    -- Цвета (используются из colorscheme)
    hi = {
      error = "DiagnosticError",
      warn = "DiagnosticWarn",
      info = "DiagnosticInfo",
      hint = "DiagnosticHint",
    },
    
    -- Фильтры
    options = {
      -- Показывать только первую ошибку на строке
      multilines = false,
      
      -- Показывать в insert mode
      show_on_insert_mode = true,
      
      -- Минимальная длина сообщения
      use_icons_from_diagnostic = true,
    },
  },
  
  config = function(_, opts)
    require("tiny-inline-diagnostic").setup(opts)
    
    -- Горячие клавиши для переключения
    vim.keymap.set("n", "<leader>ud", function()
      require("tiny-inline-diagnostic").toggle()
    end, { desc = "Toggle inline diagnostics" })
  end,
}
