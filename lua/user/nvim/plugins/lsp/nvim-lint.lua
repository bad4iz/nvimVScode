--[[
=====================================================================
                          NVIM-LINT
=====================================================================
Асинхронный линтер для Neovim.

Дополняет LSP дополнительными линтерами.
Запускается автоматически при:
  - Открытии файла
  - Сохранении файла
  - Выходе из Insert mode

Команды:
  :lua require('lint').try_lint()  - запустить линтер вручную

Поддерживаемые линтеры:
   - stylelint   : CSS, SCSS

GitHub: https://github.com/mfussenegger/nvim-lint
=====================================================================
--]]

return {
  "mfussenegger/nvim-lint",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  
  opts = {
    -- События для запуска линтера
    events = { "BufWritePost", "BufReadPost", "InsertLeave" },
    
    -- Линтеры по типам файлов
    linters_by_ft = {
      javascript = {},
      javascriptreact = {},
      typescript = {},
      typescriptreact = {},
      
      css = { "stylelint" },
      scss = { "stylelint" },
      
      -- Можно добавить другие:
      -- python = { "ruff", "mypy" },
      -- go = { "golangcilint" },
    },
    
    -- Настройки линтеров
    linters = {},
  },
  
  config = function(_, opts)
    local lint = require("lint")
    
    -- Настраиваем линтеры
    lint.linters_by_ft = opts.linters_by_ft
    
    -- Настраиваем отдельные линтеры
    for name, config in pairs(opts.linters or {}) do
      if type(config) == "table" and lint.linters[name] then
        lint.linters[name] = vim.tbl_deep_extend("force", lint.linters[name], config)
      end
    end
    
    -- Функция для запуска линтера
    local function lint_buffer()
      -- Получаем линтеры для текущего типа файла
      local names = lint._resolve_linter_by_ft(vim.bo.filetype)
      
      -- Проверяем, что линтеры установлены
      names = vim.tbl_filter(function(name)
        local linter = lint.linters[name]
        if not linter then
          return false
        end
        
        -- Проверяем cmd - может быть строка или функция
        local cmd = linter.cmd
        if type(cmd) == "function" then
          cmd = cmd()
        end
        
        return type(cmd) == "string" and vim.fn.executable(cmd) == 1
      end, names)
      
      -- Запускаем линтеры
      if #names > 0 then
        lint.try_lint(names)
      end
    end
    
    -- Автокоманды для запуска линтера
    vim.api.nvim_create_autocmd(opts.events, {
      group = vim.api.nvim_create_augroup("nvim-lint", { clear = true }),
      callback = function()
        -- Небольшая задержка для debounce
        vim.defer_fn(lint_buffer, 100)
      end,
    })
    
    -- Команда для ручного запуска
    vim.api.nvim_create_user_command("Lint", function()
      lint_buffer()
      vim.notify("Линтинг запущен", vim.log.levels.INFO)
    end, { desc = "Запустить линтер" })
    
    -- Горячая клавиша
    vim.keymap.set("n", "<leader>ll", function()
      lint_buffer()
    end, { desc = "Запустить линтер" })
  end,
}
