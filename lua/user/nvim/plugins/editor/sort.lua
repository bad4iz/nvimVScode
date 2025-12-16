-- Плагин Sort.nvim
-- Сортировка текста и строк с поддержкой различных алгоритмов
-- Работает как с визуальным выделением, так и с текстовыми объектами
--
-- Горячие клавиши (из astrocore.lua):
--   gs - Сортировать (в normal и visual режимах)
--
-- Примеры использования:
--   - Выделить строки в visual mode и нажать gs
--   - В normal mode: gs + motion (например, gsip для сортировки параграфа)
--   - Сортирует числа, строки, с учетом регистра
return {
  "sQVe/sort.nvim",
  lazy = false,
  -- Optional setup for overriding defaults.
  config = function()
    require("sort").setup {
      -- Input configuration here.
      -- Refer to the configuration section below for options.
    }
  end,
}
