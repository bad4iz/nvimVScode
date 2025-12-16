--[[
=====================================================================
                          BLINK.CMP
=====================================================================
Быстрый и современный движок автодополнения для Neovim.

Преимущества перед nvim-cmp:
  - Написан на Rust (blazingly fast)
  - Меньше конфигурации
  - Встроенная поддержка LSP
  - Автоматические скобки

Источники автодополнения:
  - Emoji       - эмодзи (приоритет: 100, LSP отключается при вводе :)
  - Nerd Font   - иконки Nerd Font (приоритет: 100, LSP отключается при вводе :)
  - Supermaven  - AI автодополнение (приоритет: 100)
  - Codeium     - AI автодополнение (приоритет: 95)
  - LSP         - Language Server Protocol (приоритет: 90)
  - Snippets    - сниппеты через LuaSnip (приоритет: 89)
  - Path        - пути к файлам (приоритет: 3)
  - Buffer      - текущий буфер (приоритет: 1)

ВАЖНО: При вводе : (двоеточие) LSP автоматически отключается,
чтобы emoji и nerdfont иконки показывались первыми.

Горячие клавиши:
  <C-Space>   - показать меню автодополнения
  <CR>        - подтвердить выбор
  <Tab>       - следующий элемент / раскрыть сниппет
  <S-Tab>     - предыдущий элемент
  <C-e>       - закрыть меню
  <C-b>       - прокрутка документации вверх
  <C-f>       - прокрутка документации вниз

GitHub: https://github.com/Saghen/blink.cmp
=====================================================================
--]]

-- ═══════════════════════════════════════════════════════════════════
-- ИКОНКИ ДЛЯ АВТОДОПОЛНЕНИЯ (Nerd Font)
-- ═══════════════════════════════════════════════════════════════════
local kind_icons = {
  Text = "󰉿",
  Method = "󰆧",
  Function = "󰊕",
  Constructor = "",
  Field = "󰜢",
  Variable = "󰀫",
  Class = "󰠱",
  Interface = "",
  Module = "",
  Property = "󰜢",
  Unit = "󰑭",
  Value = "󰎠",
  Enum = "",
  Keyword = "󰌋",
  Snippet = "",
  Color = "󰏘",
  File = "󰈙",
  Reference = "󰈇",
  Folder = "󰉋",
  EnumMember = "",
  Constant = "󰏿",
  Struct = "󰙅",
  Event = "",
  Operator = "󰆕",
  TypeParameter = "󰅲",
  -- AI автодополнение
  Supermaven = "",
  Codeium = "",
  Copilot = "",
  -- Дополнительные
  Emoji = "󰞅",
  TabNine = "󰏚",
  Array = "󰅪",
  Boolean = "a",
  Key = "󰌋",
  Namespace =   "󰌗",
  Null = "󰟢",
  Number = "",
  Object = "󰅩",
  Package = "e3",
  String = "󰀬",
}

-- Иконки для источников автодополнения
local source_icons = {
  LSP = "󰒋",
  Supermaven = "a",
  Codeium = "d",
  Copilot = "e",
  Snippets = "i",
  Buffer = "󰈙",
  Path = "󰉋",
  Emoji = "󰞅",
  Luasnip = "l",
  Cmdline = "m",
}

