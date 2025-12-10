--[[
=====================================================================
                        PERSISTENCE
=====================================================================
Сохранение и восстановление сессий.

Возможности:
  - Восстанавливает открытые файлы при перезапуске
  - Сохраняет позицию курсора
  - Сохраняет раскладку окон

Команды:
  :SessionSave    - сохранить текущую сессию
  :SessionRestore - восстановить последнюю сессию
  :SessionDelete  - удалить сессию

GitHub: https://github.com/folke/persistence.nvim
=====================================================================
--]]

return {
  "folke/persistence.nvim",
  event = "BufReadPre",
  
  opts = {
    dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/"),
    options = { "buffers", "curdir", "tabpages", "winsize", "help", "globals", "skiprtp", "folds" },
  },
  
  keys = {
    { "<leader>qs", function() require("persistence").load() end, desc = "Восстановить сессию" },
    { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Восстановить последнюю сессию" },
    { "<leader>qd", function() require("persistence").stop() end, desc = "Не сохранять сессию" },
  },
}
