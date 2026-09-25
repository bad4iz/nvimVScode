-- OpenCode integration for Neovim.
-- Docs: https://github.com/NickvanDyke/opencode.nvim
--
return {
  "nickjvandyke/opencode.nvim",
  -- Defaults to "main", supporting OpenCode v2.
  -- Uncomment to pull the latest stable release, supporting OpenCode v1.
  -- version = "*",
  config = function()
    ---@type opencode.Opts
    vim.g.opencode_opts = {
      -- Промпты, видимые в секции PROMPTS меню select() (<C-x>).
      -- "..." в конце не отправляется, а открывает ask() с остальным текстом,
      -- поэтому пункт "this" открывает окно ввода уже с предзаполненным "@this ".
      select = {
        prompts = {
          this = "@this ...",
        },
      },
    }

    -- Рекомендуемые/примерные биндинги
    -- <C-a> в обычном и визуальном режиме: открывает окно запроса, в которое сразу
    -- подставлен текущий буфер ("@this: " упоминает файл), чтобы запрос сразу шёл
    -- с контекстом текущего файла.
    vim.keymap.set(
      { "n", "x" },
      "<C-a>",
      function() require("opencode").ask "@this: " end,
      { desc = "Ask OpenCode…" }
    )
    -- <C-x> в обычном и визуальном режиме: открывает список выбора OpenCode,
    -- например чтобы выбрать сессию или провайдера во всплывающем окне.
    vim.keymap.set({ "n", "x" }, "<C-x>", function() require("opencode").select() end, { desc = "Select OpenCode…" })
    -- "go" — оператор (expr = true возвращает motion), поэтому работает как `go<motion>`
    -- и отправляет в OpenCode любой выделенный диапазон, например `goyy` или `govj`.
    vim.keymap.set(
      { "n", "x" },
      "go",
      function() return require("opencode").operator "@this" end,
      { desc = "Send range to OpenCode", expr = true }
    )
    -- "goo" в обычном режиме: сокращение для текущей строки — "@this_" выбирает всю
    -- строку, а не только символы под курсором.
    vim.keymap.set(
      { "n" },
      "goo",
      function() return require("opencode").operator "@this" .. "_" end,
      { desc = "Send line to OpenCode", expr = true }
    )
  end,
}
