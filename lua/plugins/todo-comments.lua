--[[
=====================================================================
                      TODO-COMMENTS
=====================================================================
Подсветка и навигация по TODO, FIXME, HACK и другим комментариям.

Поддерживаемые ключевые слова:
  TODO:   - задачи для выполнения
  FIX:    - код требующий исправления (также FIXME, BUG, ISSUE)
  HACK:   - временное решение
  WARN:   - предупреждения (также WARNING, XXX)
  PERF:   - оптимизация производительности (также OPTIM, PERFORMANCE)
  NOTE:   - заметки (также INFO)
  TEST:   - тестовые задачи (также TESTING, PASSED, FAILED)

Горячие клавиши:
  ]t          - следующий todo
  [t          - предыдущий todo
  <leader>xt  - список всех todo (Trouble)
  <leader>xT  - todo текущего буфера

GitHub: https://github.com/folke/todo-comments.nvim
=====================================================================
--]]

return {
  "folke/todo-comments.nvim",
  event = { "BufReadPost", "BufNewFile" },
  dependencies = { "nvim-lua/plenary.nvim" },
  
  opts = {
    -- Знаки в колонке
    signs = true,
    sign_priority = 8,
    
    -- Ключевые слова
    keywords = {
      FIX = {
        icon = " ",
        color = "error",
        alt = { "FIXME", "BUG", "FIXIT", "ISSUE" },
      },
      TODO = {
        icon = " ",
        color = "info",
      },
      HACK = {
        icon = " ",
        color = "warning",
      },
      WARN = {
        icon = " ",
        color = "warning",
        alt = { "WARNING", "XXX" },
      },
      PERF = {
        icon = " ",
        alt = { "OPTIM", "PERFORMANCE", "OPTIMIZE" },
      },
      NOTE = {
        icon = " ",
        color = "hint",
        alt = { "INFO" },
      },
      TEST = {
        icon = "⏲ ",
        color = "test",
        alt = { "TESTING", "PASSED", "FAILED" },
      },
    },
    
    -- Подсветка
    gui_style = {
      fg = "NONE",
      bg = "BOLD",
    },
    
    merge_keywords = true,
    
    -- Подсветка строки
    highlight = {
      multiline = true,
      multiline_pattern = "^.",
      multiline_context = 10,
      before = "",
      keyword = "wide",
      after = "fg",
      pattern = [[.*<(KEYWORDS)\s*:]],
      comments_only = true,
      max_line_len = 400,
      exclude = {},
    },
    
    -- Цвета
    colors = {
      error = { "DiagnosticError", "ErrorMsg", "#DC2626" },
      warning = { "DiagnosticWarn", "WarningMsg", "#FBBF24" },
      info = { "DiagnosticInfo", "#2563EB" },
      hint = { "DiagnosticHint", "#10B981" },
      default = { "Identifier", "#7C3AED" },
      test = { "Identifier", "#FF00FF" },
    },
    
    -- Поиск
    search = {
      command = "rg",
      args = {
        "--color=never",
        "--no-heading",
        "--with-filename",
        "--line-number",
        "--column",
      },
      pattern = [[\b(KEYWORDS):]],
    },
  },
  
  keys = {
    { "]t", function() require("todo-comments").jump_next() end, desc = "Следующий todo" },
    { "[t", function() require("todo-comments").jump_prev() end, desc = "Предыдущий todo" },
    { "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (Trouble)" },
    { 
      "<leader>xT", 
      "<cmd>Trouble todo toggle filter = {tag = {TODO,FIX,FIXME}}<cr>", 
      desc = "Todo/Fix/Fixme (Trouble)" 
    },
    { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Поиск todo" },
  },
}
