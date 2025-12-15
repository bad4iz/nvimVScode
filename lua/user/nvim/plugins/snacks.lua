--[[
=====================================================================
                          SNACKS.NVIM
=====================================================================
Коллекция полезных утилит для Neovim от folke (автор lazy.nvim).
Конфигурация в стиле AstroNvim.

Включает:
  - Dashboard    : красивая стартовая страница
  - Notifier     : стильные уведомления
  - Picker       : fuzzy finder (альтернатива telescope)
  - Indent       : направляющие отступов
  - Scroll       : плавная прокрутка
  - Words        : подсветка слова под курсором
  - Zen          : режим фокусировки
  - и многое другое...

Горячие клавиши (лидер = пробел) в стиле AstroNvim:
  <leader>ff  - найти файлы
  <leader>fF  - найти ВСЕ файлы (включая скрытые)
  <leader>fg  - git файлы
  <leader>fw  - поиск слов (grep)
  <leader>fW  - поиск слов во ВСЕХ файлах
  <leader>fb  - буферы
  <leader>fo  - недавние файлы (проект)
  <leader>fO  - недавние файлы (все)
  <leader>fc  - слово под курсором
  <leader>fC  - команды
  <leader>fh  - справка
  <leader>fk  - горячие клавиши
  <leader>fm  - man pages
  <leader>fn  - уведомления
  <leader>fr  - регистры
  <leader>fs  - smart (буферы + recent + files)
  <leader>ft  - темы (colorschemes)
  <leader>fu  - undo history
  <leader>f'  - marks
  <leader>f<CR> - возобновить поиск
  <leader>fa  - config files

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
    -- DASHBOARD - Стартовая страница (AstroNvim style)
    -- ═══════════════════════════════════════════════════════════════
    dashboard = {
      enabled = true,
      width = 60,
      row = nil,
      col = nil,
      pane_gap = 4,

      preset = {
        keys = {
          { icon = " ", key = "n", desc = "Новый файл", action = "<leader>n" },
          { icon = " ", key = "f", desc = "Найти файл", action = "<leader>ff" },
          { icon = " ", key = "o", desc = "Недавние файлы (проект)", action = "<leader>fo" },
          { icon = " ", key = "O", desc = "Недавние файлы (все)", action = "<leader>fO" },
          { icon = " ", key = "w", desc = "Найти слово", action = "<leader>fw" },
          { icon = " ", key = "'", desc = "Закладки", action = "<leader>f'" },
          { icon = " ", key = "s", desc = "Сессия проекта", action = "<leader>S." },
          { icon = " ", key = "c", desc = "Конфиг", action = "<leader>fa" },
          { icon = "󰒲 ", key = "l", desc = "Lazy", action = ":Lazy" },
          { icon = " ", key = "m", desc = "Mason", action = ":Mason" },
          { icon = " ", key = "q", desc = "Выйти", action = ":qa" },
        },

        header = [[
    ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗
    ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║
    ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║
    ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║
    ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║
    ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝
        ]],
      },

      sections = {
        { section = "header", padding = 2 },
        { section = "keys", gap = 1, padding = 2 },
        { section = "startup" },
      },
    },

    -- ═══════════════════════════════════════════════════════════════
    -- NOTIFIER - Уведомления
    -- ═══════════════════════════════════════════════════════════════
    notifier = {
      enabled = true,
      timeout = 3000,
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
      style = "compact",
      top_down = true,
      date_format = "%H:%M",
      more_format = " (+%d)",
    },

    -- ═══════════════════════════════════════════════════════════════
    -- PICKER - Fuzzy Finder (AstroNvim style)
    -- ═══════════════════════════════════════════════════════════════
    picker = {
      enabled = true,
      ui_select = true,
      sources = {},
      layout = {
        cycle = true,
        preset = "default",
      },
      formatters = {
        file = {
          filename_first = true,
        },
      },
      icons = {
        files = {
          enabled = true,
        },
      },
    },

    -- ═══════════════════════════════════════════════════════════════
    -- INDENT - Направляющие отступов (AstroNvim style)
    -- ═══════════════════════════════════════════════════════════════
    indent = {
      enabled = true,
      indent = {
        char = "▏",
        blank = " ",
        only_scope = false,
        only_current = false,
      },
      scope = {
        enabled = true,
        char = "▏",
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
        enabled = false, -- AstroNvim отключает анимацию
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
      debounce = 100,
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
    -- TERMINAL - Терминал (AstroNvim style)
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
      size = 1.5 * 1024 * 1024,
    },

    -- ═══════════════════════════════════════════════════════════════
    -- ZEN - Режим фокусировки (AstroNvim style)
    -- ═══════════════════════════════════════════════════════════════
    zen = {
      enabled = true,
      toggles = {
        dim = false,
        diagnostics = false,
        inlay_hints = false,
      },
      win = {
        width = function()
          return math.min(120, math.floor(vim.o.columns * 0.75))
        end,
        height = 0.9,
        backdrop = { transparent = false },
        wo = {
          number = false,
          relativenumber = false,
          signcolumn = "no",
          foldcolumn = "0",
          list = false,
        },
      },
    },

    -- ═══════════════════════════════════════════════════════════════
    -- STYLES
    -- ═══════════════════════════════════════════════════════════════
    styles = {
      notification = {
        wo = { wrap = true },
      },
    },
  },

  -- ═══════════════════════════════════════════════════════════════
  -- ГОРЯЧИЕ КЛАВИШИ (AstroNvim style)
  -- ═══════════════════════════════════════════════════════════════
  keys = {
    -- ─────────────────────────────────────────────────────────────
    -- DASHBOARD / HOME (AstroNvim: <leader>h)
    -- ─────────────────────────────────────────────────────────────
    {
      "<leader>h",
      function()
        if vim.bo.filetype == "snacks_dashboard" then
          Snacks.bufdelete()
        else
          Snacks.dashboard()
        end
      end,
      desc = "Домашний экран",
    },

    -- ─────────────────────────────────────────────────────────────
    -- ПОИСК ФАЙЛОВ / PICKER (AstroNvim style <leader>f)
    -- ─────────────────────────────────────────────────────────────
    -- Возобновить предыдущий поиск
    {
      "<leader>f<CR>",
      function()
        Snacks.picker.resume()
      end,
      desc = "Продолжить предыдущий поиск",
    },

    -- Файлы
    {
      "<leader>ff",
      function()
        Snacks.picker.files({
          hidden = vim.tbl_get((vim.uv or vim.loop).fs_stat(".git") or {}, "type") == "directory",
        })
      end,
      desc = "Найти файлы",
    },
    {
      "<leader>fF",
      function()
        Snacks.picker.files({ hidden = true, ignored = true })
      end,
      desc = "Найти все файлы",
    },
    {
      "<leader>fg",
      function()
        Snacks.picker.git_files()
      end,
      desc = "Найти git-файлы",
    },

    -- Grep / слова
    {
      "<leader>fw",
      function()
        Snacks.picker.grep()
      end,
      desc = "Найти слова",
    },
    {
      "<leader>fW",
      function()
        Snacks.picker.grep({ hidden = true, ignored = true })
      end,
      desc = "Найти слова во всех файлах",
    },
    {
      "<leader>fc",
      function()
        Snacks.picker.grep_word()
      end,
      desc = "Найти слово под курсором",
      mode = { "n", "x" },
    },

    -- Буферы
    {
      "<leader>fb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Найти буферы",
    },
    {
      "<leader>bb",
      function()
        Snacks.picker.buffers()
      end,
      desc = "Найти буферы",
    },

    -- Недавние файлы
    {
      "<leader>fo",
      function()
        Snacks.picker.recent({ filter = { cwd = true } })
      end,
      desc = "Найти недавние файлы (проект)",
    },
    {
      "<leader>fO",
      function()
        Snacks.picker.recent()
      end,
      desc = "Найти недавние файлы (все)",
    },

    -- Справка / документация
    {
      "<leader>fh",
      function()
        Snacks.picker.help()
      end,
      desc = "Найти справку",
    },
    {
      "<leader>fm",
      function()
        Snacks.picker.man()
      end,
      desc = "Найти man-страницы",
    },

    -- Прочий поиск
    {
      "<leader>fk",
      function()
        Snacks.picker.keymaps()
      end,
      desc = "Найти хоткеи",
    },
    {
      "<leader>fC",
      function()
        Snacks.picker.commands()
      end,
      desc = "Найти команды",
    },
    {
      "<leader>f'",
      function()
        Snacks.picker.marks()
      end,
      desc = "Найти метки",
    },
    {
      "<leader>fr",
      function()
        Snacks.picker.registers()
      end,
      desc = "Найти регистры",
    },
    {
      "<leader>fn",
      function()
        Snacks.picker.notifications()
      end,
      desc = "Найти уведомления",
    },
    {
      "<leader>ft",
      function()
        Snacks.picker.colorschemes()
      end,
      desc = "Найти темы",
    },
    {
      "<leader>fu",
      function()
        Snacks.picker.undo()
      end,
      desc = "Найти историю undo",
    },
    {
      "<leader>fl",
      function()
        Snacks.picker.lines()
      end,
      desc = "Найти строки",
    },
    {
      "<leader>fs",
      function()
        Snacks.picker.smart()
      end,
      desc = "Умный поиск (буферы/недавние/файлы)",
    },
    {
      "<leader>fp",
      function()
        Snacks.picker.projects()
      end,
      desc = "Найти проекты",
    },

    -- Файлы конфига (AstroNvim: <leader>fa)
    {
      "<leader>fa",
      function()
        Snacks.picker.files({ cwd = vim.fn.stdpath("config") })
      end,
      desc = "Найти файлы конфига",
    },

    -- Строки / поиск по буферу
    {
      "<leader>/",
      function()
        Snacks.picker.lines()
      end,
      desc = "Поиск в буфере",
    },
    {
      "<leader>:",
      function()
        Snacks.picker.command_history()
      end,
      desc = "История команд",
    },

    -- ─────────────────────────────────────────────────────────────
    -- GIT (AstroNvim style <leader>g)
    -- ─────────────────────────────────────────────────────────────
    {
      "<leader>gg",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>tl",
      function()
        Snacks.lazygit()
      end,
      desc = "Lazygit",
    },
    {
      "<leader>gb",
      function()
        Snacks.picker.git_branches()
      end,
      desc = "Git-ветки",
    },
    {
      "<leader>gc",
      function()
        Snacks.picker.git_log()
      end,
      desc = "Git-коммиты (репозиторий)",
    },
    {
      "<leader>gC",
      function()
        Snacks.picker.git_log({ current_file = true, follow = true })
      end,
      desc = "Git-коммиты (текущий файл)",
    },
    {
      "<leader>gt",
      function()
        Snacks.picker.git_status()
      end,
      desc = "Git-статус",
    },
    {
      "<leader>gT",
      function()
        Snacks.picker.git_stash()
      end,
      desc = "Git-stash",
    },
    {
      "<leader>go",
      function()
        Snacks.gitbrowse()
      end,
      desc = "Git-browse (открыть)",
      mode = { "n", "x" },
    },
    {
      "<leader>gB",
      function()
        Snacks.git_blame_line()
      end,
      desc = "Git-blame для строки",
    },

    -- ─────────────────────────────────────────────────────────────
    -- LSP (AstroNvim style)
    -- ─────────────────────────────────────────────────────────────
    {
      "gd",
      function()
        Snacks.picker.lsp_definitions()
      end,
      desc = "Перейти к определению",
    },
    {
      "gr",
      function()
        Snacks.picker.lsp_references()
      end,
      desc = "Перейти к использованиям",
    },
    {
      "gI",
      function()
        Snacks.picker.lsp_implementations()
      end,
      desc = "Перейти к реализациям",
    },
    {
      "gy",
      function()
        Snacks.picker.lsp_type_definitions()
      end,
      desc = "Перейти к определению типа",
    },
    {
      "gO",
      function()
        Snacks.picker.lsp_symbols()
      end,
      desc = "Символы документа",
    },

    {
      "<leader>ls",
      function()
        local aerial_avail, aerial = pcall(require, "aerial")
        if aerial_avail and aerial.snacks_picker then
          aerial.snacks_picker()
        else
          Snacks.picker.lsp_symbols()
        end
      end,
      desc = "Символы документа",
    },
    {
      "<leader>lG",
      function()
        Snacks.picker.lsp_workspace_symbols()
      end,
      desc = "Символы рабочей области",
    },
    {
      "<leader>lD",
      function()
        Snacks.picker.diagnostics()
      end,
      desc = "Все диагностики",
    },

    -- ─────────────────────────────────────────────────────────────
    -- UI TOGGLES (AstroNvim style <leader>u)
    -- ─────────────────────────────────────────────────────────────
    {
      "<leader>uD",
      function()
        Snacks.notifier.hide()
      end,
      desc = "Скрыть уведомления",
    },
    {
      "<leader>u|",
      function()
        Snacks.toggle.indent():toggle()
      end,
      desc = "Переключить направляющие отступов",
    },
    {
      "<leader>uZ",
      function()
        Snacks.toggle.zen():toggle()
      end,
      desc = "Переключить режим zen",
    },

    -- ─────────────────────────────────────────────────────────────
    -- ТЕРМИНАЛ (AstroNvim style <leader>t)
    -- ─────────────────────────────────────────────────────────────
    {
      "<leader>tf",
      function()
        Snacks.terminal(nil, { win = { position = "float" } })
      end,
      desc = "Плавающий терминал",
    },
    {
      "<leader>th",
      function()
        Snacks.terminal(nil, { win = { position = "bottom", height = 0.3 } })
      end,
      desc = "Горизонтальный терминал",
    },
    {
      "<leader>tv",
      function()
        Snacks.terminal(nil, { win = { position = "right", width = 0.4 } })
      end,
      desc = "Вертикальный терминал",
    },
    {
      "<F7>",
      function()
        Snacks.terminal()
      end,
      desc = "Переключить терминал",
      mode = { "n", "t" },
    },
    {
      "<C-/>",
      function()
        Snacks.terminal()
      end,
      desc = "Переключить терминал",
      mode = { "n", "t" },
    },
    {
      "<C-'>",
      function()
        Snacks.terminal()
      end,
      desc = "Переключить терминал",
      mode = { "n", "t" },
    },
    {
      "<leader>tb",
      function()
        Snacks.terminal("btm", { win = { position = "float" } })
      end,
      desc = "Bottom (системный монитор)",
    },

    -- ─────────────────────────────────────────────────────────────
    -- БУФЕРЫ (AstroNvim style <leader>b)
    -- ─────────────────────────────────────────────────────────────
    {
      "<leader>bd",
      function()
        Snacks.bufdelete()
      end,
      desc = "Закрыть буфер",
    },
    {
      "<leader>bD",
      function()
        Snacks.bufdelete.all()
      end,
      desc = "Закрыть все буферы",
    },
    {
      "<leader>bo",
      function()
        Snacks.bufdelete.other()
      end,
      desc = "Закрыть остальные буферы",
    },

    -- ─────────────────────────────────────────────────────────────
    -- РАЗНОЕ
    -- ─────────────────────────────────────────────────────────────
    {
      "<leader>.",
      function()
        Snacks.scratch()
      end,
      desc = "Scratch-буфер",
    },
    {
      "<leader>S",
      function()
        Snacks.scratch.select()
      end,
      desc = "Выбрать scratch-буфер",
    },
    {
      "]]",
      function()
        Snacks.words.jump(vim.v.count1)
      end,
      desc = "Следующее вхождение",
      mode = { "n", "t" },
    },
    {
      "[[",
      function()
        Snacks.words.jump(-vim.v.count1)
      end,
      desc = "Предыдущее вхождение",
      mode = { "n", "t" },
    },
  },

  init = function()
    vim.api.nvim_create_autocmd("User", {
      pattern = "VeryLazy",
      callback = function()
        -- Глобальный доступ к Snacks
        _G.Snacks = require("snacks")

        -- Используем Snacks для vim.notify
        vim.notify = Snacks.notifier.notify

        -- Debug functions
        _G.dd = function(...)
          Snacks.debug.inspect(...)
        end
        _G.bt = function()
          Snacks.debug.backtrace()
        end
        vim.print = _G.dd

        -- UI Toggles (AstroNvim style)
        Snacks.toggle.option("spell", { name = "Проверка орфографии" }):map("<leader>us")
        Snacks.toggle.option("wrap", { name = "Перенос строк" }):map("<leader>uw")
        Snacks.toggle
          .option("relativenumber", { name = "Относительная нумерация" })
          :map("<leader>uL")
        Snacks.toggle.diagnostics():map("<leader>ud")
        Snacks.toggle.line_number():map("<leader>un")
        Snacks.toggle.treesitter():map("<leader>uT")
        Snacks.toggle.inlay_hints():map("<leader>uh")
        Snacks.toggle.dim():map("<leader>uD")

        -- Additional toggles
        Snacks.toggle
          .option("background", { off = "light", on = "dark", name = "Тёмный фон" })
          :map("<leader>ub")
      end,
    })
  end,
}