return {
  "saghen/blink.cmp",
  enabled = false, -- Выключено для сравнения с nvim-cmp
  version = "*",
  event = "InsertEnter",
  
  init = function()
    vim.g.cmp_enabled = false
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
  end,
  
  dependencies = {
    -- Сниппеты
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    "L3MON4D3/LuaSnip",

    -- Иконки для файлов
    "nvim-tree/nvim-web-devicons",

    -- Supermaven для blink.cmp
    "huijiro/blink-cmp-supermaven",
    
    -- Codeium AI
    "Exafunction/codeium.nvim",
    
    -- Emoji для blink.cmp (нативный)
    "moyiz/blink-emoji.nvim",
    
    -- Nerd Font иконки для blink.cmp
    "MahanRahmati/blink-nerdfont.nvim",

    -- Адаптер для совместимости с nvim-cmp источниками
    {
      "saghen/blink.compat",
      version = "*",
      lazy = true,
      opts = {
        impersonate_nvim_cmp = true,
      },
    },
  },
  
  ---@module 'blink.cmp'
  ---@type blink.cmp.Config
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- СОЧЕТАНИЯ КЛАВИШ
    -- ═══════════════════════════════════════════════════════════════
    keymap = {
      preset = "default",
      
      -- Показать меню автодополнения
      ["<C-space>"] = { "show", "show_documentation", "hide_documentation" },
      
      -- Закрыть меню
      ["<C-e>"] = { "hide", "fallback" },
      
      -- Подтвердить выбор
      ["<CR>"] = { "accept", "fallback" },
      
      -- Навигация
      ["<Tab>"] = { "snippet_forward", "select_next", "fallback" },
      ["<S-Tab>"] = { "snippet_backward", "select_prev", "fallback" },
      
      -- Прокрутка вверх/вниз по списку
      ["<C-j>"] = { "select_next", "fallback" },
      ["<C-k>"] = { "select_prev", "fallback" },
      
      -- Прокрутка документации
      ["<C-b>"] = { "scroll_documentation_up", "fallback" },
      ["<C-f>"] = { "scroll_documentation_down", "fallback" },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ВНЕШНИЙ ВИД
    -- ═══════════════════════════════════════════════════════════════
    appearance = {
      use_nvim_cmp_as_default = false,
      nerd_font_variant = "mono",
      -- Кастомные иконки для всех типов
      kind_icons = kind_icons,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ИСТОЧНИКИ АВТОДОПОЛНЕНИЯ
    -- ═══════════════════════════════════════════════════════════════
    sources = {
      -- Провайдеры по умолчанию (emoji и nerdfont идут первыми для приоритета)
      default = { "emoji", "nerdfont", "lsp", "path", "snippets", "buffer", "supermaven", "codeium" },

      -- Настройки провайдеров
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 90,
          min_keyword_length = 1,
          fallbacks = { "buffer" },
          -- Отключить LSP когда введен символ : для emoji/nerdfont
          enabled = function()
            local line = vim.api.nvim_get_current_line()
            local col = vim.api.nvim_win_get_cursor(0)[2]
            local before_cursor = line:sub(1, col)
            -- Проверяем, есть ли : в начале текущего слова
            local word_start = before_cursor:match(".*%s():?[%w_]*$") or before_cursor:match("^():?[%w_]*$")
            if word_start and before_cursor:sub(word_start, word_start) == ":" then
              return false  -- Отключить LSP
            end
            return true
          end,
        },
        path = {
          name = "Path",
          module = "blink.cmp.sources.path",
          score_offset = 3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
          },
        },
        snippets = {
          name = "Snippets",
          module = "blink.cmp.sources.snippets",
          score_offset = 89,
        },
        buffer = {
          name = "Buffer",
          module = "blink.cmp.sources.buffer",
          score_offset = 1,
        },
        
        -- Supermaven AI
        supermaven = {
          name = "Supermaven",
          module = "blink-cmp-supermaven",
          score_offset = 100,
          async = true,
        },
        
        -- Codeium AI (через blink.compat)
        codeium = {
          name = "Codeium",
          module = "blink.compat.source",
          score_offset = 95,
          async = true,
        },
        
        -- Emoji (нативный плагин для blink.cmp)
        emoji = {
          name = "Emoji",
          module = "blink-emoji",
          score_offset = 100,  -- Высокий приоритет (LSP отключается при :)
          min_keyword_length = 0,  -- Показывать даже при одном символе
          opts = { insert = true },  -- Вставлять эмоджи (не код)
        },

        -- Nerd Font иконки
        nerdfont = {
          name = "Nerd Fonts",
          module = "blink-nerdfont",
          score_offset = 100,  -- Высокий приоритет (LSP отключается при :)
          min_keyword_length = 0,  -- Показывать даже при одном символе
          opts = { insert = true },  -- Вставлять иконку (не код)
        },
      },
    },

    -- ═══════════════════════════════════════════════════════════════
    -- SNIPPETS (включая LuaSnip)
    -- ═══════════════════════════════════════════════════════════════
    snippets = {
      preset = "luasnip", -- Использовать LuaSnip как движок
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- СИГНАТУРА ФУНКЦИЙ
    -- ═══════════════════════════════════════════════════════════════
    signature = {
      enabled = true,
      window = {
        border = "rounded",
        winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- МЕНЮ АВТОДОПОЛНЕНИЯ
    -- ═══════════════════════════════════════════════════════════════
    completion = {
      -- Автоматически показывать меню
      trigger = {
        show_on_insert_on_trigger_character = true,
      },
      
      -- Принятие автодополнения
      accept = {
        -- Автоматические скобки
        auto_brackets = {
          enabled = true,
        },
      },
      
      -- Список элементов
      list = {
        -- Автоматически выбирать первый элемент
        selection = {
          preselect = true,
          auto_insert = true,
        },
      },
      
      -- Меню
      menu = {
        enabled = true,
        border = "rounded",
        winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
        scrollbar = true,
        scrolloff = 2,
        
        -- Отрисовка элементов
        draw = {
          -- Отступы
          padding = 1,
          gap = 1,
          treesitter = { "lsp" },
          
          -- Колонки: иконка | метка + описание | тип | источник
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "kind" },
            { "source_icon" },
          },
          
          -- Компоненты
          components = {
            -- Иконка типа
            kind_icon = {
              ellipsis = false,
              width = { fill = false },
              text = function(ctx)
                -- Для путей к файлам используем иконки файлов
                if ctx.source_name == "Path" or ctx.source_name == "Путь" then
                  local ok, dev_icon = pcall(function()
                    return require("nvim-web-devicons").get_icon(ctx.label)
                  end)
                  if ok and dev_icon then
                    return dev_icon .. " "
                  end
                end
                return (kind_icons[ctx.kind] or kind_icons.Text) .. " "
              end,
              highlight = function(ctx)
                -- Для путей используем цвет файла
                if ctx.source_name == "Path" or ctx.source_name == "Путь" then
                  local ok, _, hl = pcall(function()
                    return require("nvim-web-devicons").get_icon(ctx.label)
                  end)
                  if ok and hl then return hl end
                end
                return "BlinkCmpKind" .. (ctx.kind or "Text")
              end,
            },
            
            -- Метка
            label = {
              width = { fill = true, max = 50 },
              text = function(ctx)
                return ctx.label .. (ctx.label_detail or "")
              end,
              highlight = function(ctx)
                -- Подсветка совпадающих символов
                local highlights = {
                  { 0, #ctx.label, group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel" },
                }
                -- Подсветка совпадений при поиске
                if ctx.label_matched_indices then
                  for _, idx in ipairs(ctx.label_matched_indices) do
                    table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
                  end
                end
                return highlights
              end,
            },
            
            -- Описание метки
            label_description = {
              width = { max = 30 },
              text = function(ctx)
                return ctx.label_description or ""
              end,
              highlight = "BlinkCmpLabelDescription",
            },
            
            -- Тип (Kind)
            kind = {
              width = { fill = false },
              text = function(ctx)
                return ctx.kind or ""
              end,
              highlight = function(ctx)
                return "BlinkCmpKind" .. (ctx.kind or "Text")
              end,
            },
            
            -- Иконка источника
            source_icon = {
              width = { fill = false },
              text = function(ctx)
                local icon = source_icons[ctx.source_name] or "󰋽"
                return " " .. icon
              end,
              highlight = function(ctx)
                -- Разные цвета для разных источников
                local hl_map = {
                  LSP = "BlinkCmpSourceLsp",
                  Supermaven = "BlinkCmpSourceSupermaven",
                  Codeium = "BlinkCmpSourceCodeium",
                  Snippets = "BlinkCmpSourceSnippets",
                  Buffer = "BlinkCmpSourceBuffer",
                  Path = "BlinkCmpSourcePath",
                  Emoji = "BlinkCmpSourceEmoji",
                  ["Путь"] = "BlinkCmpSourcePath",
                  ["Буфер"] = "BlinkCmpSourceBuffer",
                  ["Сниппеты"] = "BlinkCmpSourceSnippets",
                }
                return hl_map[ctx.source_name] or "BlinkCmpSource"
              end,
            },
          },
        },
      },
      
      -- Документация
      documentation = {
        auto_show = true,
        auto_show_delay_ms = 200,
        window = {
          border = "rounded",
          winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder",
        },
      },
      
      -- Ghost text (предпросмотр)
      ghost_text = {
        enabled = true,
      },
    },
  },
  
  -- Функция для добавления источников
  opts_extend = { "sources.default", "sources.providers" },
  
  -- Настройка цветов после загрузки плагина
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    
    -- ═══════════════════════════════════════════════════════════════
    -- ЦВЕТОВАЯ СХЕМА ДЛЯ BLINK.CMP
    -- ═══════════════════════════════════════════════════════════════
    local colors = {
      -- Основные цвета меню
      menu_bg = "#1a1b26",
      menu_fg = "#c0caf5",
      menu_border = "#7aa2f7",
      menu_selection = "#283457",
      
      -- Цвета для типов (Kind)
      text = "#9aa5ce",
      method = "#7aa2f7",
      func = "#bb9af7",
      constructor = "#f7768e",
      field = "#73daca",
      variable = "#c0caf5",
      class = "#ff9e64",
      interface = "#73daca",
      module = "#ff9e64",
      property = "#73daca",
      unit = "#ff9e64",
      value = "#9ece6a",
      enum = "#ff9e64",
      keyword = "#bb9af7",
      snippet = "#e0af68",
      color = "#9ece6a",
      file = "#7aa2f7",
      reference = "#7aa2f7",
      folder = "#e0af68",
      enum_member = "#73daca",
      constant = "#ff9e64",
      struct = "#ff9e64",
      event = "#ff9e64",
      operator = "#bb9af7",
      type_parameter = "#73daca",
      
      -- AI источники
      supermaven = "#6cc644",
      codeium = "#09b6a2",
      copilot = "#6cc644",
      
      -- Другие источники
      buffer = "#565f89",
      path = "#e0af68",
      emoji = "#f7768e",
      lsp = "#7aa2f7",
      snippets = "#e0af68",
      
      -- Метки
      label = "#c0caf5",
      label_match = "#7aa2f7",
      label_deprecated = "#565f89",
      label_description = "#565f89",
    }
    
    -- Меню
    vim.api.nvim_set_hl(0, "BlinkCmpMenu", { bg = colors.menu_bg, fg = colors.menu_fg })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuBorder", { fg = colors.menu_border, bg = colors.menu_bg })
    vim.api.nvim_set_hl(0, "BlinkCmpMenuSelection", { bg = colors.menu_selection, bold = true })
    
    -- Документация
    vim.api.nvim_set_hl(0, "BlinkCmpDoc", { bg = colors.menu_bg, fg = colors.menu_fg })
    vim.api.nvim_set_hl(0, "BlinkCmpDocBorder", { fg = colors.menu_border, bg = colors.menu_bg })
    
    -- Сигнатура
    vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelp", { bg = colors.menu_bg, fg = colors.menu_fg })
    vim.api.nvim_set_hl(0, "BlinkCmpSignatureHelpBorder", { fg = colors.menu_border, bg = colors.menu_bg })
    
    -- Метки
    vim.api.nvim_set_hl(0, "BlinkCmpLabel", { fg = colors.label })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelMatch", { fg = colors.label_match, bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDeprecated", { fg = colors.label_deprecated, strikethrough = true })
    vim.api.nvim_set_hl(0, "BlinkCmpLabelDescription", { fg = colors.label_description })
    
    -- Иконки типов (Kind)
    vim.api.nvim_set_hl(0, "BlinkCmpKindText", { fg = colors.text })
    vim.api.nvim_set_hl(0, "BlinkCmpKindMethod", { fg = colors.method })
    vim.api.nvim_set_hl(0, "BlinkCmpKindFunction", { fg = colors.func })
    vim.api.nvim_set_hl(0, "BlinkCmpKindConstructor", { fg = colors.constructor })
    vim.api.nvim_set_hl(0, "BlinkCmpKindField", { fg = colors.field })
    vim.api.nvim_set_hl(0, "BlinkCmpKindVariable", { fg = colors.variable })
    vim.api.nvim_set_hl(0, "BlinkCmpKindClass", { fg = colors.class })
    vim.api.nvim_set_hl(0, "BlinkCmpKindInterface", { fg = colors.interface })
    vim.api.nvim_set_hl(0, "BlinkCmpKindModule", { fg = colors.module })
    vim.api.nvim_set_hl(0, "BlinkCmpKindProperty", { fg = colors.property })
    vim.api.nvim_set_hl(0, "BlinkCmpKindUnit", { fg = colors.unit })
    vim.api.nvim_set_hl(0, "BlinkCmpKindValue", { fg = colors.value })
    vim.api.nvim_set_hl(0, "BlinkCmpKindEnum", { fg = colors.enum })
    vim.api.nvim_set_hl(0, "BlinkCmpKindKeyword", { fg = colors.keyword })
    vim.api.nvim_set_hl(0, "BlinkCmpKindSnippet", { fg = colors.snippet })
    vim.api.nvim_set_hl(0, "BlinkCmpKindColor", { fg = colors.color })
    vim.api.nvim_set_hl(0, "BlinkCmpKindFile", { fg = colors.file })
    vim.api.nvim_set_hl(0, "BlinkCmpKindReference", { fg = colors.reference })
    vim.api.nvim_set_hl(0, "BlinkCmpKindFolder", { fg = colors.folder })
    vim.api.nvim_set_hl(0, "BlinkCmpKindEnumMember", { fg = colors.enum_member })
    vim.api.nvim_set_hl(0, "BlinkCmpKindConstant", { fg = colors.constant })
    vim.api.nvim_set_hl(0, "BlinkCmpKindStruct", { fg = colors.struct })
    vim.api.nvim_set_hl(0, "BlinkCmpKindEvent", { fg = colors.event })
    vim.api.nvim_set_hl(0, "BlinkCmpKindOperator", { fg = colors.operator })
    vim.api.nvim_set_hl(0, "BlinkCmpKindTypeParameter", { fg = colors.type_parameter })
    
    -- AI источники
    vim.api.nvim_set_hl(0, "BlinkCmpKindSupermaven", { fg = colors.supermaven, bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpKindCodeium", { fg = colors.codeium, bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpKindCopilot", { fg = colors.copilot, bold = true })
    
    -- Иконки источников
    vim.api.nvim_set_hl(0, "BlinkCmpSource", { fg = colors.label_description })
    vim.api.nvim_set_hl(0, "BlinkCmpSourceLsp", { fg = colors.lsp })
    vim.api.nvim_set_hl(0, "BlinkCmpSourceSupermaven", { fg = colors.supermaven, bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpSourceCodeium", { fg = colors.codeium, bold = true })
    vim.api.nvim_set_hl(0, "BlinkCmpSourceSnippets", { fg = colors.snippets })
    vim.api.nvim_set_hl(0, "BlinkCmpSourceBuffer", { fg = colors.buffer })
    vim.api.nvim_set_hl(0, "BlinkCmpSourcePath", { fg = colors.path })
    vim.api.nvim_set_hl(0, "BlinkCmpSourceEmoji", { fg = colors.emoji })
    
    -- Ghost text
    vim.api.nvim_set_hl(0, "BlinkCmpGhostText", { fg = "#565f89", italic = true })
  end,
}
