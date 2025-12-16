--[[
=====================================================================
                          AERIAL
=====================================================================
Навигация по структуре файла (outline).

Возможности:
  - Показывает функции, классы, переменные
  - Быстрый переход между элементами
  - Поддержка всех основных языков

Горячие клавиши:
  <leader>a   - открыть/закрыть outline
  g?          - справка в окне outline

GitHub: https://github.com/stevearc/aerial.nvim
=====================================================================
--]]

return {
  "stevearc/aerial.nvim",
  event = "VeryLazy",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-tree/nvim-web-devicons",
  },
  
  opts = {
    layout = {
      max_width = 40,
      width = 30,
      min_width = 20,
      default_direction = "right",
    },
    
    show_guides = true,
    
    filter_kind = {
      "Class",
      "Constructor",
      "Enum",
      "Function",
      "Interface",
      "Module",
      "Method",
      "Struct",
      "Variable",
    },
  },
  
  keys = {
    { "<leader>a", "<cmd>AerialToggle!<cr>", desc = "Структура файла" },
  },
}
