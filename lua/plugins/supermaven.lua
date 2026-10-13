--[[
  Supermaven AI - работает в ДВУХ режимах одновременно

  1. INLINE ПОДСКАЗКИ ( + курсив):
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

  ЦВЕТОВАЯ СХЕМА:
  - Supermaven в cmp = ФИОЛЕТОВЫЙ (#d787ff)
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

    -- ФИКС: Устанавливаем highlight группу напрямую
    -- Плагин по умолчанию использует "Comment" (серый), нужно переопределить
    local function setup_highlights()
      -- Устанавливаем цвет и курсив
      vim.api.nvim_set_hl(0, "SupermavenSuggestion", {
        fg = "#d787ff",
        ctermfg = 244,
        italic = true,
      })

      -- Указываем плагину использовать нашу highlight группу
      local ok, preview = pcall(require, "supermaven-nvim.completion_preview")
      if ok then
        preview.suggestion_group = "SupermavenSuggestion"
      end
    end

    -- Применяем при загрузке и смене цветовой схемы
    vim.api.nvim_create_autocmd({ "VimEnter", "ColorScheme" }, {
      pattern = "*",
      callback = setup_highlights,
    })

    -- Применяем сразу с задержкой (плагин должен загрузиться)
    vim.schedule(setup_highlights)
  end,
}
