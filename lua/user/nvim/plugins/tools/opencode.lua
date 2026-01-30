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
    { "<leader>O", nil, desc = "AI/OpenCode" },
    {
      "<C-a>",
      function()
        require("opencode").ask("@this: ", { submit = true })
      end,
      mode = { "n", "x" },
      desc = "Задать вопрос opencode",
    },
    {
      "<C-x>",
      function()
        require("opencode").select()
      end,
      mode = { "n", "x" },
      desc = "Выполнить действие opencode",
    },
    {
      "<C-.>",
      function()
        require("opencode").toggle()
      end,
      mode = { "n", "t" },
      desc = "Показать/скрыть opencode",
    },
    {
      "go",
      function()
        return require("opencode").operator("@this ")
      end,
      mode = "n",
      expr = true,
      desc = "Добавить диапазон к opencode",
    },
    {
      "goo",
      function()
        return require("opencode").operator("@this ") .. "_"
      end,
      mode = "n",
      expr = true,
      desc = "Добавить строку к opencode",
    },
    {
      "<S-C-u>",
      function()
        require("opencode").command("session.half.page.up")
      end,
      mode = "n",
      desc = "Прокрутить opencode вверх",
    },
    {
      "<S-C-d>",
      function()
        require("opencode").command("session.half.page.down")
      end,
      mode = "n",
      desc = "Прокрутить opencode вниз",
    },
    { "+", "<C-a>", mode = "n", desc = "Инкремент под курсором", noremap = true },
    { "-", "<C-x>", mode = "n", desc = "Декремент под курсором", noremap = true },
  },
  config = function()
    vim.o.autoread = true

    -- opencode.nvim при поиске запущенного сервера синхронно дергает
    -- `curl http://localhost:<port>/path`.
    -- Если у вас остался "залипший" opencode-процесс (порт слушает, но /path не отвечает),
    -- Neovim выглядит как зависший. Добавляем жесткий таймаут на этот probe.
    local ok_client, client = pcall(require, "opencode.cli.client")
    if ok_client and not client.__nvim_timeout_patch then
      client.__nvim_timeout_patch = true
      local ok_util, util = pcall(require, "opencode.util")
      if ok_util then
        client.get_path = function(port)
          local curl_result = vim
            .system({
              "curl",
              "-s",
              "--connect-timeout",
              "1",
              "--max-time",
              "2",
              "http://localhost:" .. tostring(port) .. "/path",
            })
            :wait()
          util.check_system_call(curl_result, "curl")

          local path_ok, path_data = pcall(vim.fn.json_decode, curl_result.stdout)
          if path_ok and (path_data.directory or path_data.worktree) then
            return path_data
          end

          error("Failed to parse `opencode` CWD data: " .. (curl_result.stdout or ""), 0)
        end
      end
    end

    vim.g.opencode_opts = {
      -- Custom prompts for opencode.nvim (shown in the "Prompts" section).
      -- `@this` is expanded by the plugin to the current file/selection context.
      prompts = {
        -- Override the built-in `test` prompt to route through our strict command.
        test = { prompt = "/test-react @this", submit = true },
      },
      provider = {
        enabled = "snacks",
        snacks = {
          win = {
            position = "bottom",
            enter = false,
            wo = {
              winbar = "",
            },
            bo = {
              filetype = "opencode_terminal",
            },
          },
        },
      },
    }
  end,
}
