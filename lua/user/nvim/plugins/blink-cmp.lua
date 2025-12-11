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
  - LSP         - Language Server Protocol (приоритет: 100)
  - Supermaven  - AI автодополнение (приоритет: 95)
  - Codeium     - AI автодополнение (приоритет: 90)
  - Snippets    - сниппеты через LuaSnip (приоритет: 85)
  - Emoji       - эмодзи (приоритет: 5)
  - Path        - пути к файлам (приоритет: 3)
  - Buffer      - текущий буфер (приоритет: 1)

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

return {
  "saghen/blink.cmp",
  version = "*", -- Используем последнюю стабильную версию
  
  -- Ленивая загрузка при входе в Insert mode
  event = "InsertEnter",
  
  dependencies = {
    -- Сниппеты
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    "L3MON4D3/LuaSnip",

    -- AI автодополнение
    "supermaven-inc/supermaven-nvim",
    "Exafunction/codeium.nvim",

    -- Эмодзи
    "hrsh7th/cmp-emoji",

    -- Адаптер для совместимости с nvim-cmp источниками
    {
      "saghen/blink.compat",
      version = "*",
      lazy = true,
      opts = {},
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
      -- Использовать иконки Nerd Font
      use_nvim_cmp_as_default = true,
      nerd_font_variant = "mono",
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ИСТОЧНИКИ АВТОДОПОЛНЕНИЯ
    -- ═══════════════════════════════════════════════════════════════
    sources = {
      -- Провайдеры по умолчанию
      default = { "lsp", "path", "snippets", "buffer", "codeium", "supermaven", "emoji" },

      -- Настройки провайдеров
      providers = {
        lsp = {
          name = "LSP",
          module = "blink.cmp.sources.lsp",
          score_offset = 100, -- Приоритет LSP выше
        },
        path = {
          name = "Путь",
          module = "blink.cmp.sources.path",
          score_offset = 3,
          opts = {
            trailing_slash = false,
            label_trailing_slash = true,
          },
        },
        snippets = {
          name = "Сниппеты",
          module = "blink.cmp.sources.snippets",
          score_offset = 85,
        },
        buffer = {
          name = "Буфер",
          module = "blink.cmp.sources.buffer",
          score_offset = 1,
        },

        -- Codeium AI автодополнение
        codeium = {
          name = "Codeium",
          module = "blink.compat.source",
          score_offset = 90,
          async = true,
          transform_items = function(_, items)
            -- Добавляем иконку для Codeium
            for _, item in ipairs(items) do
              item.kind = require("blink.cmp.types").CompletionItemKind.Codeium
            end
            return items
          end,
        },

        -- Supermaven AI автодополнение
        supermaven = {
          name = "Supermaven",
          module = "blink.compat.source",
          score_offset = 95,
          async = true,
          transform_items = function(_, items)
            -- Добавляем иконку для Supermaven
            for _, item in ipairs(items) do
              item.kind = require("blink.cmp.types").CompletionItemKind.Supermaven
            end
            return items
          end,
        },

        -- Эмодзи
        emoji = {
          name = "Emoji",
          module = "blink.compat.source",
          score_offset = 5,
          opts = {
            insert = true, -- Вставлять эмодзи напрямую (не код)
          },
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
        
        -- Отрисовка элементов
        draw = {
          -- Колонки
          columns = {
            { "kind_icon" },
            { "label", "label_description", gap = 1 },
            { "source_name" },
          },
          
          -- Компоненты
          components = {
            kind_icon = {
              ellipsis = false,
              text = function(ctx)
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
                  TypeParameter = "",
                  -- AI автодополнение
                  Supermaven = "",
                  Codeium = "",
                  -- Эмодзи
                  Emoji = "󰞅",
                }
                return (kind_icons[ctx.kind] or "󰉿") .. " "
              end,
              highlight = function(ctx)
                return "BlinkCmpKind" .. ctx.kind
              end,
            },
            
            source_name = {
              text = function(ctx)
                return "[" .. ctx.source_name .. "]"
              end,
              highlight = "BlinkCmpSource",
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
  opts_extend = { "sources.default" },
}
