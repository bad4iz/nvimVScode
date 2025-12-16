--[[
=====================================================================
                    MARKDOWN - ПОДДЕРЖКА MD ФАЙЛОВ
=====================================================================

Полноценная поддержка Markdown файлов:
- Рендеринг прямо в Neovim (заголовки, списки, код, таблицы)
- Предварительный просмотр в браузере
- LSP (через marksman в mason.lua)
- Форматирование (через prettier в conform.lua)

=====================================================================
                        ГОРЯЧИЕ КЛАВИШИ
=====================================================================

ГЛОБАЛЬНЫЕ:
  <leader>mp    - Открыть/закрыть preview в браузере

В MARKDOWN ФАЙЛАХ:
  <leader>mr    - Toggle рендеринг в Neovim
  <leader>md    - Toggle диагностику (если есть красные подчеркивания)

АВТОМАТИЧЕСКИ:
  - Рендеринг включается при открытии .md файла
  - LSP автодополнение и навигация (marksman)
  - Форматирование через Prettier
  - Диагностика и spell checking отключены по умолчанию

=====================================================================
--]]

return {
  -- =====================================================================
  -- RENDER-MARKDOWN - Рендеринг прямо в Neovim
  -- =====================================================================
  {
    "MeanderingProgrammer/render-markdown.nvim",
    ft = "markdown", -- Загружается только для markdown файлов
    dependencies = {
      "nvim-treesitter/nvim-treesitter", -- Для парсинга
      "nvim-tree/nvim-web-devicons",     -- Для иконок
    },

    -- Горячие клавиши
    keys = {
      {
        "<leader>mr",
        function()
          require("render-markdown").toggle()
        end,
        desc = "Markdown: Toggle рендеринг",
        ft = "markdown",
      },
    },

    opts = {
      -- =====================================================================
      -- ОСНОВНЫЕ НАСТРОЙКИ
      -- =====================================================================

      -- Включить рендеринг по умолчанию
      enabled = true,

      -- Максимальная ширина файла для рендеринга
      max_file_size = 10.0, -- MB

      -- Рендерить в заголовке окна
      render_modes = { "n", "c", "i" }, -- normal, command, insert

      -- Anti-conceal - показывать текст под курсором
      anti_conceal = {
        enabled = true,
        -- Игнорировать в этих режимах
        ignore = {
          code_background = true,
          sign = false,
        },
      },

      -- =====================================================================
      -- ЗАГОЛОВКИ (HEADINGS)
      -- =====================================================================

      heading = {
        -- Включить рендеринг заголовков
        enabled = true,

        -- Позиция иконки: "overlay" или "inline"
        position = "overlay",

        -- Иконки для разных уровней заголовков
        icons = { "󰲡 ", "󰲣 ", "󰲥 ", "󰲧 ", "󰲩 ", "󰲫 " },

        -- Знаки (signs) в signcolumn
        sign = true,

        -- Ширина заголовков (nil = авто)
        width = "full", -- "full" или "block"

        -- Минимальная ширина
        min_width = 0,

        -- Выравнивание: "left", "center", "right"
        left_pad = 0,
        right_pad = 0,

        -- Разделители между заголовками
        border = true,
        border_virtual = false,
        border_prefix = false,

        -- Стили для разных уровней (используются highlight группы)
        backgrounds = {
          "RenderMarkdownH1Bg",
          "RenderMarkdownH2Bg",
          "RenderMarkdownH3Bg",
          "RenderMarkdownH4Bg",
          "RenderMarkdownH5Bg",
          "RenderMarkdownH6Bg",
        },

        foregrounds = {
          "RenderMarkdownH1",
          "RenderMarkdownH2",
          "RenderMarkdownH3",
          "RenderMarkdownH4",
          "RenderMarkdownH5",
          "RenderMarkdownH6",
        },
      },

      -- =====================================================================
      -- ПАРАГРАФЫ И БЛОКИ
      -- =====================================================================

      paragraph = {
        enabled = true,
        left_margin = 0,
        min_width = 0,
      },

      -- =====================================================================
      -- БЛОКИ КОДА (CODE BLOCKS)
      -- =====================================================================

      code = {
        -- Включить рендеринг блоков кода
        enabled = true,

        -- Позиция: "left", "right", "language"
        sign = true,

        -- Стиль: "full", "normal", "language", "none"
        style = "full",

        -- Позиция названия языка
        position = "left",

        -- Отступы
        left_pad = 0,
        right_pad = 0,

        -- Ширина
        width = "full",
        min_width = 0,

        -- Граница
        border = "thin", -- "thin" или "thick"

        -- Highlight группы
        highlight = "RenderMarkdownCode",
        highlight_inline = "RenderMarkdownCodeInline",
      },

      -- =====================================================================
      -- СПИСКИ (LISTS)
      -- =====================================================================

      bullet = {
        enabled = true,
        -- Иконки для разных уровней списков
        icons = { "●", "○", "◆", "◇" },
        -- Highlight группа
        highlight = "RenderMarkdownBullet",
      },

      -- Чекбоксы
      checkbox = {
        enabled = true,
        unchecked = {
          icon = "󰄱 ",
          highlight = "RenderMarkdownUnchecked",
        },
        checked = {
          icon = " ",
          highlight = "RenderMarkdownChecked",
        },
        custom = {
          todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
        },
      },

      -- =====================================================================
      -- ЦИТАТЫ (QUOTES)
      -- =====================================================================

      quote = {
        enabled = true,
        icon = "▋",
        highlight = "RenderMarkdownQuote",
      },

      -- =====================================================================
      -- ТАБЛИЦЫ (TABLES)
      -- =====================================================================

      pipe_table = {
        enabled = true,
        preset = "normal", -- "none", "normal", "round", "heavy", "double"
        -- Стиль границ
        cell = "padded", -- "overlay", "raw", "padded", "trimmed"
        -- Выравнивание
        alignment_indicator = "━",
        -- Highlight группы
        head = "RenderMarkdownTableHead",
        row = "RenderMarkdownTableRow",
        filler = "RenderMarkdownTableFill",
      },

      -- =====================================================================
      -- CALLOUTS (БЛОКИ ВНИМАНИЯ)
      -- =====================================================================

      callout = {
        note = { raw = "[!NOTE]", rendered = "󰋽 Note", highlight = "RenderMarkdownInfo" },
        tip = { raw = "[!TIP]", rendered = "󰌶 Tip", highlight = "RenderMarkdownSuccess" },
        important = { raw = "[!IMPORTANT]", rendered = "󰅾 Important", highlight = "RenderMarkdownHint" },
        warning = { raw = "[!WARNING]", rendered = "󰀪 Warning", highlight = "RenderMarkdownWarn" },
        caution = { raw = "[!CAUTION]", rendered = "󰳦 Caution", highlight = "RenderMarkdownError" },
      },

      -- =====================================================================
      -- ССЫЛКИ (LINKS)
      -- =====================================================================

      link = {
        enabled = true,
        image = "󰥶 ", -- Иконка для изображений
        hyperlink = "󰌷 ", -- Иконка для ссылок
        highlight = "RenderMarkdownLink",
      },

      -- =====================================================================
      -- РАЗНОЕ
      -- =====================================================================

      -- Горизонтальные линии
      dash = {
        enabled = true,
        icon = "─",
        width = "full",
        highlight = "RenderMarkdownDash",
      },

      -- HTML сущности
      html = {
        enabled = true,
      },

      -- Latex
      latex = {
        enabled = true,
        converter = "latex2text",
        highlight = "RenderMarkdownMath",
      },

      -- Знаки (signs) в signcolumn
      sign = {
        enabled = true,
        highlight = "RenderMarkdownSign",
      },
    },
  },

  -- =====================================================================
  -- MARKDOWN-PREVIEW - Предварительный просмотр в браузере
  -- =====================================================================
  {
    "iamcco/markdown-preview.nvim",
    ft = "markdown",
    build = function()
      vim.fn["mkdp#util#install"]()
    end,

    -- Горячие клавиши
    keys = {
      {
        "<leader>mp",
        "<cmd>MarkdownPreviewToggle<CR>",
        desc = "Markdown: Preview в браузере",
        ft = "markdown",
      },
    },

    config = function()
      -- Настройки markdown-preview
      vim.g.mkdp_auto_start = 0 -- Не запускать автоматически
      vim.g.mkdp_auto_close = 1 -- Закрывать при смене буфера
      vim.g.mkdp_refresh_slow = 0 -- Быстрое обновление
      vim.g.mkdp_command_for_global = 0 -- Только для markdown
      vim.g.mkdp_open_to_the_world = 0 -- Только локально
      vim.g.mkdp_open_ip = "127.0.0.1"
      vim.g.mkdp_port = "8080"
      vim.g.mkdp_browser = "" -- Системный браузер по умолчанию

      -- Тема preview
      vim.g.mkdp_theme = "dark" -- "dark" или "light"

      -- Комбинировать preview с другими плагинами
      vim.g.mkdp_combine_preview = 0
      vim.g.mkdp_preview_options = {
        mkit = {},
        katex = {},
        uml = {},
        maid = {},
        disable_sync_scroll = 0,
        sync_scroll_type = "middle",
        hide_yaml_meta = 1,
        sequence_diagrams = {},
        flowchart_diagrams = {},
        content_editable = false,
        disable_filename = 0,
      }

      -- Markdown стиль
      vim.g.mkdp_markdown_css = ""
      vim.g.mkdp_highlight_css = ""

      -- Page title
      vim.g.mkdp_page_title = "${name}"
    end,
  },

  -- =====================================================================
  -- НАСТРОЙКА MARKDOWN БУФЕРОВ
  -- =====================================================================
  {
    "neovim/nvim-lspconfig",
    optional = true,
    opts = function()
      -- Автокоманда для настройки markdown буферов
      vim.api.nvim_create_autocmd("FileType", {
        pattern = { "markdown", "markdown.mdx" },
        callback = function(args)
          local bufnr = args.buf

          -- Отключить spell checking (может быть источником красных подчеркиваний)
          vim.opt_local.spell = false

          -- Отключить диагностику для этого буфера
          vim.diagnostic.enable(false, { bufnr = bufnr })

          -- Горячая клавиша для toggle диагностики в markdown
          vim.keymap.set("n", "<leader>md", function()
            local is_enabled = vim.diagnostic.is_enabled({ bufnr = bufnr })
            vim.diagnostic.enable(not is_enabled, { bufnr = bufnr })
            vim.notify(
              "Markdown диагностика: " .. (is_enabled and "OFF" or "ON"),
              vim.log.levels.INFO
            )
          end, {
            buffer = bufnr,
            desc = "Markdown: Toggle диагностику"
          })
        end,
        desc = "Настройка markdown буферов (отключить spell и диагностику)",
      })
    end,
  },
}
