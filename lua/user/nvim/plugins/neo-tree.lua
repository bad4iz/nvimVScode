--[[
=====================================================================
                    NEO-TREE - ФАЙЛОВЫЙ МЕНЕДЖЕР
=====================================================================

Neo-tree.nvim - современный файловый менеджер для Neovim с поддержкой:
- Git статуса и операций
- LSP диагностики
- Древовидной навигации
- Буферов и символов документа
- Иконок из Nerd Font

=====================================================================
                        ОСНОВНЫЕ ГОРЯЧИЕ КЛАВИШИ
=====================================================================

ГЛОБАЛЬНЫЕ (работают везде в Neovim):
  <leader>e     - Toggle файловый менеджер
  <leader>o     - Фокус на файловом менеджере
  <leader>E     - Показать текущий файл в дереве

  ИСТОЧНИКИ ДАННЫХ (быстрый доступ):
  <leader>ef    - Neo-tree: Файлы (filesystem)
  <leader>eb    - Neo-tree: Буферы (buffers)
  <leader>eg    - Neo-tree: Git статус
  <leader>es    - Neo-tree: Символы документа (LSP)

В ОКНЕ NEO-TREE:

  НАВИГАЦИЯ:
  <CR> / l      - Открыть файл или раскрыть папку
  h             - Свернуть папку
  <Space>       - Toggle узел (раскрыть/свернуть)
  <C-v>         - Открыть в вертикальном сплите
  <C-x>         - Открыть в горизонтальном сплите
  <C-t>         - Открыть в новой вкладке

  ФАЙЛОВЫЕ ОПЕРАЦИИ:
  a             - Создать новый файл/папку (/ в конце для папки)
  d             - Удалить файл/папку
  r             - Переименовать
  y             - Копировать в буфер обмена
  x             - Вырезать
  p             - Вставить из буфера
  c             - Копировать файл (для перемещения)
  m             - Переместить файл

  ПРОСМОТР:
  z             - Свернуть все папки
  Z             - Развернуть все папки
  R             - Обновить дерево
  ?             - Показать справку
  q             - Закрыть Neo-tree

  GIT:
  gu            - Git unstage
  ga            - Git add
  gr            - Git revert

  ДРУГОЕ:
  .             - Toggle скрытые файлы
  H             - Toggle скрытые файлы
  /             - Фильтр файлов
  <Esc>         - Очистить фильтр

=====================================================================
                          ИСТОЧНИКИ (SOURCES)
=====================================================================

Neo-tree поддерживает несколько источников данных:
  - filesystem       - Файловая система (основной)
  - buffers         - Открытые буферы
  - git_status      - Git статус файлов
  - document_symbols - Символы документа (LSP)

Переключение между источниками: < и >

=====================================================================
--]]
return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons", -- Иконки из Nerd Font
    "MunifTanjim/nui.nvim",        -- UI компоненты
  },

  -- Горячие клавиши (загружаются вместе с плагином)
  keys = {
    -- Основные команды
    { "<leader>e", "<cmd>Neotree toggle<CR>", desc = "Toggle файловый менеджер" },
    { "<leader>o", "<cmd>Neotree focus<CR>", desc = "Фокус на файловом менеджере" },
    { "<leader>E", "<cmd>Neotree reveal<CR>", desc = "Найти текущий файл в дереве" },

    -- Источники данных (Sources) - группа <leader>e
    { "<leader>ef", "<cmd>Neotree filesystem<CR>", desc = "Neo-tree: Файлы" },
    { "<leader>eb", "<cmd>Neotree buffers<CR>", desc = "Neo-tree: Буферы" },
    { "<leader>eg", "<cmd>Neotree git_status<CR>", desc = "Neo-tree: Git статус" },
    { "<leader>es", "<cmd>Neotree document_symbols<CR>", desc = "Neo-tree: Символы документа" },

    -- Альтернативные команды (для совместимости)
    { "<leader>be", "<cmd>Neotree buffers right<CR>", desc = "Буферы справа" },
    { "<leader>ge", "<cmd>Neotree float git_status<CR>", desc = "Git статус (floating)" },
  },

  opts = {
    -- =====================================================================
    -- ОСНОВНЫЕ НАСТРОЙКИ
    -- =====================================================================

    -- Закрывать Neo-tree если это последнее окно
    close_if_last_window = false,

    -- Стиль границы окна (пустая строка для winborder на Neovim v0.11+)
    popup_border_style = "rounded",

    -- Включить интеграцию с Git
    enable_git_status = true,

    -- Включить отображение LSP диагностики
    enable_diagnostics = true,

    -- При открытии файлов не заменять эти типы окон
    open_files_do_not_replace_types = {
      "terminal",
      "trouble",
      "qf",
      "Outline",
      "snacks_dashboard",
    },

    -- Использовать относительные пути при открытии файлов
    open_files_using_relative_paths = false,

    -- Сортировка без учета регистра
    sort_case_insensitive = false,

    -- =====================================================================
    -- ИСТОЧНИКИ ДАННЫХ (SOURCES)
    -- =====================================================================

    -- Доступные источники данных
    sources = {
      "filesystem",      -- Файловая система (основной)
      "buffers",         -- Открытые буферы
      "git_status",      -- Git статус файлов
      "document_symbols",-- Символы документа (LSP)
    },

    -- Панель переключения между источниками
    source_selector = {
      winbar = true,              -- Показывать в winbar (верхняя панель окна)
      statusline = false,         -- Не показывать в statusline
      show_scrolled_off_parent_node = false,

      sources = {
        { source = "filesystem", display_name = " 󰉋 Files " },      -- Файлы
        { source = "buffers", display_name = " 󰈚 Buffers " },       -- Буферы
        { source = "git_status", display_name = " 󰊢 Git " },        -- Git
        { source = "document_symbols", display_name = " 󰌗 Symbols " }, -- Символы
      },

      content_layout = "start",   -- Расположение: "start", "end", "center"
      tabs_layout = "equal",      -- Размер табов: "equal", "focus", "active"
      truncation_character = "…",
      tabs_min_width = nil,
      tabs_max_width = nil,
      padding = 0,
      separator = { left = "▏", right = "▕" },
      separator_active = nil,
      show_separator_on_edge = false,
      highlight_tab = "NeoTreeTabInactive",
      highlight_tab_active = "NeoTreeTabActive",
      highlight_background = "NeoTreeTabInactive",
      highlight_separator = "NeoTreeTabSeparatorInactive",
      highlight_separator_active = "NeoTreeTabSeparatorActive",
    },

    -- =====================================================================
    -- КОНФИГУРАЦИЯ КОМПОНЕНТОВ ПО УМОЛЧАНИЮ
    -- =====================================================================

    default_component_configs = {
      -- Контейнер элементов
      container = {
        enable_character_fade = true,
      },

      -- Отступы и направляющие линии
      indent = {
        indent_size = 2,
        padding = 1, -- дополнительный отступ слева

        -- Направляющие линии для отступов
        with_markers = true,
        indent_marker = "│",
        last_indent_marker = "└",
        highlight = "NeoTreeIndentMarker",

        -- Раскрывающиеся элементы для вложенных файлов
        with_expanders = nil, -- автоматически включается при вложенности файлов
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },

      -- Иконки файлов и папок (Nerd Font)
      icon = {
        folder_closed = "",  -- nf-fa-folder
        folder_open = "",    -- nf-fa-folder_open
        folder_empty = "",   -- nf-fa-folder_o (пустая папка)
        folder_empty_open = "", -- nf-fa-folder_open_o

        -- Провайдер иконок использует nvim-web-devicons
        provider = function(icon, node, state)
          if node.type == "file" or node.type == "terminal" then
            local success, web_devicons = pcall(require, "nvim-web-devicons")
            local name = node.type == "terminal" and "terminal" or node.name
            if success then
              local devicon, hl = web_devicons.get_icon(name)
              icon.text = devicon or icon.text
              icon.highlight = hl or icon.highlight
            end
          end
        end,

        -- Иконка по умолчанию для неизвестных файлов
        default = "*",
        highlight = "NeoTreeFileIcon",
      },

      -- Индикатор измененных файлов
      modified = {
        symbol = "[+]",
        highlight = "NeoTreeModified",
      },

      -- Имя файла/папки
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },

      -- Git статус символы (универсальные, работают везде)
      git_status = {
        symbols = {
          -- Типы изменений (Change type)
          added     = "",  -- U+271A - Новый файл
          modified  = "",  -- U+2731 - Изменен
          deleted   = "",  -- U+2716 - Удален
          renamed   = "",  -- U+279C - Переименован

          -- Статусы (Status type)
          untracked = "",  -- U+2605 - Не отслеживается
          ignored   = "",  -- U+25CC - Игнорируется
          unstaged  = "✗",  -- U+2717 - Не в staging
          staged    = "",  -- U+2713 - В staging
          conflict  = "",  -- U+26A0 - Конфликт

          -- Альтернативы (раскомментируйте если хотите простые буквы):
          -- added     = "A",
          -- modified  = "M",
          -- deleted   = "D",
          -- renamed   = "R",
          -- untracked = "U",
          -- ignored   = "I",
          -- unstaged  = "○",
          -- staged    = "●",
          -- conflict  = "!",
        },
      },

      -- Размер файла (опционально)
      file_size = {
        enabled = true,
        width = 12,
        required_width = 64, -- минимальная ширина окна для отображения
      },

      -- Тип файла (опционально)
      type = {
        enabled = true,
        width = 10,
        required_width = 122,
      },

      -- Дата последнего изменения (опционально)
      last_modified = {
        enabled = true,
        width = 20,
        required_width = 88,
      },

      -- Дата создания (опционально)
      created = {
        enabled = true,
        width = 20,
        required_width = 110,
      },

      -- Цель символической ссылки
      symlink_target = {
        enabled = false,
      },
    },

    -- =====================================================================
    -- НАСТРОЙКИ ОКНА
    -- =====================================================================

    window = {
      position = "left",  -- Позиция: left, right, float, current
      width = 35,         -- Ширина окна

      -- Опции маппинга
      mapping_options = {
        noremap = true,
        nowait = true,
      },

      -- Маппинги внутри окна Neo-tree
      mappings = {
        -- =====================================================================
        -- НАВИГАЦИЯ
        -- =====================================================================
        ["<space>"] = "toggle_node",
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["l"] = "open",
        ["h"] = "close_node",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",

        -- =====================================================================
        -- ОТКРЫТИЕ В РАЗНЫХ ОКНАХ
        -- =====================================================================
        ["<C-v>"] = "open_vsplit",
        ["<C-x>"] = "open_split",
        ["<C-t>"] = "open_tabnew",
        ["<C-w>"] = "open_with_window_picker",

        -- =====================================================================
        -- ФАЙЛОВЫЕ ОПЕРАЦИИ
        -- =====================================================================
        ["a"] = {
          "add",
          config = {
            show_path = "none", -- "none" - только имя, "relative" - относительный путь, "absolute" - полный путь
          }
        },
        ["A"] = {
          "add_directory",
          config = {
            show_path = "none", -- Чистое поле, только название директории
          }
        },
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy", -- Копировать файл (для перемещения)
        ["m"] = "move", -- Переместить в другое место

        -- =====================================================================
        -- БУФЕР ОБМЕНА И МЕТКИ
        -- =====================================================================
        ["bd"] = "buffer_delete",
        ["ma"] = "toggle_mark",
        ["mc"] = "clear_marks",
        ["mf"] = "mark_all_files",
        ["md"] = "mark_all_directories",

        -- =====================================================================
        -- ОТОБРАЖЕНИЕ И ФИЛЬТРЫ
        -- =====================================================================
        ["."] = "toggle_hidden",
        ["H"] = "toggle_hidden",
        ["/"] = "filter_on_submit",
        ["D"] = "filter_on_submit",
        ["<c-c>"] = "clear_filter",
        ["<esc>"] = "clear_filter",

        -- =====================================================================
        -- GIT
        -- =====================================================================
        ["ga"] = "git_add_file",
        ["gu"] = "git_unstage_file",
        ["gr"] = "git_revert_file",
        ["gc"] = "git_commit",
        ["gp"] = "git_push",
        ["gg"] = "git_commit_and_push",

        -- =====================================================================
        -- НАВИГАЦИЯ ПО ИСТОЧНИКАМ
        -- =====================================================================
        ["<"] = "prev_source",
        [">"] = "next_source",

        -- =====================================================================
        -- ДРУГОЕ
        -- =====================================================================
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["q"] = "close_window",
        ["<BS>"] = "navigate_up",
        ["i"] = "show_file_details",
        ["o"] = { "show_help", nowait = false, config = { title = "Order by", prefix_key = "o" } },
        ["oc"] = { "order_by_created", nowait = false },
        ["od"] = { "order_by_diagnostics", nowait = false },
        ["og"] = { "order_by_git_status", nowait = false },
        ["om"] = { "order_by_modified", nowait = false },
        ["on"] = { "order_by_name", nowait = false },
        ["os"] = { "order_by_size", nowait = false },
        ["ot"] = { "order_by_type", nowait = false },
      },
    },

    -- =====================================================================
    -- ФАЙЛОВАЯ СИСТЕМА (FILESYSTEM SOURCE)
    -- =====================================================================

    filesystem = {
      -- Следовать за текущим файлом
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },

      -- Использовать libuv file watcher для лучшей производительности
      use_libuv_file_watcher = true,

      -- Группировать пустые директории в один узел
      group_empty_dirs = false,

      -- Привязать к текущей рабочей директории
      bind_to_cwd = false,

      -- Поведение при hijack netrw
      hijack_netrw_behavior = "open_default", -- "open_current", "disabled"

      -- Фильтрация файлов
      filtered_items = {
        visible = false, -- Показывать отфильтрованные элементы серым
        hide_dotfiles = true,
        hide_gitignored = true,
        hide_hidden = true, -- Скрывать только файлы со специальным атрибутом hidden (Windows)

        hide_by_name = {
          "node_modules",
          ".git",
          ".DS_Store",
          "thumbs.db",
        },

        hide_by_pattern = {
          -- "*.meta",
          -- "*/src/*/tsconfig.json",
        },

        always_show = { -- Всегда показывать
          -- ".gitignored",
        },

        never_show = { -- Никогда не показывать
          -- ".DS_Store",
          -- "thumbs.db",
        },

        never_show_by_pattern = { -- Никогда не показывать по паттерну
          -- ".null-ls_*",
        },
      },

      -- Команды для файловой системы
      commands = {},

      -- Настройки окна файловой системы
      window = {
        mappings = {
          -- Дополнительные маппинги только для filesystem
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter", -- fuzzy сортировка по префиксу #
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
        },

        fuzzy_finder_mappings = { -- Маппинги для fuzzy finder
          ["<down>"] = "move_cursor_down",
          ["<C-n>"] = "move_cursor_down",
          ["<up>"] = "move_cursor_up",
          ["<C-p>"] = "move_cursor_up",
        },
      },
    },

    -- =====================================================================
    -- БУФЕРЫ (BUFFERS SOURCE)
    -- =====================================================================

    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = false,
      },
      group_empty_dirs = true,
      show_unloaded = true,

      window = {
        mappings = {
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
        },
      },
    },

    -- =====================================================================
    -- GIT СТАТУС (GIT_STATUS SOURCE)
    -- =====================================================================

    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"]  = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
        },
      },
    },

    -- =====================================================================
    -- СИМВОЛЫ ДОКУМЕНТА (DOCUMENT_SYMBOLS SOURCE)
    -- =====================================================================

    document_symbols = {
      follow_cursor = false,
      client_filters = "first",
      renderers = {
        root = {
          {"indent"},
          {"icon", default = "C" },
          {"name", zindex = 10},
        },
        symbol = {
          {"indent", with_expanders = true},
          {"kind_icon", default = "?"},
          {"container", content = {
            {"name", zindex = 10},
            {"kind_name", zindex = 20, align = "right"},
          }}
        },
      },
      window = {
        mappings = {
          ["<cr>"] = "jump_to_symbol",
          ["o"] = "jump_to_symbol",
          ["A"] = "noop", -- Отключить добавление в symbols
          ["d"] = "noop", -- Отключить удаление в symbols
          ["r"] = "noop", -- Отключить переименование в symbols
          ["y"] = "noop",
          ["x"] = "noop",
          ["p"] = "noop",
          ["c"] = "noop",
          ["m"] = "noop",
          ["a"] = "noop",
        },
      },
      kinds = {
        -- LSP символы с иконками Nerd Font
        Unknown = { icon = "?", hl = "" },
        Root = { icon = "󰙅", hl = "NeoTreeRootName" },
        File = { icon = "󰈔", hl = "Tag" },
        Module = { icon = "", hl = "Exception" },
        Namespace = { icon = "󰌗", hl = "Include" },
        Package = { icon = "󰏖", hl = "Label" },
        Class = { icon = "󰌗", hl = "Include" },
        Method = { icon = "", hl = "Function" },
        Property = { icon = "󰆧", hl = "@property" },
        Field = { icon = "󰆧", hl = "@field" },
        Constructor = { icon = "", hl = "@constructor" },
        Enum = { icon = "󰕘", hl = "@number" },
        Interface = { icon = "", hl = "Type" },
        Function = { icon = "󰊕", hl = "Function" },
        Variable = { icon = "󰀫", hl = "@variable" },
        Constant = { icon = "󰏿", hl = "Constant" },
        String = { icon = "󰀬", hl = "String" },
        Number = { icon = "󰎠", hl = "Number" },
        Boolean = { icon = "", hl = "Boolean" },
        Array = { icon = "󰅪", hl = "Type" },
        Object = { icon = "󰅩", hl = "Type" },
        Key = { icon = "󰌋", hl = "" },
        Null = { icon = "󰟢", hl = "Constant" },
        EnumMember = { icon = "", hl = "Number" },
        Struct = { icon = "󰌗", hl = "Type" },
        Event = { icon = "", hl = "Constant" },
        Operator = { icon = "󰆕", hl = "Operator" },
        TypeParameter = { icon = "󰊄", hl = "Type" },

        -- Дополнительные типы для ccls
        TypeAlias = { icon = "󰊄", hl = "Type" },
        Parameter = { icon = "󰆧", hl = "@parameter" },
        StaticMethod = { icon = "", hl = "Function" },
        Macro = { icon = "", hl = "Macro" },
      },
    },

    -- =====================================================================
    -- ОБРАБОТЧИКИ СОБЫТИЙ
    -- =====================================================================

    event_handlers = {
      -- Выравнивание окон при открытии Neo-tree
      {
        event = "neo_tree_window_after_open",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
        end,
      },

      -- Выравнивание окон при закрытии Neo-tree
      {
        event = "neo_tree_window_after_close",
        handler = function(args)
          if args.position == "left" or args.position == "right" then
            vim.cmd("wincmd =")
          end
        end,
      },

      -- Закрывать dashboard только при открытии файла
      {
        event = "file_opened",
        handler = function(file_path)
          -- Безопасное закрытие dashboard с задержкой
          vim.schedule(function()
            for _, win in ipairs(vim.api.nvim_list_wins()) do
              -- Проверяем что окно все еще валидно
              if vim.api.nvim_win_is_valid(win) then
                local buf = vim.api.nvim_win_get_buf(win)
                local ft = vim.bo[buf].filetype

                if ft == "snacks_dashboard" or ft == "alpha" or ft == "dashboard" then
                  -- Безопасное закрытие с pcall
                  pcall(vim.api.nvim_buf_delete, buf, { force = false })
                end
              end
            end
          end)
        end,
      },
    },
  },
}
