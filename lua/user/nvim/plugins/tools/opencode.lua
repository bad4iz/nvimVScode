--[[
=============================================================================
                           OPENCODE.NVIM
=============================================================================
Интеграция OpenCode AI ассистента с Neovim.

Зависимости:
- snacks.nvim     - терминал, picker, input, UI
- blink.cmp       - автодополнение  
- render-markdown - рендеринг markdown ответов

Установка OpenCode CLI: 
  npm install -g @opencode/cli

Основной префикс хоткеев: <leader>o
=============================================================================
--]]

return {
  "NickvanDyke/opencode.nvim",
  dependencies = {
    "folke/snacks.nvim",
    "MeanderingProgrammer/render-markdown.nvim",
  },
  priority = 900, -- высокий приоритет для AI инструмента

  ---@type opencode.Opts
  opts = {
    -- ════════════════════════════════════════════════════════════════
    -- PROVIDER - Используем snacks.terminal (уже настроен)
    -- ════════════════════════════════════════════════════════════════
    provider = {
      enabled = "snacks",
      snacks = {
        -- Использует настройки из snacks.lua
        win = {
          position = "right",
          width = 0.4,
        },
      },
    },

    -- ════════════════════════════════════════════════════════════════
    -- UI НАСТРОЙКИ (AstroNvim стиль)
    -- ════════════════════════════════════════════════════════════════
    ui = {
      position = "right",              -- панель справа
      input_position = "bottom",        -- ввод внизу  
      window_width = 0.40,            -- 40% ширины редактора
      zoom_width = 0.8,               -- 80% при зуме
      input_height = 0.15,            -- 15% высоты для ввода
      display_model = true,             -- показывать модель
      display_context_size = true,        -- размер контекста
      display_cost = true,               -- стоимость запросов
      window_highlight = "Normal:OpencodeBackground,FloatBorder:OpencodeBorder",
      
      -- Иконки в стиле Nerdfont (соответствует теме)
      icons = {
        preset = "nerdfonts",
        overrides = {
          header_user = "  ",
          header_assistant = "🤖 ",
          run = " ",
          task = " ",
          read = " ",
          edit = " ",
          write = " ",
          plan = " ",
          search = " ",
          web = " ",
          list = " ",
          tool = " ",
          snapshot = " ",
          restore_point = " ",
          restore_count = " ",
          file = " ",
          status_on = " ",
          status_off = " ",
          border = "│",
          bullet = "•",
        },
      },
      
      output = {
        tools = {
          show_output = true,           -- показывать вывод инструментов
          show_reasoning_output = true,  -- показывать ход мыслей
        },
        rendering = {
          markdown_debounce_ms = 250,   -- дебаунс рендеринга
          on_data_rendered = false,     -- отключаем авто-поведение
        },
      },
      
      input = {
        text = {
          wrap = false,                -- без переноса строк
        },
      },
    },

    -- ════════════════════════════════════════════════════════════════
    -- КОНТЕКСТ (автоматический сбор информации)
    -- ════════════════════════════════════════════════════════════════
    context = {
      enabled = true,                  -- включить контекст
      cursor_data = {
        enabled = true,               -- позиция курсора
        context_lines = 5,            -- +-5 строк вокруг курсора
      },
      diagnostics = {
        info = false,                  -- игнорировать info диагностику
        warn = true,                  -- предупреждения включить
        error = true,                 -- ошибки включить
        only_closest = false,          -- вся диагностика файла
      },
      current_file = {
        enabled = true,               -- текущий файл
        show_full_path = true,         -- полный путь
      },
      files = {
        enabled = true,               -- упомянутые файлы
        show_full_path = true,
      },
      selection = {
        enabled = true,               -- выделенный текст
      },
      buffer = {
        enabled = false,              -- весь буфер (только для быстрого чата)
      },
      git_diff = {
        enabled = true,               -- git изменения
      },
    },

    -- ════════════════════════════════════════════════════════════════
    -- ЗАВЕРШЕНИЕ ФАЙЛОВ
    -- ════════════════════════════════════════════════════════════════
    completion = {
      file_sources = {
        enabled = true,
        preferred_cli_tool = "server",   -- использовать opencode server
        ignore_patterns = {
          "%.git/", "%.svn/", "%.hg/",
          "node_modules/", "%.pyc$", "%.o$", "%.obj$", 
          "%.exe$", "%.dll$", "%.so$", "%.dylib$",
          "%.class$", "%.jar$", "%.war$", "%.ear$",
          "target/", "build/", "dist/", "out/", "deps/",
          "%.tmp$", "%.temp$", "%.log$", "%.cache$",
        },
        max_files = 10,
        max_display_length = 50,
      },
    },

    -- ════════════════════════════════════════════════════════════════
    -- НАСТРОЙКИ ДЕБАГА
    -- ════════════════════════════════════════════════════════════════
    debug = {
      enabled = false,                 -- отключить дебаг
      capture_streamed_events = false,
      show_ids = true,
      quick_chat = {
        keep_session = false,
        set_active_session = false,
      },
    },

    -- ════════════════════════════════════════════════════════════════
    -- HOOKS (кастомизация событий)
    -- ════════════════════════════════════════════════════════════════
    hooks = {
      on_file_edited = nil,           -- после редактирования файла
      on_session_loaded = nil,         -- после загрузки сессии
      on_done_thinking = nil,         -- после завершения мышления
      on_permission_requested = nil,    -- при запросе прав
    },

    -- ════════════════════════════════════════════════════════════════
    -- БЫСТРЫЙ ЧАТ
    -- ════════════════════════════════════════════════════════════════
    quick_chat = {
      default_model = nil,            -- использовать текущую модель
      default_agent = "plan",          -- plan режим (без изменений)
      instructions = nil,              -- встроенные инструкции
    },
  },

  -- ════════════════════════════════════════════════════════════════
  -- ГОРЯЧИЕ КЛАВИШИ (AstroNvim стиль)
  -- ════════════════════════════════════════════════════════════════
  keys = {
    -- ════════════════════════════════════════════════════════════════
    -- ГЛОБАЛЬНЫЕ ХОТКЕИ (editor)
    -- ════════════════════════════════════════════════════════════════
    {
      "<leader>o",
      nil,
      desc = "OpenCode",
      icon = " ",
    },

    -- Основное управление
    {
      "<leader>og",
      function() require("opencode").toggle() end,
      desc = "Toggle OpenCode",
    },
    {
      "<leader>oi", 
      function() require("opencode.api").open_input() end,
      desc = "Open input (current session)",
    },
    {
      "<leader>oI",
      function() require("opencode.api").open_input_new_session() end,
      desc = "Open input (new session)",
    },
    {
      "<leader>oo",
      function() require("opencode.api").open_output() end,
      desc = "Open output window",
    },
    {
      "<leader>ot",
      function() require("opencode.api").toggle_focus() end,
      desc = "Toggle focus OpenCode/editor",
    },
    {
      "<leader>oq",
      function() require("opencode.api").close() end,
      desc = "Close OpenCode",
    },

    -- Управление сессиями
    {
      "<leader>os",
      function() require("opencode.api").select_session() end,
      desc = "Select session",
    },
    {
      "<leader>oR",
      function() require("opencode.api").rename_session() end,
      desc = "Rename session",
    },
    {
      "<leader>oS", 
      function() require("opencode.api").select_child_session() end,
      desc = "Select child session",
    },

    -- Модели и агенты
    {
      "<leader>op",
      function() require("opencode.api").configure_provider() end,
      desc = "Configure provider/model",
    },
    {
      "<leader>oV",
      function() require("opencode.api").configure_variant() end,
      desc = "Configure model variant",
    },

    -- UI и навигация
    {
      "<leader>oz",
      function() require("opencode.api").toggle_zoom() end,
      desc = "Toggle zoom",
    },
    {
      "<leader>ox",
      function() require("opencode.api").swap_position() end,
      desc = "Swap pane position",
    },

    -- Дифф и изменения
    {
      "<leader>od",
      function() require("opencode.api").diff_open() end,
      desc = "Open diff view",
    },
    {
      "<leader>o]",
      function() require("opencode.api").diff_next() end,
      desc = "Next diff",
    },
    {
      "<leader>o[",
      function() require("opencode.api").diff_prev() end,
      desc = "Previous diff",
    },
    {
      "<leader>oc",
      function() require("opencode.api").diff_close() end,
      desc = "Close diff view",
    },

    -- Откат изменений
    {
      "<leader>ora",
      function() require("opencode.api").diff_revert_all_last_prompt() end,
      desc = "Revert all (last prompt)",
    },
    {
      "<leader>ort", 
      function() require("opencode.api").diff_revert_this_last_prompt() end,
      desc = "Revert this (last prompt)",
    },
    {
      "<leader>orA",
      function() require("opencode.api").diff_revert_all_session() end,
      desc = "Revert all (session)",
    },
    {
      "<leader>orT",
      function() require("opencode.api").diff_revert_this_session() end,
      desc = "Revert this (session)",
    },
    {
      "<leader>orr",
      function() require("opencode.api").diff_restore_snapshot_file() end,
      desc = "Restore snapshot file",
    },
    {
      "<leader>orR", 
      function() require("opencode.api").diff_restore_snapshot_all() end,
      desc = "Restore snapshot all",
    },

    -- Media и команды
    {
      "<leader>ov",
      function() require("opencode.api").paste_image() end,
      desc = "Paste image",
    },
    {
      "<leader>ott",
      function() require("opencode.api").toggle_tool_output() end,
      desc = "Toggle tool output",
    },
    {
      "<leader>otr",
      function() require("opencode.api").toggle_reasoning_output() end,
      desc = "Toggle reasoning output",
    },

    -- Permission requests
    {
      "<leader>opa",
      function() require("opencode.api").permission_accept() end,
      desc = "Accept permission (once)",
    },
    {
      "<leader>opA",
      function() require("opencode.api").permission_accept_all() end,
      desc = "Accept permission (all)",
    },
    {
      "<leader>opd",
      function() require("opencode.api").permission_deny() end,
      desc = "Deny permission",
    },

    -- Быстрый чат
    {
      "<leader>o/",
      function() require("opencode.api").quick_chat() end,
      desc = "Quick chat with selection/line",
      mode = { "n", "x" },
    },

    -- Дополнительные команды
    {
      "<leader>oT",
      function() require("opencode.api").timeline() end,
      desc = "Timeline (undo/redo/fork)",
    },
    {
      "<leader>od", 
      function() require("opencode.api").references() end,
      desc = "Browse code references",
    },
    {
      "<leader>om",
      function() require("opencode.api").run_user_command() end,
      desc = "Run user command",
    },

    -- Vim операторы (не конфликтующие с vim операциями)
    {
      "go",
      function() return require("opencode").operator("@this ") end,
      desc = "Add range to OpenCode",
      expr = true,
    },
    {
      "goo",
      function() return require("opencode").operator("@this ") .. "_" end,
      desc = "Add line to OpenCode", 
      expr = true,
    },

    -- Альтернативные хоткеи (без конфликтов)
    {
      "<C-.>",
      function() require("opencode").toggle() end,
      desc = "Toggle OpenCode (alternative)",
      mode = { "n", "t" },
    },
    {
      "<A-a>",
      function() require("opencode").ask("@this: ", { submit = true }) end,
      desc = "Ask OpenCode (@this)",
      mode = { "n", "x" },
    },
    {
      "<A-x>",
      function() require("opencode").select() end,
      desc = "Execute OpenCode action",
      mode = { "n", "x" },
    },

    -- Прокрутка (как в документации)
    {
      "<S-C-u>",
      function() require("opencode").command("session.half.page.up") end,
      desc = "Scroll OpenCode up",
    },
    {
      "<S-C-d>",
      function() require("opencode").command("session.half.page.down") end,
      desc = "Scroll OpenCode down",
    },
  },

  -- ════════════════════════════════════════════════════════════════
  -- КОНФИГУРАЦИЯ ОКНА ВВОДА (input_window)
  -- ════════════════════════════════════════════════════════════════
  config = function(_, opts)
    -- Устанавливаем опции для всех окон
    vim.g.opencode_opts = opts

    -- Включаем autoread для авто-перезагрузки измененных файлов
    vim.o.autoread = true

    -- Настройка highlight групп
    vim.api.nvim_create_autocmd("ColorScheme", {
      callback = function()
        vim.api.nvim_set_hl(0, "OpencodeBackground", { bg = vim.tbl_get(vim.api.nvim_get_hl(0, "Normal"), "bg", "#000000") })
        vim.api.nvim_set_hl(0, "OpencodeBorder", { fg = "#61afef" })
      end,
    })
  end,
}