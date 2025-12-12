--[[
=====================================================================
                          FLASH.NVIM
=====================================================================
Плагин для сверхбыстрой навигации по тексту.

Как использовать:
  s{символ}{символ}  - прыжок к любому месту в видимой области
  S                  - выбор с помощью Treesitter
  r                  - удалённый режим (в operator-pending)
  <c-s>              - переключить Flash в поиске (/)
  
Преимущества перед leap.nvim:
  - Интеграция с Treesitter для выбора узлов
  - Работает в режиме поиска
  - Лучшая поддержка удалённых операций
  
Автор: folke (автор lazy.nvim)
GitHub: https://github.com/folke/flash.nvim
=====================================================================
--]]

return {
  "folke/flash.nvim",
  event = "VeryLazy", -- Ленивая загрузка

  ---@type Flash.Config
  opts = {
    -- Метки для прыжков (удобные клавиши домашнего ряда)
    labels = "asdfghjklqwertyuiopzxcvbnm",

    -- Настройки поиска
    search = {
      -- Искать при вводе (инкрементальный поиск)
      multi_window = true, -- Искать во всех окнах
      forward = true, -- Искать вперёд
      wrap = true, -- Переходить в начало при достижении конца
      mode = "exact", -- exact, search, fuzzy
    },

    -- Настройки прыжков
    jump = {
      jumplist = true, -- Добавлять в jumplist
      pos = "start", -- Позиция курсора после прыжка: start, end, range
      history = false,
      register = false,
      nohlsearch = true, -- Убирать подсветку после прыжка
      autojump = false, -- Автопрыжок если одно совпадение
    },

    -- Настройки меток
    label = {
      uppercase = false, -- Использовать заглавные буквы
      exclude = "", -- Исключить символы из меток
      current = true, -- Показывать метку на текущей позиции
      after = true, -- Показывать метку после совпадения
      before = false, -- Показывать метку до совпадения
      style = "overlay", -- overlay, right_align, inline
      reuse = "lowercase", -- Переиспользовать метки
      rainbow = {
        enabled = false, -- Радужные метки для лучшей видимости
        shade = 5,
      },
    },

    -- Подсветка
    highlight = {
      backdrop = true, -- Затемнять фон
      matches = true, -- Подсвечивать совпадения
      priority = 5000,
      groups = {
        match = "FlashMatch",
        current = "FlashCurrent",
        backdrop = "FlashBackdrop",
        label = "FlashLabel",
      },
    },

    -- Режимы
    modes = {
      -- Режим обычного поиска с /
      search = {
        enabled = true,
        highlight = { backdrop = false },
        jump = { history = true, register = true, nohlsearch = true },
        search = {
          -- Автоматически показывать метки
          -- Нажмите <c-s> для переключения
          mode = function(str)
            return "\\<" .. str
          end,
        },
      },

      -- Режим символа (s/S)
      char = {
        enabled = true,
        config = function(opts)
          -- Автоподсказки только если не в operator-pending
          opts.autohide = opts.autohide or (vim.fn.mode(true):find("no") and vim.v.operator == "y")
          -- Отключить прыжок метки для ; и ,
          opts.jump_labels = opts.jump_labels
            and vim.v.count == 0
            and vim.fn.reg_executing() == ""
            and vim.fn.reg_recording() == ""
        end,
        autohide = false,
        jump_labels = false,
        multi_line = true,
        label = { exclude = "hjkliardc" },
        keys = { "f", "F", "t", "T", ";", "," },
        char_actions = function(motion)
          return {
            [";"] = "next",
            [","] = "prev",
            [motion:lower()] = "next",
            [motion:upper()] = "prev",
          }
        end,
        search = { wrap = false },
        highlight = { backdrop = true },
        jump = { register = false },
      },

      -- Treesitter режим (выбор узлов)
      treesitter = {
        labels = "abcdefghijklmnopqrstuvwxyz",
        jump = { pos = "range" },
        search = { incremental = false },
        label = { before = true, after = true, style = "inline" },
        highlight = {
          backdrop = false,
          matches = false,
        },
      },

      -- Treesitter поиск
      treesitter_search = {
        jump = { pos = "range" },
        search = { multi_window = true, wrap = true, incremental = false },
        remote_op = { restore = true },
        label = { before = true, after = true, style = "inline" },
      },

      -- Удалённый режим (для операторов)
      remote = {
        remote_op = { restore = true, motion = true },
      },
    },

    -- Интеграция с плагинами
    prompt = {
      enabled = true,
      prefix = { { "⚡", "FlashPromptIcon" } },
      win_config = {
        relative = "editor",
        width = 1,
        height = 1,
        row = -1,
        col = 0,
        zindex = 1000,
      },
    },

    -- Удалённый оператор
    remote_op = {
      restore = false,
      motion = false,
    },
  },

  -- Сочетания клавиш
  keys = {
    {
      "s",
      mode = { "n", "x", "o" },
      function()
        require("flash").jump()
      end,
      desc = "Flash: Прыжок",
    },
    {
      "S",
      mode = { "n", "x", "o" },
      function()
        require("flash").treesitter()
      end,
      desc = "Flash: Treesitter выбор",
    },
    {
      "r",
      mode = "o",
      function()
        require("flash").remote()
      end,
      desc = "Flash: Удалённый режим",
    },
    {
      "R",
      mode = { "o", "x" },
      function()
        require("flash").treesitter_search()
      end,
      desc = "Flash: Treesitter поиск",
    },
    {
      "<c-s>",
      mode = { "c" },
      function()
        require("flash").toggle()
      end,
      desc = "Flash: Переключить в поиске",
    },
  },
}
