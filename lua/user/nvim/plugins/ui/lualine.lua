--[[
=====================================================================
                          LUALINE
=====================================================================
Красивая и быстрая статусная строка для Neovim.

Показывает:
  - Режим (Normal, Insert, Visual и т.д.)
  - Ветка Git и изменения
  - Диагностика (ошибки, предупреждения)
  - Кодировка и формат
  - Позиция курсора
  - WakaTime (время кодирования)
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

    -- Компонент для отображения WakaTime
    local wakatime_cache = { text = "", last_update = 0, initialized = false }

    local function update_wakatime()
      vim.fn.jobstart({
        vim.fn.expand("~/.wakatime/wakatime-cli"),
        "--today",
      }, {
        stdout_buffered = true,
        on_stdout = function(_, data)
          if data and data[1] and data[1] ~= "" then
            local time_str = data[1]:match("^%s*(.-)%s*$") -- trim
            if time_str and time_str ~= "" and not time_str:match("^0%s") then
              wakatime_cache.text = " " .. time_str
            else
              wakatime_cache.text = ""
            end
          end
        end,
        on_stderr = function()
          wakatime_cache.text = ""
        end,
      })
    end

    local function wakatime_status()
      -- Инициализация при первом вызове
      if not wakatime_cache.initialized then
        wakatime_cache.initialized = true
        update_wakatime()
      end

      -- Обновляем каждые 120 секунд
      local now = os.time()
      if now - wakatime_cache.last_update > 120 then
        wakatime_cache.last_update = now
        update_wakatime()
      end

      return wakatime_cache.text
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
              Info = "", -- Информация
            },
          },
        },

        -- ═══════════════════════════════════════════════════════════
        -- ПРАВАЯ ЧАСТЬ
        -- ═══════════════════════════════════════════════════════════
        lualine_x = {
          -- WakaTime
          {
            wakatime_status,
            color = { fg = colors.blue },
          },
          -- Статус Supermaven
          {
            supermaven_status,
            color = { fg = colors.green },
          },
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
        lualine_c = {},
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
