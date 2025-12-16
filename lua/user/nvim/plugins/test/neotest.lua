--[[
====================================================
          NEOTEST - ТЕСТИРОВАНИЕ В NEOVIM
====================================================
Фреймворк для запуска тестов из Neovim

Возможности:
- Запуск тестов (файл, ближайший, все)
- Summary панель с результатами
- Вывод тестов в popup окне
- Watch mode для автоматического перезапуска
- Интеграция с DAP для отладки

Горячие клавиши (группа <leader>t):
- <leader>tt - запустить ближайший тест
- <leader>tf - запустить все тесты в файле
- <leader>ts - открыть Summary панель
- <leader>to - показать вывод теста
- <leader>tS - остановить тесты
- <leader>tw - watch mode
- <leader>tl - последний тест

Команды:
- :Neotest run - запустить тесты
- :Neotest summary - открыть summary
- :Neotest output - показать вывод

GitHub: https://github.com/nvim-neotest/neotest
Vitest adapter: https://github.com/marilari88/neotest-vitest
====================================================
--]]

return {
  "nvim-neotest/neotest",
  dependencies = {
    "nvim-neotest/nvim-nio",
    "nvim-lua/plenary.nvim",
    "antoinemadec/FixCursorHold.nvim",
    "nvim-treesitter/nvim-treesitter",
    "marilari88/neotest-vitest",
  },
  keys = {
    {
      "<leader>tt",
      function()
        require("neotest").run.run()
      end,
      desc = "Run nearest test",
    },
    {
      "<leader>tf",
      function()
        require("neotest").run.run(vim.fn.expand("%"))
      end,
      desc = "Run file tests",
    },
    {
      "<leader>ts",
      function()
        require("neotest").summary.toggle()
      end,
      desc = "Toggle summary",
    },
    {
      "<leader>to",
      function()
        require("neotest").output.open({ enter = true })
      end,
      desc = "Show output",
    },
    {
      "<leader>tO",
      function()
        require("neotest").output_panel.toggle()
      end,
      desc = "Toggle output panel",
    },
    {
      "<leader>tS",
      function()
        require("neotest").run.stop()
      end,
      desc = "Stop tests",
    },
    {
      "<leader>tw",
      function()
        require("neotest").run.run({ vitestCommand = "vitest --watch" })
      end,
      desc = "Watch mode",
    },
    {
      "<leader>tl",
      function()
        require("neotest").run.run_last()
      end,
      desc = "Run last test",
    },
    {
      "<leader>ta",
      function()
        require("neotest").run.run(vim.fn.getcwd())
      end,
      desc = "Run all tests",
    },
    {
      "[t",
      function()
        require("neotest").jump.prev({ status = "failed" })
      end,
      desc = "Prev failed test",
    },
    {
      "]t",
      function()
        require("neotest").jump.next({ status = "failed" })
      end,
      desc = "Next failed test",
    },
  },
  config = function()
    require("neotest").setup({
      adapters = {
        require("neotest-vitest")({
          -- Фильтрация директорий при поиске тестов
          filter_dir = function(name)
            return name ~= "node_modules"
          end,
        }),
      },
    })
  end,
}
