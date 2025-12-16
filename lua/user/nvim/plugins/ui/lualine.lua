--[[
=====================================================================
                          LUALINE
=====================================================================
Красивая и быстрая статусная строка для Neovim.

Показывает:
  - Режим (Normal, Insert, Visual и т.д.)
  - Ветка Git и изменения
  - Диагностика (ошибки, предупреждения)
  - Название файла и тип
  - Кодировка и формат
  - Позиция курсора
  - Статус LSP
  - Статус AI (Supermaven)

GitHub: https://github.com/nvim-lualine/lualine.nvim
=====================================================================
--]]

return {
  "nvim-lualine/lualine.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },

  opts = function()
    -- Цвета из tokyonight
    local colors = {
      bg = "#1a1b26",
      fg = "#c0caf5",
      yellow = "#e0af68",
      cyan = "#7dcfff",
      green = "#9ece6a",
      orange = "#ff9e64",
      violet = "#9d7cd8",
      magenta = "#bb9af7",
      blue = "#7aa2f7",
      red = "#f7768e",
    }

    -- Компонент для отображения статуса Supermaven
    local function supermaven_status()
      local ok, api = pcall(require, "supermaven-nvim.api")
      if ok and api.is_running() then
        return "󱚞" -- Иконка AI
      end
      return "󱙻"
    end

    -- Компонент для отображения LSP серверов
    local function lsp_clients()
      local clients = vim.lsp.get_clients({ bufnr = 0 })
      if #clients == 0 then
        return ""
      end

      local names = {}
      for _, client in ipairs(clients) do
        table.insert(names, client.name)
      end

      return "󱒊" .. table.concat(names, ", ")
    end

    return {
      options = {
        theme = "tokyonight",
        globalstatus = true,
        disabled_filetypes = {
          statusline = { "dashboard", "alpha", "starter" },
          winbar = {},
        },
        component_separators = { left = "", right = "" },
        section_separators = { left = "", right = "" },
      },

      sections = {
        -- ═══════════════════════════════════════════════════════════
        -- ЛЕВАЯ ЧАСТЬ
        -- ═══════════════════════════════════════════════════════════
        lualine_a = {
          {
            "mode",
            fmt = function(str)
              -- Короткие названия режимов на русском
              local modes = {
                ["NORMAL"] = "НОРМ",
                ["INSERT"] = "ВСТАВ",
                ["VISUAL"] = "ВИЗ",
                ["V-LINE"] = "В-ЛИН",
                ["V-BLOCK"] = "В-БЛОК",
                ["COMMAND"] = "КОМАНДА",
                ["REPLACE"] = "ЗАМЕНА",
                ["TERMINAL"] = "ТЕРМ",
              }
              return modes[str] or str
            end,
          },
        },

        lualine_b = {
          {
            "branch",
            fmt = function(str)
              if vim.fn.strchars(str) > 30 then
                return vim.fn.strcharpart(str, 0, 27) .. "…"
              end
              return str
            end,
          },
          {
            "diff",
            symbols = {
              added = "",
              modified = "󱧃",
              removed = "󱀭",
            },
            colored = true,
          },
        },

        lualine_c = {
          {
            "diagnostics",
            sources = { "nvim_diagnostic" },
            symbols = {
              Error = "", -- Ошибка
              Warn = "", -- Предупреждение
              Hint = "󰌵", -- Подсказка
              Info = "", -- Информация
            },
          },
          { "filetype", icon_only = true, separator = "", padding = { left = 1, right = 0 } },
          {
            "filename",
            path = 0, -- Только имя файла без пути
            symbols = {
              modified = "󱧃",
              readonly = "",
              unnamed = "[Без имени]",
              newfile = "[Новый]",
            },
          },
        },

        -- ═══════════════════════════════════════════════════════════
        -- ПРАВАЯ ЧАСТЬ
        -- ═══════════════════════════════════════════════════════════
        lualine_x = {
          -- Статус Supermaven
          {
            supermaven_status,
            color = { fg = colors.green },
          },
          -- LSP серверы
          {
            lsp_clients,
            color = { fg = colors.cyan },
          },
          -- Отступы (пробелы/табы)
          -- {
          --   function()
          --     local space = vim.bo.expandtab and "Пробелы" or "Табы"
          --     return space .. ":" .. vim.bo.shiftwidth
          --   end,
          --   cond = function()
          --     return vim.bo.filetype ~= ""
          --   end,
          -- },
        },

        lualine_y = {
          { "encoding", show_bomb = true },
          { "fileformat", icons_enabled = true },
          { "filetype" },
        },

        lualine_z = {
          { "progress" },
          { "location" },
        },
      },

      -- ═══════════════════════════════════════════════════════════
      -- НЕАКТИВНЫЕ ОКНА
      -- ═══════════════════════════════════════════════════════════
      inactive_sections = {
        lualine_a = {},
        lualine_b = {},
        lualine_c = { "filename" },
        lualine_x = { "location" },
        lualine_y = {},
        lualine_z = {},
      },

      -- ═══════════════════════════════════════════════════════════
      -- РАСШИРЕНИЯ
      -- ═══════════════════════════════════════════════════════════
      extensions = {
        "neo-tree",
        "lazy",
        "toggleterm",
        "trouble",
        "quickfix",
      },
    }
  end,
}
