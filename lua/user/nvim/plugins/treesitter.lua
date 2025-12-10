--[[
=====================================================================
                      NVIM-TREESITTER
=====================================================================
Парсер для умной подсветки синтаксиса и анализа кода.

Возможности:
  - Подсветка синтаксиса на основе AST
  - Умные отступы
  - Инкрементальный выбор
  - Текстовые объекты на основе синтаксиса

Горячие клавиши:
  <C-Space>  - начать инкрементальный выбор
  <BS>       - уменьшить выбор (в visual mode)
  
Команды:
  :TSInstall {язык}     - установить парсер
  :TSUpdate             - обновить все парсеры
  :TSInstallInfo        - информация о парсерах
  :InspectTree          - показать AST дерево

GitHub: https://github.com/nvim-treesitter/nvim-treesitter
=====================================================================
--]]

return {
  "nvim-treesitter/nvim-treesitter",
  version = false, -- Последняя версия
  build = ":TSUpdate", -- Обновить парсеры после установки
  
  -- Загружать при событиях открытия файлов
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  
  -- Ленивая загрузка
  lazy = vim.fn.argc(-1) == 0,
  
  -- Дополнительные модули
  dependencies = {
    -- Текстовые объекты на основе treesitter
    "nvim-treesitter/nvim-treesitter-textobjects",
  },
  
  init = function(plugin)
    -- Добавляем запрос до загрузки плагина
    require("lazy.core.loader").add_to_rtp(plugin)
    require("nvim-treesitter.query_predicates")
  end,
  
  cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
  
  ---@type TSConfig
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- ПОДСВЕТКА СИНТАКСИСА
    -- ═══════════════════════════════════════════════════════════════
    highlight = {
      enable = true,
      -- Отключить для очень больших файлов
      disable = function(lang, buf)
        local max_filesize = 100 * 1024 -- 100 KB
        local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
        if ok and stats and stats.size > max_filesize then
          return true
        end
      end,
      -- Дополнительные регулярные выражения для подсветки
      additional_vim_regex_highlighting = false,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ОТСТУПЫ
    -- ═══════════════════════════════════════════════════════════════
    indent = {
      enable = true,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- АВТОМАТИЧЕСКАЯ УСТАНОВКА ПАРСЕРОВ
    -- ═══════════════════════════════════════════════════════════════
    auto_install = true,
    
    -- ═══════════════════════════════════════════════════════════════
    -- ЯЗЫКИ ДЛЯ УСТАНОВКИ
    -- ═══════════════════════════════════════════════════════════════
    ensure_installed = {
      -- Веб-разработка
      "html",
      "css",
      "scss",
      "javascript",
      "typescript",
      "tsx",
      "json",
      "jsonc",
      
      -- React/Vue/Svelte
      "vue",
      "svelte",
      
      -- Конфигурационные файлы
      "yaml",
      "toml",
      "xml",
      
      -- Markdown
      "markdown",
      "markdown_inline",
      
      -- Скрипты
      "bash",
      "fish",
      
      -- Lua (для Neovim конфигурации)
      "lua",
      "luadoc",
      "luap",
      
      -- Другие
      "vim",
      "vimdoc",
      "query",
      "regex",
      "diff",
      "git_config",
      "gitcommit",
      "gitignore",
      "dockerfile",
      "graphql",
      "prisma",
      "sql",
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ИНКРЕМЕНТАЛЬНЫЙ ВЫБОР
    -- ═══════════════════════════════════════════════════════════════
    incremental_selection = {
      enable = true,
      keymaps = {
        init_selection = "<C-space>",    -- Начать выбор
        node_incremental = "<C-space>",  -- Расширить выбор
        scope_incremental = false,       -- Расширить до области
        node_decremental = "<bs>",       -- Уменьшить выбор
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ТЕКСТОВЫЕ ОБЪЕКТЫ
    -- ═══════════════════════════════════════════════════════════════
    textobjects = {
      -- Выбор текстовых объектов
      select = {
        enable = true,
        lookahead = true, -- Искать вперёд
        keymaps = {
          -- Функции
          ["af"] = { query = "@function.outer", desc = "Вся функция" },
          ["if"] = { query = "@function.inner", desc = "Тело функции" },
          
          -- Классы
          ["ac"] = { query = "@class.outer", desc = "Весь класс" },
          ["ic"] = { query = "@class.inner", desc = "Тело класса" },
          
          -- Условия
          ["ai"] = { query = "@conditional.outer", desc = "Всё условие" },
          ["ii"] = { query = "@conditional.inner", desc = "Тело условия" },
          
          -- Циклы
          ["al"] = { query = "@loop.outer", desc = "Весь цикл" },
          ["il"] = { query = "@loop.inner", desc = "Тело цикла" },
          
          -- Параметры/Аргументы
          ["aa"] = { query = "@parameter.outer", desc = "Параметр с разделителем" },
          ["ia"] = { query = "@parameter.inner", desc = "Параметр" },
          
          -- Комментарии
          ["a/"] = { query = "@comment.outer", desc = "Комментарий" },
        },
      },
      
      -- Перемещение между текстовыми объектами
      move = {
        enable = true,
        set_jumps = true,
        goto_next_start = {
          ["]f"] = { query = "@function.outer", desc = "Следующая функция" },
          ["]c"] = { query = "@class.outer", desc = "Следующий класс" },
          ["]a"] = { query = "@parameter.inner", desc = "Следующий параметр" },
        },
        goto_next_end = {
          ["]F"] = { query = "@function.outer", desc = "Конец следующей функции" },
          ["]C"] = { query = "@class.outer", desc = "Конец следующего класса" },
        },
        goto_previous_start = {
          ["[f"] = { query = "@function.outer", desc = "Предыдущая функция" },
          ["[c"] = { query = "@class.outer", desc = "Предыдущий класс" },
          ["[a"] = { query = "@parameter.inner", desc = "Предыдущий параметр" },
        },
        goto_previous_end = {
          ["[F"] = { query = "@function.outer", desc = "Конец предыдущей функции" },
          ["[C"] = { query = "@class.outer", desc = "Конец предыдущего класса" },
        },
      },
      
      -- Обмен текстовыми объектами
      swap = {
        enable = true,
        swap_next = {
          ["<leader>a"] = { query = "@parameter.inner", desc = "Поменять с следующим параметром" },
        },
        swap_previous = {
          ["<leader>A"] = { query = "@parameter.inner", desc = "Поменять с предыдущим параметром" },
        },
      },
    },
  },
  
  ---@param opts TSConfig
  config = function(_, opts)
    require("nvim-treesitter.configs").setup(opts)
    
    -- Использовать treesitter для фолдинга
    vim.opt.foldmethod = "expr"
    vim.opt.foldexpr = "nvim_treesitter#foldexpr()"
    vim.opt.foldenable = false -- По умолчанию фолды открыты
  end,
}
