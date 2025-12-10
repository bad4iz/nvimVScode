--[[
=====================================================================
                          SNACKS.NVIM
=====================================================================
Коллекция полезных утилит для Neovim от folke (автор lazy.nvim).

Включает:
  - Dashboard    : красивая стартовая страница
  - Notifier     : стильные уведомления
  - Picker       : fuzzy finder (альтернатива telescope)
  - Indent       : направляющие отступов
  - Scroll       : плавная прокрутка
  - Words        : подсветка слова под курсором
  - Zen          : режим фокусировки
  - и многое другое...

Горячие клавиши (лидер = пробел):
  <leader>ff  - найти файлы
  <leader>fg  - поиск по тексту (grep)
  <leader>fb  - буферы
  <leader>fh  - история файлов
  <leader>fr  - недавние файлы
  <leader>/   - поиск в текущем буфере
  <leader>:   - история команд
  <leader>un  - скрыть уведомления

GitHub: https://github.com/folke/snacks.nvim
=====================================================================
--]]

return {
  "folke/snacks.nvim",
  priority = 1000,
  lazy = false,
  
  ---@type snacks.Config
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- DASHBOARD - Стартовая страница
    -- ═══════════════════════════════════════════════════════════════
    dashboard = {
      enabled = true,
      width = 60,
      row = nil,
      col = nil,
      pane_gap = 4,
      
      preset = {
        -- Команды для пунктов меню
        keys = {
          { icon = " ", key = "f", desc = "Найти файл", action = ":lua Snacks.picker.files()" },
          { icon = " ", key = "n", desc = "Новый файл", action = ":ene | startinsert" },
          { icon = " ", key = "g", desc = "Поиск текста", action = ":lua Snacks.picker.grep()" },
          { icon = " ", key = "r", desc = "Недавние файлы", action = ":lua Snacks.picker.recent()" },
          { icon = " ", key = "c", desc = "Конфигурация", action = ":lua Snacks.picker.files({ cwd = vim.fn.stdpath('config') })" },
          { icon = " ", key = "s", desc = "Восстановить сессию", section = "session" },
          { icon = "󰒲 ", key = "l", desc = "Lazy (плагины)", action = ":Lazy" },
          { icon = " ", key = "q", desc = "Выход", action = ":qa" },
        },
        
        -- ASCII логотип
        header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      },
      
      -- Секции дашборда
      sections = {
        { section = "header" },
        { section = "keys", gap = 1, padding = 1 },
        { section = "startup" },
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- NOTIFIER - Уведомления
    -- ═══════════════════════════════════════════════════════════════
    notifier = {
      enabled = true,
      timeout = 3000,        -- Время показа (мс)
      width = { min = 40, max = 0.4 },
      height = { min = 1, max = 0.6 },
      margin = { top = 0, right = 1, bottom = 0 },
      padding = true,
      sort = { "level", "added" },
      icons = {
        error = " ",
        warn = " ",
        info = " ",
        debug = " ",
        trace = "✎ ",
      },
      style = "compact",     -- compact, minimal, fancy
      top_down = true,
      date_format = "%H:%M",
      more_format = " (+%d)",
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- PICKER - Fuzzy Finder (основной)
    -- ═══════════════════════════════════════════════════════════════
    picker = {
      enabled = true,
      -- Источники по умолчанию
      sources = {},
      -- Стиль окна
      layout = {
        cycle = true,
        preset = "default", -- default, dropdown, ivy, select, cursor
      },
      -- Формат элементов
      formatters = {
        file = {
          filename_first = true, -- Сначала имя файла, потом путь
        },
      },
      -- Иконки
      icons = {
        files = {
          enabled = true,
        },
      },
      -- Действия по умолчанию
      actions = {
        -- enter = "edit",
        -- ctrl-s = "split",
        -- ctrl-v = "vsplit",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- INDENT - Направляющие отступов
    -- ═══════════════════════════════════════════════════════════════
    indent = {
      enabled = true,
      indent = {
        char = "│",
        blank = " ",
        only_scope = false,
        only_current = false,
      },
      scope = {
        enabled = true,
        char = "│",
        underline = false,
        only_current = false,
      },
      chunk = {
        enabled = true,
        only_current = true,
        char = {
          corner_top = "╭",
          corner_bottom = "╰",
          horizontal = "─",
          vertical = "│",
          arrow = ">",
        },
      },
      animate = {
        enabled = true,
        style = "out",
        easing = "linear",
        duration = {
          step = 20,
          total = 200,
        },
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- SCROLL - Плавная прокрутка
    -- ═══════════════════════════════════════════════════════════════
    scroll = {
      enabled = true,
      animate = {
        duration = { step = 15, total = 150 },
        easing = "linear",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- WORDS - Подсветка слова под курсором
    -- ═══════════════════════════════════════════════════════════════
    words = {
      enabled = true,
      debounce = 100,        -- Задержка перед подсветкой (мс)
      notify_jump = false,
      notify_end = true,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- QUICKFILE - Быстрое открытие файлов
    -- ═══════════════════════════════════════════════════════════════
    quickfile = {
      enabled = true,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- STATUSCOLUMN - Красивая колонка статуса
    -- ═══════════════════════════════════════════════════════════════
    statuscolumn = {
      enabled = true,
      left = { "mark", "sign" },
      right = { "fold", "git" },
      folds = {
        open = false,
        git_hl = false,
      },
      git = {
        patterns = { "GitSign" },
      },
      refresh = 50,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- LAZYGIT - Интеграция с lazygit
    -- ═══════════════════════════════════════════════════════════════
    lazygit = {
      enabled = true,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- TERMINAL - Терминал
    -- ═══════════════════════════════════════════════════════════════
    terminal = {
      enabled = true,
      win = {
        style = "terminal",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- INPUT - Красивый ввод
    -- ═══════════════════════════════════════════════════════════════
    input = {
      enabled = true,
      icon = " ",
      icon_pos = "left",
      prompt_pos = "title",
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- BIGFILE - Оптимизация для больших файлов
    -- ═══════════════════════════════════════════════════════════════
    bigfile = {
      enabled = true,
      notify = true,
      size = 1.5 * 1024 * 1024, -- 1.5 MB
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- STYLES - Стили для окон
    -- ═══════════════════════════════════════════════════════════════
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
  },
  
  -- ═══════════════════════════════════════════════════════════════
  -- ГОРЯЧИЕ КЛАВИШИ
  -- ═══════════════════════════════════════════════════════════════
  keys = {
    -- ─────────────────────────────────────────────────────────────
    -- ПОИСК ФАЙЛОВ (Picker)
    -- ─────────────────────────────────────────────────────────────
    { "<leader>ff", function() Snacks.picker.files() end, desc = "Найти файлы" },
    { "<leader>fg", function() Snacks.picker.grep() end, desc = "Поиск текста (grep)" },
    { "<leader>fb", function() Snacks.picker.buffers() end, desc = "Буферы" },
    { "<leader>fh", function() Snacks.picker.help() end, desc = "Справка" },
    { "<leader>fr", function() Snacks.picker.recent() end, desc = "Недавние файлы" },
    { "<leader>fc", function() Snacks.picker.grep_word() end, desc = "Найти слово под курсором", mode = { "n", "x" } },
    { "<leader>fp", function() Snacks.picker.projects() end, desc = "Проекты" },
    { "<leader>/", function() Snacks.picker.lines() end, desc = "Поиск в буфере" },
    { "<leader>:", function() Snacks.picker.command_history() end, desc = "История команд" },
    
    -- ─────────────────────────────────────────────────────────────
    -- GIT
    -- ─────────────────────────────────────────────────────────────
    { "<leader>gg", function() Snacks.lazygit() end, desc = "Lazygit" },
    { "<leader>gf", function() Snacks.picker.git_files() end, desc = "Git файлы" },
    { "<leader>gc", function() Snacks.picker.git_log() end, desc = "Git коммиты" },
    { "<leader>gs", function() Snacks.picker.git_status() end, desc = "Git статус" },
    { "<leader>gb", function() Snacks.picker.git_branches() end, desc = "Git ветки" },
    { "<leader>gB", function() Snacks.git_blame_line() end, desc = "Git blame строки" },
    
    -- ─────────────────────────────────────────────────────────────
    -- LSP
    -- ─────────────────────────────────────────────────────────────
    { "gd", function() Snacks.picker.lsp_definitions() end, desc = "Определение" },
    { "gr", function() Snacks.picker.lsp_references() end, desc = "Ссылки" },
    { "gI", function() Snacks.picker.lsp_implementations() end, desc = "Реализации" },
    { "gy", function() Snacks.picker.lsp_type_definitions() end, desc = "Тип определения" },
    { "<leader>ss", function() Snacks.picker.lsp_symbols() end, desc = "Символы документа" },
    { "<leader>sS", function() Snacks.picker.lsp_workspace_symbols() end, desc = "Символы проекта" },
    
    -- ─────────────────────────────────────────────────────────────
    -- УВЕДОМЛЕНИЯ
    -- ─────────────────────────────────────────────────────────────
    { "<leader>un", function() Snacks.notifier.hide() end, desc = "Скрыть уведомления" },
    { "<leader>uN", function() Snacks.picker.notifications() end, desc = "История уведомлений" },
    
    -- ─────────────────────────────────────────────────────────────
    -- ТЕРМИНАЛ
    -- ─────────────────────────────────────────────────────────────
    { "<leader>tt", function() Snacks.terminal() end, desc = "Открыть терминал" },
    { "<c-/>", function() Snacks.terminal() end, desc = "Открыть терминал", mode = { "n", "t" } },
    
    -- ─────────────────────────────────────────────────────────────
    -- РАЗНОЕ
    -- ─────────────────────────────────────────────────────────────
    { "<leader>.", function() Snacks.scratch() end, desc = "Scratch буфер" },
    { "<leader>S", function() Snacks.scratch.select() end, desc = "Выбрать scratch" },
    { "<leader>bd", function() Snacks.bufdelete() end, desc = "Удалить буфер" },
    { "<leader>bD", function() Snacks.bufdelete.all() end, desc = "Удалить все буферы" },
    { "]]", function() Snacks.words.jump(vim.v.count1) end, desc = "Следующее слово", mode = { "n", "t" } },
    { "[[", function() Snacks.words.jump(-vim.v.count1) end, desc = "Предыдущее слово", mode = { "n", "t" } },
  },
  
  init = function()
    -- Настройка vim.notify для использования Snacks notifier
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Глобальный доступ к Snacks
        _G.Snacks = require("snacks")
        
        -- Используем Snacks для vim.notify
        vim.notify = Snacks.notifier.notify
        
        -- Включаем отладочную функцию
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd
        
        -- Переключение различных опций
        Snacks.toggle.option("spell", { name = "Проверка орфографии" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Перенос строк" }):map("<leader>uw")
        Snacks.toggle.option("relativenumber", { name = "Относительные номера" }):map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>ul")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.dim():map("<leader>uD")
      end,
    })
  end,
}
