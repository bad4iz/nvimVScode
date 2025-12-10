--[[
=====================================================================
                          NOICE.NVIM
=====================================================================
Красивое отображение сообщений, команд и диагностики.

Возможности:
  - Красивые всплывающие сообщения
  - Водяной текст с ошибками (как в AstroNvim)
  - История команд в красивом формате
  - Фильтрация ненужных сообщений

GitHub: https://github.com/folke/noice.nvim
=====================================================================
--]]

return {
  "folke/noice.nvim",
  event = "VeryLazy",
  
  dependencies = {
    "MunifTanjim/nui.nvim",
    "rcarriga/nvim-notify",
  },
  
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- ОСНОВНЫЕ НАСТРОЙКИ
    -- ═══════════════════════════════════════════════════════════════
    lsp = {
      override = {
        ["vim.lsp.util.convert_input_to_markdown_lines"] = true,
        ["vim.lsp.util.stylize_markdown"] = true,
        ["cmp.entry.get_documentation"] = true,
      },
      hover = {
        enabled = true,
        silent = false,
      },
      signature = {
        enabled = true,
        auto_open = {
          enabled = true,
          trigger = true,
          luasnip = true,
        },
      },
      message = {
        enabled = true,
        view = "notify",
        opts = {},
      },
      progress = {
        enabled = true,
        format = "lsp_progress",
        format_done = "lsp_progress_done",
        throttle = 1000 / 30,
        view = "mini",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- МАРШРУТЫ СООБЩЕНИЙ
    -- ═══════════════════════════════════════════════════════════════
    routes = {
      -- Скрыть "No information available" для hover
      {
        filter = {
          event = "notify",
          find = "No information available",
        },
        opts = { skip = true },
      },
      
      -- Скрыть сообщения о записи файла
      {
        filter = {
          event = "msg_show",
          kind = "",
          find = "written",
        },
        opts = { skip = true },
      },
      
      -- Скрыть сообщения о поиске
      {
        filter = {
          event = "msg_show",
          kind = "search_count",
        },
        opts = { skip = true },
      },
      
      -- Диагностика в notify
      {
        filter = { event = "lsp" },
        view = "notify",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ФОРМАТИРОВАНИЕ СООБЩЕНИЙ
    -- ═══════════════════════════════════════════════════════════════
    format = {
      level = {
        icons = {
          trace = "✎",
          debug = " ",
          info = " ",
          warn = " ",
          error = " ",
        },
      },
      lsp_progress = {
        pattern = "%^%s*(%S+)%s*(%S-)%s*$",
        format = "{spinner} {title} {percentage} [{bar}]",
        format_done = "{checkmark} {title}",
        throttle = 1000 / 30,
        view = "mini",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ПРЕДУСТАНОВКИ
    -- ═══════════════════════════════════════════════════════════════
    presets = {
      bottom_search = true,        -- Поиск внизу
      command_palette = true,      -- Палитра команд
      long_message_to_split = true, -- Длинные сообщения в split
      inc_rename = true,           -- Переименование с превью
      lsp_doc_border = true,       -- Граница для LSP документации
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- СТАТУС-КОЛОНКА
    -- ═══════════════════════════════════════════════════════════════
    status = {
      -- Показывать статус в lualine
      hl_group = "NoiceStatusline",
    },
  },
  
  config = function(_, opts)
    require("noice").setup(opts)
    
    -- Интеграция с nvim-notify для красивых уведомлений
    vim.notify = require("notify")
  end,
}
