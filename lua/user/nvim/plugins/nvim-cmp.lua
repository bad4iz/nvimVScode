--[[
=====================================================================
                          NVIM-CMP
=====================================================================
Классическая система автодополнения для Neovim.

Источники автодополнения:
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

-- Иконки для источников автодополнения
local source_names = {
  nvim_lsp = "LSP",
  luasnip = "Snippet",
  buffer = "Buffer",
  path = "Path",
  emoji = "Emoji",
  nerdfont = "NF",
  supermaven = "SM",
  codeium = "Codeium",
  nvim_lua = "Lua",
  cmdline = "Cmd",
}

return {
  "hrsh7th/nvim-cmp",
  event = "InsertEnter",

  dependencies = {
    -- Источники для nvim-cmp
    "hrsh7th/cmp-nvim-lsp",       -- LSP
    "hrsh7th/cmp-buffer",         -- Buffer
    "hrsh7th/cmp-path",           -- Path
    "hrsh7th/cmp-cmdline",        -- Командная строка
    "hrsh7th/cmp-nvim-lua",       -- Neovim Lua API
    "saadparwaiz1/cmp_luasnip",   -- LuaSnip

    -- Сниппеты
    {
      "L3MON4D3/LuaSnip",
      version = "v2.*",
      build = "make install_jsregexp",
    },
    "rafamadriz/friendly-snippets",

    -- UI
    "onsails/lspkind.nvim",       -- Иконки в меню
    "nvim-tree/nvim-web-devicons",

    -- Emoji и Nerdfont
    "hrsh7th/cmp-emoji",
    {
      "chrisgrieser/cmp-nerdfont",
      config = function()
        -- Настройки для cmp-nerdfont (если нужны)
      end,
    },

    -- AI источники
    {
      "supermaven-inc/supermaven-nvim",
      config = function()
        require("supermaven-nvim").setup({
          keymaps = {
            accept_suggestion = "<C-y>",
            clear_suggestion = "<C-]>",
            accept_word = "<C-l>",
          },
          ignore_filetypes = {},
          color = {
            suggestion_color = "#d787ff",
            cterm = 244,
          },
          disable_inline_completion = false, -- false = inline подсказки включены
          disable_keymaps = false,
        })
      end,
    },

    -- Codeium источник для nvim-cmp
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
      -- ФОРМАТИРОВАНИЕ ЭЛЕМЕНТОВ МЕНЮ
      -- ═══════════════════════════════════════════════════════════════
      formatting = {
        fields = { "kind", "abbr", "menu" },
        format = lspkind.cmp_format({
          mode = "symbol_text",
          maxwidth = 50,
          ellipsis_char = "...",
          show_labelDetails = true,

          before = function(entry, vim_item)
            -- Кастомные иконки для типов
            vim_item.kind = string.format("%s %s", kind_icons[vim_item.kind] or "", vim_item.kind)

            -- Название источника
            vim_item.menu = source_names[entry.source.name] or entry.source.name

            -- Для путей - показываем иконку файла
            if entry.source.name == "path" then
              local icon, hl_group = require("nvim-web-devicons").get_icon(entry:get_completion_item().label)
              if icon then
                vim_item.kind = icon
                vim_item.kind_hl_group = hl_group
              end
            end

            return vim_item
          end,
        }),
      },

      -- ═══════════════════════════════════════════════════════════════
      -- ИСТОЧНИКИ АВТОДОПОЛНЕНИЯ (по приоритету)
      -- ═══════════════════════════════════════════════════════════════
      sources = cmp.config.sources({
        { name = "emoji",      priority = 15, max_item_count = 20 },
        { name = "nerdfont",   priority = 15, max_item_count = 20 },
        { name = "supermaven", priority = 12, max_item_count = 5 },
        { name = "codeium",    priority = 11, max_item_count = 5 },
        { name = "nvim_lsp",   priority = 10, max_item_count = 20 },
        { name = "luasnip",    priority = 9,  max_item_count = 10 },
        { name = "nvim_lua",   priority = 8 },
        { name = "path",       priority = 3,  max_item_count = 10 },
        { name = "buffer",     priority = 1,  max_item_count = 10, keyword_length = 3 },
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
        ghost_text = {
          hl_group = "CmpGhostText",
        },
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
    -- ЦВЕТОВАЯ СХЕМА
    -- ═══════════════════════════════════════════════════════════════
    vim.api.nvim_set_hl(0, "CmpPmenu", { bg = "#1a1b26", fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "CmpSel", { bg = "#283457", bold = true })
    vim.api.nvim_set_hl(0, "CmpDoc", { bg = "#1a1b26", fg = "#c0caf5" })
    vim.api.nvim_set_hl(0, "CmpGhostText", { fg = "#565f89", italic = true })

    -- Границы
    vim.api.nvim_set_hl(0, "CmpBorder", { fg = "#7aa2f7", bg = "#1a1b26" })

    -- AI источники (Kind)
    vim.api.nvim_set_hl(0, "CmpItemKindSupermaven", { fg = "#d787ff", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemKindCodeium", { fg = "#09b6a2", bold = true })
    vim.api.nvim_set_hl(0, "CmpItemKindCopilot", { fg = "#6cc644", bold = true })

    -- Настройки
    vim.opt.completeopt = { "menu", "menuone", "noselect" }
  end,
}
