-- =============================================================================
--                            OPENCODE.NVIM
-- =============================================================================
-- Интеграция OpenCode AI ассистента с Neovim.
--
-- Зависимости:
-- - snacks.nvim     - терминал, picker, input, UI
-- - blink.cmp       - автодополнение
-- - render-markdown - рендеринг markdown ответов
--
-- Установка OpenCode CLI:
--   npm install -g @opencode/cli
--
-- Горячие клавиши (Leader = Space):
--
-- 📂 Главное меню:
--   <leader>o - Показать группу "AI/OpenCode" в which-key
--
-- 🚀 Основные действия:
--   <C-a>      - Задать вопрос opencode
--   <C-x>      - Выполнить действие opencode
--   <C-.>      - Показать/скрыть opencode
--
-- 📝 Управление контекстом:
--   go         - Добавить диапазон к opencode (operator pending)
--   goo        - Добавить строку к opencode (operator pending)
--
-- ↔️  Прокрутка:
--   <S-C-u>    - Прокрутить opencode вверх
--   <S-C-d>    - Прокрутить opencode вниз
--
-- ➕➖ Математика:
--   +          - Инкремент под курсором
--   -          - Декремент под курсором
-- =============================================================================

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    { "folke/snacks.nvim", opts = { input = {}, picker = {}, terminal = {} } },
  },
  opts = {},
  keys = {
    { "<leader>o", nil, desc = "AI/OpenCode" },
    { "<C-a>", function() require("opencode").ask("@this: ", { submit = true }) end, mode = { "n", "x" }, desc = "Задать вопрос opencode" },
    { "<C-x>", function() require("opencode").select() end, mode = { "n", "x" }, desc = "Выполнить действие opencode" },
    { "<C-.>", function() require("opencode").toggle() end, mode = { "n", "t" }, desc = "Показать/скрыть opencode" },
    { "go", function() return require("opencode").operator("@this ") end, mode = "n", expr = true, desc = "Добавить диапазон к opencode" },
    { "goo", function() return require("opencode").operator("@this ") .. "_" end, mode = "n", expr = true, desc = "Добавить строку к opencode" },
    { "<S-C-u>", function() require("opencode").command("session.half.page.up") end, mode = "n", desc = "Прокрутить opencode вверх" },
    { "<S-C-d>", function() require("opencode").command("session.half.page.down") end, mode = "n", desc = "Прокрутить opencode вниз" },
    { "+", "<C-a>", mode = "n", desc = "Инкремент под курсором", noremap = true },
    { "-", "<C-x>", mode = "n", desc = "Декремент под курсором", noremap = true },
  },
  config = function()
    vim.o.autoread = true
  end,
}