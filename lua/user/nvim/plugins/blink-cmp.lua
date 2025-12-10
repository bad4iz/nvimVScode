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
      default = { "lsp", "path", "snippets", "buffer" },
      
      -- Включить cmdline автодополнение
      cmdline = {},
      
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
          score_offset = 80,
        },
        buffer = {
          name = "Буфер",
          module = "blink.cmp.sources.buffer",
          score_offset = 1,
        },
      },
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
        selection = "auto_insert",
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
                  Supermaven = "",
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
