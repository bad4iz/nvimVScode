---@diagnostic disable-next-line: undefined-global
local vim = vim
--[[
=====================================================================
                        BUFFERLINE
=====================================================================
Красивая строка табов/буферов в стиле современных редакторов.

Структура таба:
┌─────────────────────────────────────────────────────────────────────┐
│ fill (фон пустого пространства)                                     │
│  ┌──────────────┬──────────────┬──────────────┬──────────────┐     │
│  │▎ 1 file.lua  │▎ 2 init.lua  │▎ 3 test.lua ●│  ← trunc     │     │
│  │  (inactive)  │  (selected)  │  (modified)  │              │     │
│  └──────────────┴──────────────┴──────────────┴──────────────┘     │
│   ↑  ↑    ↑           ↑              ↑                              │
│   │  │    │       indicator      modified_icon                      │
│   │  │    └── buffer (имя файла)                                    │
│   │  └── numbers (порядковый номер)                                 │
│   └── separator (разделитель)                                       │
└─────────────────────────────────────────────────────────────────────┘

Три состояния для каждого элемента:
  - без суффикса  = неактивный буфер (открыт, но не виден)
  - _visible      = видимый в другом сплите
  - _selected     = текущий активный буфер

Горячие клавиши:
  <S-h>       - предыдущий буфер
  <S-l>       - следующий буфер
  <leader>bp  - закрепить буфер
  <leader>bP  - удалить незакреплённые буферы
  <leader>bo  - закрыть все кроме текущего
  <leader>br  - буферы справа
  <leader>bl  - буферы слева

Клик мышью:
  - ЛКМ на таб - переключиться
  - СКМ на таб - закрыть
  - Колёсико - прокрутка табов

GitHub: https://github.com/akinsho/bufferline.nvim
=====================================================================
--]]

