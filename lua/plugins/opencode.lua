-- OpenCode V2: вопросы и отправка контекста из Neovim.
--
-- Горячие клавиши (обычный режим и визуальное выделение):
--   Ctrl+A — открыть вопрос с готовым @this: ; отправка после Enter.
--   Ctrl+X — открыть меню промптов и команд, включая mentor-*.
--   Space a m — меню ментора со снимком буфера и выделения.
--   go     — отправить выделение; в обычном режиме ожидает движение
--            (например, goip — абзац). Отправляет без отдельного вопроса.
--   goo    — отправить текущую строку (только обычный режим).
--
-- Пункт ask_this открывает вопрос с готовым @this: .
-- @this подставляет выделение, диапазон оператора или позицию курсора.
-- Сообщения идут в последнюю обновлённую сессию для текущей папки (:pwd),
-- а не обязательно в сессию, открытую в соседней вкладке терминала.
--
-- Отдельная интеграция в lua/plugins/snacks.lua:
--   <localleader>o — в открытом picker добавить выбранные файлы в вопрос.
-- Проверка подключения: :checkhealth opencode.

return {
  "nickjvandyke/opencode.nvim",
  branch = "main", -- Ветка с поддержкой OpenCode V2.
  dependencies = {
    { "folke/snacks.nvim", opts = { input = { enabled = true }, picker = { enabled = true } } },
  },
  keys = {
    {
      "<Leader>am",
      function() require("mentor").menu() end,
      mode = { "n", "x" },
      desc = "Ментор: проверка, объяснение, тренировка",
    },
    {
      "<C-a>",
      function() require("opencode").ask "@this: " end,
      mode = { "n", "x" },
      desc = "OpenCode: задать вопрос",
    },
    {
      "<C-x>",
      function() require("mentor").select() end,
      mode = { "n", "x" },
      desc = "OpenCode: выбрать действие",
    },
    {
      "go",
      function() return require("opencode").operator "@this" end,
      mode = { "n", "x" },
      expr = true,
      desc = "OpenCode: отправить диапазон",
    },
    {
      "goo",
      function() return require("opencode").operator "@this" .. "_" end,
      mode = "n",
      expr = true,
      desc = "OpenCode: отправить строку",
    },
  },
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      select = {
        prompts = {
          ask_this = "@this: ...",
        },
      },
    }
  end,
}
