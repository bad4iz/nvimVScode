--[[
  Supermaven AI - работает в ДВУХ режимах одновременно

  1. INLINE ПОДСКАЗКИ (серый #6e7681 + курсив):
     - Показывает предложения справа от курсора
     - Стиль GitHub Copilot - не отвлекает от кода
     - Горячие клавиши:
       • <C-y> - принять подсказку
       • <C-Right> - принять слово
       • <C-]> - очистить подсказку

  2. NVIM-CMP МЕНЮ (фиолетовый цвет #d787ff):
     - Подсказки в меню автодополнения
     - Легко сравнить с Codeium (бирюзовый) и LSP (обычный)
     - Иконка: 󱙺 Supermaven (робот = AI помощник)
     - Настроено в: lua/plugins/cmp.lua:24-27, 32

  ЦВЕТОВАЯ СХЕМА:
  - Supermaven inline = СЕРЫЙ (#6e7681) + курсив (GitHub Copilot style)
  - Supermaven в cmp = ФИОЛЕТОВЫЙ (#d787ff)
  - Codeium в cmp = БИРЮЗОВЫЙ (#00d7af)
  - LSP = обычный цвет
--]]
return {
  "supermaven-inc/supermaven-nvim",
  config = function()
    require("supermaven-nvim").setup({
      keymaps = {
        accept_suggestion = "<C-g>", -- Принять inline подсказку
        clear_suggestion = "<C-]>", -- Очистить inline подсказку
        accept_word = "<C-Right>", -- Принять слово
      },
      ignore_filetypes = {},
      color = {
        suggestion_color = "#d787ff",
        cterm = 244,
      },
      log_level = "off",
      disable_inline_completion = false, -- false = inline включены
      disable_keymaps = false,
    })

    -- Стиль inline подсказок: курсив + фиолетовый цвет
    -- Применяем после загрузки плагина через autocmd
    vim.api.nvim_create_autocmd("ColorScheme", {
      pattern = "*",
      callback = function()
        vim.api.nvim_set_hl(0, "SupermavenSuggestion", {
          fg = "#d787ff",
          italic = true,
        })
      end,
    })

    -- Применяем сразу
    vim.api.nvim_set_hl(0, "SupermavenSuggestion", {
      fg = "#d787ff",
      italic = true,
    })
  end,
}