return {
  "akinsho/bufferline.nvim",

  -- VeryLazy = загрузка после старта UI (не блокирует запуск)
  event = "VeryLazy",

  -- nvim-web-devicons = иконки файлов (требует Nerd Font)
  dependencies = { "nvim-tree/nvim-web-devicons" },

  config = function()
    require("bufferline").setup({
      options = {
        --[[
        ═══════════════════════════════════════════════════════════════
                              РЕЖИМ ОТОБРАЖЕНИЯ
        ═══════════════════════════════════════════════════════════════
        --]]

        -- "buffers" = показывать открытые буферы (файлы)
        -- "tabs"    = показывать vim табы (:tabnew)
        -- Буферы — это файлы в памяти, табы — это layouts окон
        mode = "buffers",

        --[[
        ═══════════════════════════════════════════════════════════════
                                   СТИЛЬ
        ═══════════════════════════════════════════════════════════════
        --]]

        -- Готовые пресеты стилей:
        -- .default    — стандартный с разделителями
        -- .minimal    — минимальный без разделителей
        -- .no_italic  — без курсива
        -- .no_bold    — без жирного текста
        style_preset = require("bufferline").style_preset.default,

        -- true = можно переопределять цвета через секцию highlights
        -- false = используются жёсткие цвета плагина
        themable = true,

        --[[
        ═══════════════════════════════════════════════════════════════
                           ИКОНКИ (Nerd Font)
        ═══════════════════════════════════════════════════════════════
        Требуется Nerd Font для корректного отображения!
        Проверить шрифт: :echo &guifont или в терминале
        --]]

        buffer_close_icon = "󰅖", -- Кнопка × на каждом табе
        modified_icon = "", -- Точка для изменённых файлов (несохранённых)
        close_icon = "X", -- Кнопка закрытия справа всего bufferline
        left_trunc_marker = "<<", -- Стрелка "есть скрытые табы слева"
        right_trunc_marker = ">>", -- Стрелка "есть скрытые табы справа"

        --[[
        ═══════════════════════════════════════════════════════════════
                             НОМЕРА БУФЕРОВ
        ═══════════════════════════════════════════════════════════════
        --]]

        -- Функция для отображения номера буфера
        -- opts.ordinal = порядковый номер в bufferline (1, 2, 3...)
        -- opts.id      = реальный номер буфера vim (:ls показывает их)
        -- opts.lower   = римские цифры (i, ii, iii...)
        -- opts.raise   = римские заглавные (I, II, III...)
        -- Можно комбинировать: opts.ordinal .. "." .. opts.id → "1.5"
        numbers = function(opts)
          return string.format("%s", opts.ordinal)
        end,

        --[[
        ═══════════════════════════════════════════════════════════════
                            ЗАКРЫТИЕ БУФЕРОВ
        ═══════════════════════════════════════════════════════════════
        --]]

        -- Команда при клике на кнопку закрытия (×)
        -- Используем snacks.bufdelete если доступен (сохраняет layout окон)
        -- Иначе стандартный :bdelete
        close_command = function(n)
          local ok, snacks = pcall(require, "snacks")
          if ok then
            snacks.bufdelete(n)
          else
            vim.cmd("bdelete! " .. n)
          end
        end,

        -- Команда при клике правой кнопкой мыши
        -- Такое же поведение как close_command
        right_mouse_command = function(n)
          local ok, snacks = pcall(require, "snacks")
          if ok then
            snacks.bufdelete(n)
          else
            vim.cmd("bdelete! " .. n)
          end
        end,

        --[[
        ═══════════════════════════════════════════════════════════════
                         ИНДИКАТОР АКТИВНОГО ТАБА
        ═══════════════════════════════════════════════════════════════
        --]]

        indicator = {
          icon = "", -- Символ индикатора (вертикальная полоска слева)
          -- Стили индикатора:
          -- "icon"      = показать иконку (▎)
          -- "underline" = подчеркнуть активный таб
          -- "none"      = без индикатора
          style = "none",
        },

        --[[
        ═══════════════════════════════════════════════════════════════
                            РАЗМЕРЫ И ОБРЕЗКА
        ═══════════════════════════════════════════════════════════════
        --]]

        max_name_length = 30, -- Максимальная длина имени файла
        max_prefix_length = 30, -- Максимальная длина префикса (путь для дубликатов)
        truncate_names = true, -- Обрезать длинные имена с ...
        tab_size = 11, -- Минимальная ширина таба в символах

        --[[
        ═══════════════════════════════════════════════════════════════
                           ДИАГНОСТИКА LSP
        ═══════════════════════════════════════════════════════════════
        Показывает ошибки/предупреждения прямо на табе
        --]]

        -- Источник диагностики:
        -- "nvim_lsp" = встроенный LSP
        -- "coc"      = coc.nvim
        -- false      = отключить
        diagnostics = "nvim_lsp",

        -- Обновлять диагностику в insert mode?
        -- false = обновлять только при выходе из insert (меньше мерцания)
        diagnostics_update_in_insert = false,
        -- Функция для форматирования индикатора диагностики
        -- count = количество проблем
        -- level = "error" | "warning" | "info" | "hint"
        diagnostics_indicator = function(count, level)
          local icons = {

            error = "", -- Ошибка
            warning = "", -- Предупреждение
            hint = "󰌵", -- Подсказка
            info = "i", -- Информация
          }
          return "| " .. (icons[level] or "") .. " " .. count
        end,

        --[[
        ═══════════════════════════════════════════════════════════════
                    OFFSETS — ОТСТУПЫ ДЛЯ БОКОВЫХ ПАНЕЛЕЙ
        ═══════════════════════════════════════════════════════════════
        Сдвигает bufferline чтобы не перекрывать neo-tree и подобные
        --]]

        offsets = {
          {
            filetype = "neo-tree", -- Тип файла боковой панели
            text = "󰉓  Файлы", -- Текст заголовка вместо таба
            text_align = "center", -- "left" | "center" | "right"
            separator = true, -- Показать вертикальный разделитель
            highlight = "Directory", -- Highlight группа для цвета текста
          },
        },

        --[[
        ═══════════════════════════════════════════════════════════════
                              РАЗДЕЛИТЕЛИ
        ═══════════════════════════════════════════════════════════════
        --]]

        -- Стили разделителей между табами:
        -- "slant"        ╱╲  — скошенные (красиво, но занимают место)
        -- "padded_slant"     — скошенные с отступами
        -- "slope"        ╱╱  — наклонные в одну сторону
        -- "thick"        █│  — толстые блоки
        -- "thin"         │   — тонкие линии (по умолчанию)
        -- { '|', '|' }       — кастомные символы {левый, правый}
        separator_style = "slant",

        --[[
        ═══════════════════════════════════════════════════════════════
                           ОТОБРАЖЕНИЕ ЭЛЕМЕНТОВ
        ═══════════════════════════════════════════════════════════════
        --]]

        -- Всегда показывать bufferline даже если открыт 1 буфер
        always_show_bufferline = true,

        -- Сортировка буферов:
        -- "insert_after_current" — новые после текущего
        -- "insert_at_end"        — новые в конец
        -- "id"                   — по номеру буфера
        -- "extension"            — по расширению файла
        -- "directory"            — по директории
        -- function(a, b)         — кастомная функция
        sort_by = "insert_after_current",

        show_buffer_close_icons = true, -- Показывать × на табах
        show_close_icon = true, -- Показывать × справа bufferline
        show_tab_indicators = true, -- Показывать индикатор активного таба
        show_duplicate_prefix = true, -- Показывать путь для файлов с одинаковым именем

        -- Цветные иконки файлов (по типу файла)
        color_icons = true,

        --[[
        ═══════════════════════════════════════════════════════════════
                             HOVER ЭФФЕКТЫ
        ═══════════════════════════════════════════════════════════════
        --]]

        hover = {
          enabled = true, -- Включить hover эффекты
          delay = 200, -- Задержка появления в мс
          reveal = { "close" }, -- Что показывать при наведении: {"close"}
        },

        --[[
        ═══════════════════════════════════════════════════════════════
                           ГРУППЫ БУФЕРОВ
        ═══════════════════════════════════════════════════════════════
        --]]

        groups = {
          items = {
            -- Закреплённые буферы с иконкой булавки
            require("bufferline.groups").builtin.pinned:with({ icon = "" }),
            -- Можно добавить свои группы:
            -- { name = "Tests", matcher = function(buf) return buf.name:match('_test') end }
          },
        },
      },

      --[[
      ═════════════════════════════════════════════════════════════════
                              HIGHLIGHTS
                         УЛУЧШЕННАЯ TOKYO NIGHT
      ═════════════════════════════════════════════════════════════════
      --]]

      highlights = (function()
        -- Палитра Tokyo Night с высоким контрастом
        local c = {
          bg_dark = "#1a1b26", -- Самый тёмный фон
          bg = "#24283b", -- Фон неактивных табов
          bg_active = "#2e3c64", -- Фон активного таба (синий оттенок)
          blue = "#7aa2f7", -- Акцентный синий
          cyan = "#7dcfff", -- Циан
          fg = "#c0caf5", -- Светлый текст
          fg_dark = "#a9b1d6", -- Текст неактивных
          comment = "#565f89", -- Серый комментариев
          red = "#f7768e", -- Ошибки
          yellow = "#e0af68", -- Предупреждения
          teal = "#1abc9c", -- Подсказки
        }

        return {
          -- Фон пустой области
          fill = { bg = c.bg_dark },

          -- Неактивные табы
          background = { fg = c.fg_dark, bg = c.bg },
          buffer_visible = { fg = c.fg, bg = c.bg },
          buffer_selected = { fg = c.fg, bg = c.bg_active, bold = true, italic = false },

          -- Номера
          numbers = { fg = c.comment, bg = c.bg },
          numbers_visible = { fg = c.fg_dark, bg = c.bg },
          numbers_selected = { fg = c.cyan, bg = c.bg_active, bold = true },

          -- Кнопка закрытия
          close_button = { fg = c.comment, bg = c.bg },
          close_button_visible = { fg = c.fg_dark, bg = c.bg },
          close_button_selected = { fg = c.fg, bg = c.bg_active },

          -- Модифицированные файлы
          modified = { fg = c.yellow, bg = c.bg },
          modified_visible = { fg = c.yellow, bg = c.bg },
          modified_selected = { fg = c.yellow, bg = c.bg_active },

          -- Дубликаты
          duplicate = { fg = c.comment, bg = c.bg, italic = true },
          duplicate_visible = { fg = c.comment, bg = c.bg, italic = true },
          duplicate_selected = { fg = c.fg_dark, bg = c.bg_active, italic = true },

          -- Разделители
          separator = { fg = c.bg_dark, bg = c.bg },
          separator_visible = { fg = c.bg_dark, bg = c.bg },
          separator_selected = { fg = c.bg_dark, bg = c.bg_active },

          -- Индикатор активного таба
          indicator_visible = { fg = c.blue, bg = c.bg },
          indicator_selected = { fg = c.blue, bg = c.bg_active },

          -- Диагностика
          error = { fg = c.red, bg = c.bg },
          error_visible = { fg = c.red, bg = c.bg },
          error_selected = { fg = c.red, bg = c.bg_active, bold = true },
          error_diagnostic = { fg = c.red, bg = c.bg },
          error_diagnostic_visible = { fg = c.red, bg = c.bg },
          error_diagnostic_selected = { fg = c.red, bg = c.bg_active },

          warning = { fg = c.yellow, bg = c.bg },
          warning_visible = { fg = c.yellow, bg = c.bg },
          warning_selected = { fg = c.yellow, bg = c.bg_active, bold = true },
          warning_diagnostic = { fg = c.yellow, bg = c.bg },
          warning_diagnostic_visible = { fg = c.yellow, bg = c.bg },
          warning_diagnostic_selected = { fg = c.yellow, bg = c.bg_active },

          hint = { fg = c.teal, bg = c.bg },
          hint_visible = { fg = c.teal, bg = c.bg },
          hint_selected = { fg = c.teal, bg = c.bg_active },
          hint_diagnostic = { fg = c.teal, bg = c.bg },
          hint_diagnostic_visible = { fg = c.teal, bg = c.bg },
          hint_diagnostic_selected = { fg = c.teal, bg = c.bg_active },

          info = { fg = c.cyan, bg = c.bg },
          info_visible = { fg = c.cyan, bg = c.bg },
          info_selected = { fg = c.cyan, bg = c.bg_active },
          info_diagnostic = { fg = c.cyan, bg = c.bg },
          info_diagnostic_visible = { fg = c.cyan, bg = c.bg },
          info_diagnostic_selected = { fg = c.cyan, bg = c.bg_active },

          -- Табы
          tab = { fg = c.comment, bg = c.bg },
          tab_selected = { fg = c.fg, bg = c.bg_active, bold = true },
          tab_separator = { fg = c.bg_dark, bg = c.bg },
          tab_separator_selected = { fg = c.bg_dark, bg = c.bg_active },
          tab_close = { fg = c.red, bg = c.bg_dark },

          -- Трункация
          trunc_marker = { fg = c.comment, bg = c.bg_dark },
        }
      end)(),
    })

    --[[
    ═══════════════════════════════════════════════════════════════════
                    ДИНАМИЧЕСКАЯ СМЕНА ЦВЕТА ПО РЕЖИМУ
    ═══════════════════════════════════════════════════════════════════
    Цвет фона активного таба меняется в зависимости от режима Vim
    --]]

    -- Цвета режимов (только для фона)
    local mode_colors = {
      n = "#2d4a7e", -- Normal
      i = "#4a6a2a", -- Insert
      v = "#5b3a7e", -- Visual
      V = "#5b3a7e",
      [""] = "#5b3a7e",
      c = "#7a5a20", -- Command
      R = "#8a2a3a", -- Replace
      t = "#2a6a5a", -- Terminal
    }

    -- Цвета из highlights (для сохранения fg)
    local c = {
      fg = "#c0caf5",
      fg_dark = "#a9b1d6",
      cyan = "#7dcfff",
      yellow = "#e0af68",
      red = "#f7768e",
      teal = "#1abc9c",
      blue = "#7aa2f7",
      bg_dark = "#1a1b26",
    }

    local function update_bufferline_colors()
      local mode = vim.fn.mode()
      local bg = mode_colors[mode] or mode_colors.n

      -- Только меняем bg, fg остаётся из highlights
      vim.api.nvim_set_hl(0, "BufferLineBufferSelected", { fg = c.fg, bg = bg, bold = true })
      vim.api.nvim_set_hl(0, "BufferLineNumbersSelected", { fg = c.cyan, bg = bg, bold = true })
      vim.api.nvim_set_hl(0, "BufferLineCloseButtonSelected", { fg = c.fg, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineModifiedSelected", { fg = c.yellow, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineDuplicateSelected", { fg = c.fg_dark, bg = bg, italic = true })
      vim.api.nvim_set_hl(0, "BufferLineIndicatorSelected", { fg = c.blue, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineTabSelected", { fg = c.fg, bg = bg, bold = true })

      -- Разделители
      vim.api.nvim_set_hl(0, "BufferLineSeparatorSelected", { fg = c.bg_dark, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineTabSeparatorSelected", { fg = c.bg_dark, bg = bg })

      -- Диагностика — сохраняем цвета ошибок/предупреждений
      vim.api.nvim_set_hl(0, "BufferLineErrorSelected", { fg = c.red, bg = bg, bold = true })
      vim.api.nvim_set_hl(0, "BufferLineErrorDiagnosticSelected", { fg = c.red, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineWarningSelected", { fg = c.yellow, bg = bg, bold = true })
      vim.api.nvim_set_hl(0, "BufferLineWarningDiagnosticSelected", { fg = c.yellow, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineInfoSelected", { fg = c.cyan, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineInfoDiagnosticSelected", { fg = c.cyan, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineHintSelected", { fg = c.teal, bg = bg })
      vim.api.nvim_set_hl(0, "BufferLineHintDiagnosticSelected", { fg = c.teal, bg = bg })

      -- Pick буквы
      vim.api.nvim_set_hl(0, "BufferLinePickSelected", { fg = c.red, bg = bg, bold = true })

      -- Иконки — сохраняем их оригинальный fg цвет
      for name, _ in pairs(vim.api.nvim_get_hl(0, {})) do
        if name:match("^BufferLineDevIcon.*Selected$") then
          local current = vim.api.nvim_get_hl(0, { name = name })
          vim.api.nvim_set_hl(0, name, { fg = current.fg, bg = bg })
        end
      end

      vim.cmd.redrawtabline()
    end

    -- Автокоманда на смену режима
    vim.api.nvim_create_autocmd("ModeChanged", {
      pattern = "*",
      callback = update_bufferline_colors,
    })

    -- Инициализация при старте
    vim.api.nvim_create_autocmd({ "BufEnter", "VimEnter" }, {
      callback = function()
        vim.defer_fn(update_bufferline_colors, 10)
      end,
    })

    --[[
    ═══════════════════════════════════════════════════════════════════
                         АВТОКОМАНДА
    ═══════════════════════════════════════════════════════════════════
    Исправление: при удалении буфера переходим к следующему,
    а не остаёмся на пустом месте
    --]]

    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function(as)
        vim.schedule(function()
          pcall(vim.cmd, "BufferLineCycleNext")
        end)
      end,
    })
  end,

  --[[
  ═════════════════════════════════════════════════════════════════════
                          ГОРЯЧИЕ КЛАВИШИ
  ═════════════════════════════════════════════════════════════════════
  Lazy.nvim автоматически загрузит плагин при нажатии любой из клавиш
  --]]

  keys = {
    -- Навигация между буферами
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер" },

    -- Управление буферами
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Закрепить буфер" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Закрыть незакреплённые" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Закрыть остальные" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Закрыть справа" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Закрыть слева" },

    -- Быстрый переход к буферу по номеру
    { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Буфер 1" },
    { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Буфер 2" },
    { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Буфер 3" },
    { "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Буфер 4" },
    { "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Буфер 5" },
  },
}
