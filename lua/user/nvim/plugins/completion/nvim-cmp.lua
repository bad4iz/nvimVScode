--[[
=====================================================================
                          NVIM-CMP
=====================================================================
Классическая система автодополнения для Neovim с красивым дизайном.

ДИЗАЙН (стиль blink-cmp):
  - Иконки типов слева (Kind icons)
  - Иконки источников СПРАВА (цветные, с bold для AI)
  - Полная цветовая палитра для всех типов
  - Rounded borders для меню и документации
  - Ghost text для предпросмотра

ЦВЕТОВАЯ СХЕМА:
  - Supermaven (AI)  - фиолетовый #d787ff (bold)
  - Codeium (AI)     - бирюзовый #09b6a2 (bold)
  - LSP              - синий #7aa2f7
  - Сниппеты         - желтый #e0af68
  - Путь             - желтый #e0af68
  - Эмодзи           - розовый #f7768e
  - Nerd Font        - фиолетовый #bb9af7
  - Буфер            - серый #565f89

Источники автодополнения (по приоритету):
  - Emoji       - эмодзи (приоритет: 15)
  - Nerd Font   - иконки Nerd Font (приоритет: 15)
  - Supermaven  - AI автодополнение (приоритет: 12)
  - Codeium     - AI автодополнение (приоритет: 11)
  - LSP         - Language Server Protocol (приоритет: 10)
  - LuaSnip     - сниппеты (приоритет: 9)
  - Path        - пути к файлам (приоритет: 3)
  - Buffer      - текущий буфер (приоритет: 1)

Горячие клавиши:
  <C-Space>   - показать меню автодополнения
  <CR>        - подтвердить выбор
  <Tab>       - следующий элемент / раскрыть сниппет
  <S-Tab>     - предыдущий элемент
  <C-e>       - закрыть меню
  <C-j>       - следующий элемент
  <C-k>       - предыдущий элемент
  <C-d>       - прокрутка документации вниз
  <C-u>       - прокрутка документации вверх

GitHub: https://github.com/hrsh7th/nvim-cmp
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
}

-- Иконки для источников автодополнения (показываются справа)
local source_icons = {
  nvim_lsp = "󰒋", -- LSP
  luasnip = "", -- Сниппеты
  buffer = "󰈙", -- Буфер
  path = "󰉋", -- Путь
  emoji = "󰞅", -- Эмодзи
  nerdfont = "", -- Nerd Font
  supermaven = "", -- Supermaven AI
  codeium = "", -- Codeium AI
  nvim_lua = "", -- Lua API
  cmdline = "", -- Командная строка
}

-- Названия источников (для отладки)
local source_names = {
  nvim_lsp = "LSP",
  luasnip = "Snippet",
  buffer = "Buffer",
  path = "Path",
  emoji = "Emoji",
  nerdfont = "NF",
  supermaven = "Supermaven",
  codeium = "Codeium",
  nvim_lua = "Lua",
  cmdline = "Cmd",
}

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",

  dependencies = {
    -- Источники для nvim-cmp
    "hrsh7th/cmp-nvim-lsp", -- LSP
    "hrsh7th/cmp-buffer", -- Buffer
    "hrsh7th/cmp-path", -- Path
    "hrsh7th/cmp-cmdline", -- Командная строка
    "hrsh7th/cmp-nvim-lua", -- Neovim Lua API
    "saadparwaiz1/cmp_luasnip", -- LuaSnip

    -- Сниппеты
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
    },
    "rafamadriz/friendly-snippets",

    -- UI
    "onsails/lspkind.nvim", -- Иконки в меню
    "nvim-tree/nvim-web-devicons",

    -- Emoji и Nerdfont
    "hrsh7th/cmp-emoji",
    {
      "chrisgrieser/cmp-nerdfont",
      config = function()
        -- Настройки для cmp-nerdfont (если нужны)
      end,
    },

    -- AI источники (настраиваются в отдельных файлах)
    -- supermaven.lua уже настраивает supermaven-nvim
    -- здесь только Codeium для nvim-cmp
    {
      "Exafunction/codeium.nvim",
      config = function()
        require("codeium").setup({})
      end,
    },

    -- Автоматические скобки
    {
      "windwp/nvim-autopairs",
      config = function()
        local npairs = require("nvim-autopairs")
        npairs.setup({
          check_ts = true,
          ts_config = {
            lua = { "string", "source" },
            javascript = { "string", "template_string" },
            typescript = { "string", "template_string" },
            javascriptreact = { "string", "template_string" },
            typescriptreact = { "string", "template_string" },
          },
          disable_filetype = { "TelescopePrompt", "spectre_panel" },
          disable_in_macro = true,
          disable_in_visualblock = false,
          disable_in_replace_mode = true,
          ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
          fast_wrap = {
            map = "<M-e>",
            chars = { "{", "[", "(", '"', "'" },
            pattern = [=[[%'%"%>%]%)%}%,]]=],
            end_key = "$",
            keys = "qwertyuiopzxcvbnmasdfghjkl",
            check_comma = true,
            highlight = "Search",
            highlight_grey = "Comment",
          },
          enable_check_bracket_line = true,
          map_bs = true,
          map_c_h = false,
          map_c_w = false,
        })

        -- Правила для пробелов между скобками
        local Rule = require("nvim-autopairs.rule")
        local cond = require("nvim-autopairs.conds")
        local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }

        npairs.add_rules({
          Rule(" ", " ")
            :with_pair(function(opt)
              local pair = opt.line:sub(opt.col - 1, opt.col)
              return vim.tbl_contains({
                brackets[1][1] .. brackets[1][2],
                brackets[2][1] .. brackets[2][2],
                brackets[3][1] .. brackets[3][2],
              }, pair)
            end)
            :with_move(cond.none())
            :with_cr(cond.none())
            :with_del(function(opt)
              local col = vim.api.nvim_win_get_cursor(0)[2]
              local context = opt.line:sub(col - 1, col + 2)
              return vim.tbl_contains({
                brackets[1][1] .. "  " .. brackets[1][2],
                brackets[2][1] .. "  " .. brackets[2][2],
                brackets[3][1] .. "  " .. brackets[3][2],
              }, context)
            end),
        })

        -- Стрелочные функции для JS/TS
        npairs.add_rules({
          Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
            :use_regex(true)
            :set_end_pair_length(2),
        })

        -- Интеграция с nvim-cmp (добавляем скобки после автодополнения функций)
        local cmp_autopairs = require("nvim-autopairs.completion.cmp")
        local cmp = require("cmp")
        cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
      end,
    },
  },

  config = function()
    local cmp = require("cmp")
    local luasnip = require("luasnip")
    local lspkind = require("lspkind")

    -- Загрузка friendly-snippets
    require("luasnip.loaders.from_vscode").lazy_load()

    -- ═══════════════════════════════════════════════════════════════
    -- НАСТРОЙКА NVIM-CMP
    -- ═══════════════════════════════════════════════════════════════
    cmp.setup({
      -- Движок сниппетов
      snippet = {
        expand = function(args)
          luasnip.lsp_expand(args.body)
        end,
      },

      -- Окно автодополнения
      window = {
        completion = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:CmpPmenu,CursorLine:CmpSel,Search:None",
        }),
        documentation = cmp.config.window.bordered({
          border = "rounded",
          winhighlight = "Normal:CmpDoc",
        }),
      },

      -- ═══════════════════════════════════════════════════════════════
      -- СОЧЕТАНИЯ КЛАВИШ
      -- ═══════════════════════════════════════════════════════════════
      mapping = cmp.mapping.preset.insert({
        -- Показать меню автодополнения
        ["<C-Space>"] = cmp.mapping.complete(),

        -- Закрыть меню
        ["<C-e>"] = cmp.mapping.abort(),

        -- Подтвердить выбор
        ["<CR>"] = cmp.mapping.confirm({ select = false }),

        -- Tab - следующий элемент или раскрыть сниппет
        ["<Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_next_item()
          elseif luasnip.expandable() then
            luasnip.expand()
          elseif luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          else
            fallback()
          end
        end, { "i", "s" }),

        -- Shift-Tab - предыдущий элемент
        ["<S-Tab>"] = cmp.mapping(function(fallback)
          if cmp.visible() then
            cmp.select_prev_item()
          elseif luasnip.jumpable(-1) then
            luasnip.jump(-1)
          else
            fallback()
          end
        end, { "i", "s" }),

        -- C-j/C-k - навигация
        ["<C-j>"] = cmp.mapping.select_next_item(),
        ["<C-k>"] = cmp.mapping.select_prev_item(),

        -- Прокрутка документации
        ["<C-d>"] = cmp.mapping.scroll_docs(4),
        ["<C-u>"] = cmp.mapping.scroll_docs(-4),
      }),

      -- ═══════════════════════════════════════════════════════════════
      -- ФОРМАТИРОВАНИЕ ЭЛЕМЕНТОВ МЕНЮ (стиль blink-cmp)
      -- ═══════════════════════════════════════════════════════════════
      formatting = {
        -- Порядок: иконка типа | текст | иконка источника
        fields = { "kind", "abbr", "menu" },
        format = function(entry, vim_item)
          local kind = vim_item.kind
          local source_name = entry.source.name

          -- Для путей - показываем иконку файла вместо kind
          if source_name == "path" then
            local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
            if icon then
              vim_item.kind = icon .. " "
              vim_item.kind_hl_group = hl_group
            else
              vim_item.kind = (kind_icons[kind] or "󰈙") .. " "
            end
          else
            -- Иконка типа слева
            vim_item.kind = (kind_icons[kind] or kind_icons.Text) .. " "
          end

          -- Ограничиваем длину текста
          if #vim_item.abbr > 50 then
            vim_item.abbr = vim_item.abbr:sub(1, 47) .. "..."
          end

          -- Иконка источника справа + highlight группа
          local source_icon = source_icons[source_name] or "󰋽"
          vim_item.menu = " " .. source_icon

          -- Устанавливаем highlight группу для иконки источника
          vim_item.menu_hl_group = "CmpItemMenu" .. (source_name:gsub("^%l", string.upper):gsub("_", ""))

          return vim_item
        end,
      },

      -- ═══════════════════════════════════════════════════════════════
      -- ИСТОЧНИКИ АВТОДОПОЛНЕНИЯ (по приоритету)
      -- ═══════════════════════════════════════════════════════════════
      sources = cmp.config.sources({
        { name = "emoji", priority = 15, max_item_count = 20 },
        { name = "nerdfont", priority = 15, max_item_count = 20 },
        { name = "supermaven", priority = 12, max_item_count = 5 },
        { name = "codeium", priority = 11, max_item_count = 5 },
        { name = "nvim_lsp", priority = 10, max_item_count = 20 },
        { name = "luasnip", priority = 9, max_item_count = 10 },
        { name = "nvim_lua", priority = 8 },
        { name = "path", priority = 3, max_item_count = 10 },
        { name = "buffer", priority = 1, max_item_count = 10, keyword_length = 3 },
      }),

      -- ═══════════════════════════════════════════════════════════════
      -- НАСТРОЙКИ СОРТИРОВКИ
      -- ═══════════════════════════════════════════════════════════════
      sorting = {
        priority_weight = 2,
        comparators = {
          cmp.config.compare.offset,
          cmp.config.compare.exact,
          cmp.config.compare.score,
          cmp.config.compare.recently_used,
          cmp.config.compare.locality,
          cmp.config.compare.kind,
          cmp.config.compare.sort_text,
          cmp.config.compare.length,
          cmp.config.compare.order,
        },
      },

      -- ═══════════════════════════════════════════════════════════════
      -- ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ
      -- ═══════════════════════════════════════════════════════════════
      experimental = {
        ghost_text = false, -- Отключено, используем Supermaven inline
      },

      -- Производительность
      performance = {
        debounce = 60,
        throttle = 30,
        fetching_timeout = 500,
      },
    })

    -- ═══════════════════════════════════════════════════════════════
    -- НАСТРОЙКА ДЛЯ КОМАНДНОЙ СТРОКИ
    -- ═══════════════════════════════════════════════════════════════
    -- Автодополнение для поиска /
    cmp.setup.cmdline("/", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = {
        { name = "buffer" },
      },
    })

    -- Автодополнение для команд :
    cmp.setup.cmdline(":", {
      mapping = cmp.mapping.preset.cmdline(),
      sources = cmp.config.sources({
        { name = "path" },
      }, {
        { name = "cmdline" },
      }),
    })

    -- ═══════════════════════════════════════════════════════════════
    -- ЦВЕТОВАЯ СХЕМА (стиль blink-cmp)
    -- ═══════════════════════════════════════════════════════════════

    -- Основные цвета меню
    vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "#1a1b26", fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "CmpSel", { bg = "#283457", bold = true })
    vim.api.nvim_set_hl(0, "CmpDoc", { bg = "#1a1b26", fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#7aa2f7", bg = "#1a1b26" })
    vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#565f89", italic = true })

    -- Цвета для типов (Kind) - полная палитра
    vim.api.nvim_set_hl(0, "CmpItemKindText", { fg = "#9aa5ce" })
    vim.api.nvim_set_hl(0, "CmpItemKindMethod", { fg = "#7aa2f7" })
    vim.api.nvim_set_hl(0, "CmpItemKindFunction", { fg = "#bb9af7" })
    vim.api.nvim_set_hl(0, "CmpItemKindConstructor", { fg = "#f7768e" })
    vim.api.nvim_set_hl(0, "CmpItemKindField", { fg = "#73daca" })
    vim.api.nvim_set_hl(0, "CmpItemKindVariable", { fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "CmpItemKindClass", { fg = "#ff9e64" })
    vim.api.nvim_set_hl(0, "CmpItemKindInterface", { fg = "#73daca" })
    vim.api.nvim_set_hl(0, "CmpItemKindModule", { fg = "#ff9e64" })
    vim.api.nvim_set_hl(0, "CmpItemKindProperty", { fg = "#73daca" })
    vim.api.nvim_set_hl(0, "CmpItemKindUnit", { fg = "#ff9e64" })
    vim.api.nvim_set_hl(0, "CmpItemKindValue", { fg = "#9ece6a" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnum", { fg = "#ff9e64" })
    vim.api.nvim_set_hl(0, "CmpItemKindKeyword", { fg = "#bb9af7" })
    vim.api.nvim_set_hl(0, "CmpItemKindSnippet", { fg = "#e0af68" })
    vim.api.nvim_set_hl(0, "CmpItemKindColor", { fg = "#9ece6a" })
    vim.api.nvim_set_hl(0, "CmpItemKindFile", { fg = "#7aa2f7" })
    vim.api.nvim_set_hl(0, "CmpItemKindReference", { fg = "#7aa2f7" })
    vim.api.nvim_set_hl(0, "CmpItemKindFolder", { fg = "#e0af68" })
    vim.api.nvim_set_hl(0, "CmpItemKindEnumMember", { fg = "#73daca" })
    vim.api.nvim_set_hl(0, "CmpItemKindConstant", { fg = "#ff9e64" })
    vim.api.nvim_set_hl(0, "CmpItemKindStruct", { fg = "#ff9e64" })
    vim.api.nvim_set_hl(0, "CmpItemKindEvent", { fg = "#ff9e64" })
    vim.api.nvim_set_hl(0, "CmpItemKindOperator", { fg = "#bb9af7" })
    vim.api.nvim_set_hl(0, "CmpItemKindTypeParameter", { fg = "#73daca" })

    -- AI источники (Kind)
    vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#d787ff", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#09b6a2", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6cc644", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemKindEmoji", { fg = "#f7768e" })

    -- Цвета для иконок источников (справа)
    vim.api.nvim_set_hl(0, "CmpItemMenuNvimLsp", { fg = "#7aa2f7" }) -- LSP - синий
    vim.api.nvim_set_hl(0, "CmpItemMenuSupermaven", { fg = "#d787ff", bold = true }) -- Supermaven - фиолетовый
    vim.api.nvim_set_hl(0, "CmpItemMenuCodeium", { fg = "#09b6a2", bold = true }) -- Codeium - бирюзовый
    vim.api.nvim_set_hl(0, "CmpItemMenuLuasnip", { fg = "#e0af68" }) -- Сниппеты - желтый
    vim.api.nvim_set_hl(0, "CmpItemMenuBuffer", { fg = "#565f89" }) -- Буфер - серый
    vim.api.nvim_set_hl(0, "CmpItemMenuPath", { fg = "#e0af68" }) -- Путь - желтый
    vim.api.nvim_set_hl(0, "CmpItemMenuEmoji", { fg = "#f7768e" }) -- Эмодзи - розовый
    vim.api.nvim_set_hl(0, "CmpItemMenuNerdfont", { fg = "#bb9af7" }) -- Nerd Font - фиолетовый
    vim.api.nvim_set_hl(0, "CmpItemMenuNvimLua", { fg = "#7aa2f7" }) -- Lua API - синий
    vim.api.nvim_set_hl(0, "CmpItemMenuCmdline", { fg = "#9aa5ce" }) -- Cmd - светло-серый

    -- Настройки
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
  end,
}
