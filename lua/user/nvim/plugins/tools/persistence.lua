--[[
=====================================================================
                        PERSISTENCE
=====================================================================
Сохранение и восстановление сессий (AstroNvim style).

Горячие клавиши:
  <leader>Ss - сохранить сессию
  <leader>Sl - загрузить последнюю сессию
  <leader>Sd - не сохранять сессию при выходе
  <leader>S. - загрузить сессию текущей директории

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

  -- AstroNvim style: <leader>S для сессий
  keys = {
    { "<leader>Ss", function() require("persistence").save() end, desc = "Сохранить сессию" },
    { "<leader>Sl", function() require("persistence").load({ last = true }) end, desc = "Загрузить последнюю сессию" },
    { "<leader>S.", function() require("persistence").load() end, desc = "Загрузить сессию (cwd)" },
    { "<leader>Sd", function() require("persistence").stop() end, desc = "Не сохранять сессию" },
    { "<leader>Sf", function()
      -- Используем snacks.picker если доступен
      local has_snacks, snacks = pcall(require, "snacks")
      if has_snacks and snacks.picker then
        local sessions_dir = vim.fn.expand(vim.fn.stdpath("state") .. "/sessions/")
        snacks.picker.files({ cwd = sessions_dir })
      else
        vim.notify("Установите snacks.nvim для выбора сессий", vim.log.levels.WARN)
      end
    end, desc = "Найти сессии" },
  },
}
