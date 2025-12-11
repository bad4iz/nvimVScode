--[[
=====================================================================
                        CODEIUM AI
=====================================================================
  AI автодополнение через blink.cmp

  ИНТЕГРАЦИЯ С BLINK.CMP:
  - Подсказки Codeium отображаются через blink.compat
  - Иконка:  (искры)
  - Приоритет: 90 (выше сниппетов, ниже LSP и Supermaven)
  - Асинхронная загрузка подсказок

  СОВМЕСТИМОСТЬ:
  - Работает одновременно с Supermaven
  - Codeium = в меню blink.cmp
  - Supermaven =  в меню blink.cmp

  ГОРЯЧИЕ КЛАВИШИ (через blink.cmp):
  - <CR>       - принять выбранную подсказку
  - <Tab>      - следующий элемент
  - <S-Tab>    - предыдущий элемент
  - <C-Space>  - открыть меню автодополнения
  - <C-e>      - закрыть меню

  КОМАНДЫ:
  :Codeium Auth    - авторизация
  :Codeium Chat    - открыть чат

  GitHub: https://github.com/Exafunction/codeium.nvim
  Настройки blink.cmp: lua/user/nvim/plugins/blink-cmp.lua:146-158
=====================================================================
--]]
return {
  "Exafunction/codeium.nvim",
  event = "InsertEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  config = function()
    require("codeium").setup {
      -- Включить Codeium Chat
      enable_cmp_source = true, -- Включить как источник для автодополнения
      virtual_text = {
        enabled = false, -- Отключить inline подсказки (используем только через blink.cmp)
      },
    }
  end,
}
