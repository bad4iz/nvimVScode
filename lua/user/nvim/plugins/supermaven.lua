--[[
=====================================================================
                        SUPERMAVEN
=====================================================================
AI-помощник для автодополнения кода.

Особенности:
  - Быстрое автодополнение на основе AI
  - Работает локально (приватность)
  - Поддержка множества языков
  - Интеграция с blink.cmp

Горячие клавиши:
  <Tab>       - принять предложение (если нет других)
  <C-]>       - отменить предложение
  <C-j>       - принять следующее слово
  
Команды:
  :SupermavenStart    - запустить Supermaven
  :SupermavenStop     - остановить Supermaven
  :SupermavenRestart  - перезапустить
  :SupermavenStatus   - показать статус
  :SupermavenToggle   - включить/выключить

GitHub: https://github.com/supermaven-inc/supermaven-nvim

ПРИМЕЧАНИЕ: Supermaven был приобретён Cursor. Если плагин перестанет
обновляться, рассмотрите альтернативы:
  - codeium.nvim (бесплатный)
  - minuet-ai.nvim (поддержка разных провайдеров)
=====================================================================
--]]

return {
  "supermaven-inc/supermaven-nvim",
  event = "InsertEnter", -- Загружать при входе в Insert mode
  
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- СОЧЕТАНИЯ КЛАВИШ
    -- ═══════════════════════════════════════════════════════════════
    keymaps = {
      -- Принять всё предложение
      accept_suggestion = "<Tab>",
      -- Отменить предложение
      clear_suggestion = "<C-]>",
      -- Принять только следующее слово
      accept_word = "<C-j>",
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ИГНОРИРУЕМЫЕ ТИПЫ ФАЙЛОВ
    -- ═══════════════════════════════════════════════════════════════
    ignore_filetypes = {
      -- Конфиденциальные файлы
      "env",
      "gitcommit",
      "gitrebase",
      
      -- Файлы без кода
      "help",
      "markdown",
      "text",
      "TelescopePrompt",
      "neo-tree",
      "lazy",
      "mason",
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ЦВЕТ ПРЕДЛОЖЕНИЙ
    -- ═══════════════════════════════════════════════════════════════
    color = {
      -- Цвет текста предложения (серый)
      suggestion_color = "#585b70",
      -- Цвет для терминалов без true color
      cterm = 244,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ЛОГИРОВАНИЕ
    -- ═══════════════════════════════════════════════════════════════
    -- Уровни: "off", "error", "warn", "info", "debug", "trace"
    log_level = "info",
    
    -- ═══════════════════════════════════════════════════════════════
    -- ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ
    -- ═══════════════════════════════════════════════════════════════
    
    -- Отключить inline completion (если используете только через blink.cmp)
    disable_inline_completion = false,
    
    -- Отключить встроенные keymaps (для ручной настройки)
    disable_keymaps = false,
    
    -- Условие для отключения Supermaven
    -- Возвращает true = Supermaven отключен
    condition = function()
      -- Отключить в буферах без имени файла
      local bufname = vim.fn.expand("%:t")
      if bufname == "" then
        return true
      end
      
      -- Отключить для очень больших файлов (> 100KB)
      local filesize = vim.fn.getfsize(vim.fn.expand("%:p"))
      if filesize > 100 * 1024 then
        return true
      end
      
      return false
    end,
  },
  
  config = function(_, opts)
    require("supermaven-nvim").setup(opts)
    
    -- Создаём команду для переключения
    vim.api.nvim_create_user_command("SupermavenToggle", function()
      local api = require("supermaven-nvim.api")
      if api.is_running() then
        api.stop()
        vim.notify("Supermaven остановлен", vim.log.levels.INFO)
      else
        api.start()
        vim.notify("Supermaven запущен", vim.log.levels.INFO)
      end
    end, { desc = "Переключить Supermaven" })
    
    -- Добавляем keymapping для переключения
    vim.keymap.set("n", "<leader>ai", "<cmd>SupermavenToggle<cr>", { 
      desc = "Переключить Supermaven" 
    })
    
    -- Добавляем в statusline индикатор (опционально)
    vim.api.nvim_create_autocmd("User", {
      pattern = "SupermavenStatus",
      callback = function()
        -- Можно добавить обновление statusline
      end,
    })
  end,
}
