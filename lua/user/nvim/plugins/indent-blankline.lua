--[[
=====================================================================
                      INDENT-BLANKLINE
=====================================================================
Визуальные линии отступов для лучшей видимости структуры кода.

Возможности:
  - Показывает линии отступов
  - Подсвечивает текущий уровень отступа
  - Работает со всеми языками программирования

GitHub: https://github.com/lukas-reineke/indent-blankline.nvim
=====================================================================
--]]

return {
  "lukas-reineke/indent-blankline.nvim",
  event = { "BufReadPost", "BufNewFile" },
  main = "ibl",
  
  opts = {
    indent = {
      char = "│",
      tab_char = "│",
    },
    
    scope = {
      enabled = true,
      char = "│",
      show_start = true,
      show_end = true,
    },
    
    exclude = {
      filetypes = {
        "help",
        "alpha",
        "dashboard",
        "neo-tree",
        "Trouble",
        "lazy",
        "mason",
        "notify",
        "toggleterm",
        "lazyterm",
      },
    },
  },
}
