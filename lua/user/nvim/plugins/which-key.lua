--[[
=====================================================================
                          WHICH-KEY
=====================================================================
Показывает подсказки сочетаний клавиш во всплывающем окне.

При нажатии лидер-клавиши (<Space>) появляется окно со всеми
доступными сочетаниями клавиш и их описаниями.

Использование:
  1. Нажмите <Space> и подождите
  2. Появится окно с подсказками
  3. Нажмите нужную клавишу

Команды:
  :WhichKey       - показать все сочетания
  :WhichKey <leader>  - показать сочетания лидера

GitHub: https://github.com/folke/which-key.nvim
=====================================================================
--]]

return {
  "folke/which-key.nvim",
  event = "VeryLazy",
  
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- ОСНОВНЫЕ НАСТРОЙКИ
    -- ═══════════════════════════════════════════════════════════════
    preset = "modern", -- classic, modern, helix
    
    -- Задержка перед показом
    delay = function(ctx)
      return ctx.plugin and 0 or 200
    end,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ИКОНКИ
    -- ═══════════════════════════════════════════════════════════════
    icons = {
      breadcrumb = "»",
      separator = "➜",
      group = "+",
      ellipsis = "…",
      mappings = true,
      rules = {},
      colors = true,
      keys = {
        Up = " ",
        Down = " ",
        Left = " ",
        Right = " ",
        C = "󰘴 ",
        M = "󰘵 ",
        D = "󰘳 ",
        S = "󰘶 ",
        CR = "󰌑 ",
        Esc = "󱊷 ",
        ScrollWheelDown = "󱕐 ",
        ScrollWheelUp = "󱕑 ",
        NL = "󰌑 ",
        BS = "󰁮",
        Space = "󱁐 ",
        Tab = "󰌒 ",
        F1 = "󱊫",
        F2 = "󱊬",
        F3 = "󱊭",
        F4 = "󱊮",
        F5 = "󱊯",
        F6 = "󱊰",
        F7 = "󱊱",
        F8 = "󱊲",
        F9 = "󱊳",
        F10 = "󱊴",
        F11 = "󱊵",
        F12 = "󱊶",
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ОКНО
    -- ═══════════════════════════════════════════════════════════════
    win = {
      no_overlap = true,
      border = "rounded",
      padding = { 1, 2 },
      title = true,
      title_pos = "center",
      zindex = 1000,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- РАСКЛАДКА
    -- ═══════════════════════════════════════════════════════════════
    layout = {
      width = { min = 20 },
      spacing = 3,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ФИЛЬТРЫ
    -- ═══════════════════════════════════════════════════════════════
    filter = function(mapping)
      return true
    end,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ТРИГГЕРЫ
    -- ═══════════════════════════════════════════════════════════════
    triggers = {
      { "<auto>", mode = "nxsot" },
    },
    
    -- Отключить для определённых типов файлов
    disable = {
      bt = {},
      ft = { "TelescopePrompt" },
    },
  },
  
  config = function(_, opts)
    local wk = require("which-key")
    wk.setup(opts)
    
    -- ═══════════════════════════════════════════════════════════════
    -- ГРУППЫ КЛАВИШ
    -- ═══════════════════════════════════════════════════════════════
    wk.add({
      -- Файлы и поиск
      { "<leader>f", group = "Файлы/Поиск", icon = "" },
      { "<leader>ff", desc = "Найти файлы" },
      { "<leader>fg", desc = "Поиск текста (grep)" },
      { "<leader>fb", desc = "Буферы" },
      { "<leader>fh", desc = "Справка" },
      { "<leader>fr", desc = "Недавние файлы" },
      { "<leader>fc", desc = "Слово под курсором" },
      { "<leader>fp", desc = "Проекты" },
      
      -- Буферы
      { "<leader>b", group = "Буферы", icon = "" },
      { "<leader>bd", desc = "Удалить буфер" },
      { "<leader>bp", desc = "Закрепить буфер" },
      { "<leader>bo", desc = "Закрыть остальные" },
      
      -- Git
      { "<leader>g", group = "Git", icon = "" },
      { "<leader>gg", desc = "Lazygit" },
      { "<leader>gf", desc = "Git файлы" },
      { "<leader>gc", desc = "Git коммиты" },
      { "<leader>gs", desc = "Git статус" },
      { "<leader>gb", desc = "Git ветки" },
      
      -- Git hunks
      { "<leader>h", group = "Git hunks", icon = "" },
      { "<leader>hs", desc = "Stage hunk" },
      { "<leader>hr", desc = "Reset hunk" },
      { "<leader>hS", desc = "Stage буфер" },
      { "<leader>hR", desc = "Reset буфер" },
      { "<leader>hp", desc = "Preview hunk" },
      { "<leader>hb", desc = "Blame строки" },
      { "<leader>hd", desc = "Diff" },
      
      -- LSP
      { "<leader>l", group = "LSP", icon = "" },
      { "<leader>la", desc = "Действия кода" },
      { "<leader>lr", desc = "Переименовать" },
      { "<leader>lf", desc = "Форматировать" },
      { "<leader>ld", desc = "Диагностика" },
      { "<leader>ll", desc = "Запустить линтер" },
      { "<leader>lo", desc = "Организовать импорты" },
      { "<leader>ls", desc = "Сортировать импорты" },
      { "<leader>lu", desc = "Удалить неиспользуемое" },
      { "<leader>lm", desc = "Добавить импорты" },
      
      -- Символы
      { "<leader>s", group = "Символы", icon = "" },
      { "<leader>ss", desc = "Символы документа" },
      { "<leader>sS", desc = "Символы проекта" },
      
      -- Терминал
      { "<leader>t", group = "Терминал/Toggle", icon = "" },
      { "<leader>tt", desc = "Открыть терминал" },
      { "<leader>tb", desc = "Toggle blame" },
      { "<leader>td", desc = "Toggle удалённые" },
      
      -- UI переключатели
      { "<leader>u", group = "UI переключатели", icon = "" },
      { "<leader>un", desc = "Скрыть уведомления" },
      { "<leader>uN", desc = "История уведомлений" },
      { "<leader>us", desc = "Проверка орфографии" },
      { "<leader>uw", desc = "Перенос строк" },
      { "<leader>ul", desc = "Номера строк" },
      { "<leader>uL", desc = "Относительные номера" },
      { "<leader>ud", desc = "Диагностика" },
      { "<leader>uT", desc = "Treesitter" },
      { "<leader>uh", desc = "Inlay hints" },
      
      -- AI
      { "<leader>a", group = "AI", icon = "" },
      { "<leader>ai", desc = "Toggle Supermaven" },
      
      -- Быстрые действия
      { "<leader>w", desc = "Сохранить файл", icon = "" },
      { "<leader>W", desc = "Сохранить все", icon = "" },
      { "<leader>q", desc = "Закрыть окно", icon = "" },
      { "<leader>Q", desc = "Закрыть всё", icon = "" },
      { "<leader>e", desc = "Файловый менеджер", icon = "" },
      { "<leader>E", desc = "Фокус на Neo-tree", icon = "" },
      { "<leader>/", desc = "Поиск в буфере", icon = "" },
      { "<leader>:", desc = "История команд", icon = "" },
      { "<leader>.", desc = "Scratch буфер", icon = "" },
      { "<leader>i", desc = "Переключить значение", icon = "󰓡" },
      
      -- Копирование/удаление
      { "<leader>y", desc = "Копировать в системный буфер", mode = { "n", "v" }, icon = "" },
      { "<leader>Y", desc = "Копировать строку в буфер", icon = "" },
      { "<leader>d", desc = "Удалить (не в буфер)", mode = { "n", "v" }, icon = "" },
      { "<leader>p", desc = "Вставить (не заменять)", mode = "x", icon = "" },
    })
  end,
}
