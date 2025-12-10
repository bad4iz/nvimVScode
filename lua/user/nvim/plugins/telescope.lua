--[[
=====================================================================
                        TELESCOPE.NVIM
=====================================================================
Мощный fuzzy finder для Neovim.

СТАТУС: ОТКЛЮЧЕН (используется snacks.picker)
Для включения: удалите строку "if true then return {} end" ниже
и отключите snacks.picker в snacks.lua

Горячие клавиши (после включения):
  <leader>ff  - найти файлы
  <leader>fg  - поиск по тексту (grep)  
  <leader>fb  - буферы
  <leader>fh  - справка
  <leader>fr  - недавние файлы
  <leader>/   - поиск в буфере

Преимущества перед snacks.picker:
  - Больше расширений
  - Более зрелая экосистема
  - Больше документации

GitHub: https://github.com/nvim-telescope/telescope.nvim
=====================================================================
--]]

-- ╔═══════════════════════════════════════════════════════════════╗
-- ║ ВНИМАНИЕ: Telescope отключен! Используется snacks.picker     ║
-- ║ Удалите следующую строку для активации Telescope             ║
-- ╚═══════════════════════════════════════════════════════════════╝
if true then return {} end -- WARN: УДАЛИТЕ ЭТУ СТРОКУ ДЛЯ АКТИВАЦИИ TELESCOPE

return {
  "nvim-telescope/telescope.nvim",
  tag = "0.1.8", -- Стабильная версия
  dependencies = {
    "nvim-lua/plenary.nvim",
    -- Быстрый поиск (компилируемый)
    {
      "nvim-telescope/telescope-fzf-native.nvim",
      build = "make",
      cond = function()
        return vim.fn.executable("make") == 1
      end,
    },
    -- Иконки
    "nvim-tree/nvim-web-devicons",
    -- UI для выбора
    "nvim-telescope/telescope-ui-select.nvim",
  },
  
  cmd = "Telescope",
  
  opts = {
    defaults = {
      -- Настройки отображения
      prompt_prefix = "   ",
      selection_caret = " ",
      entry_prefix = "   ",
      
      -- Сортировка
      sorting_strategy = "ascending",
      layout_strategy = "horizontal",
      
      layout_config = {
        horizontal = {
          prompt_position = "top",
          preview_width = 0.55,
          results_width = 0.8,
        },
        vertical = {
          mirror = false,
        },
        width = 0.87,
        height = 0.80,
        preview_cutoff = 120,
      },
      
      -- Игнорируемые файлы
      file_ignore_patterns = {
        "node_modules",
        ".git/",
        "dist/",
        "build/",
        "%.lock",
        "__pycache__",
        "%.sqlite3",
        "%.ipynb",
        "vendor",
        "%.jpg",
        "%.jpeg",
        "%.png",
        "%.svg",
        "%.otf",
        "%.ttf",
      },
      
      -- Путь к файлам
      path_display = { "truncate" },
      
      -- Границы окна
      border = true,
      borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
      
      -- Маппинги
      mappings = {
        i = {
          ["<C-j>"] = require("telescope.actions").move_selection_next,
          ["<C-k>"] = require("telescope.actions").move_selection_previous,
          ["<C-q>"] = require("telescope.actions").send_selected_to_qflist + require("telescope.actions").open_qflist,
          ["<Esc>"] = require("telescope.actions").close,
          ["<C-u>"] = false, -- Очистка ввода
          ["<C-d>"] = require("telescope.actions").delete_buffer,
        },
        n = {
          ["q"] = require("telescope.actions").close,
          ["<C-d>"] = require("telescope.actions").delete_buffer,
        },
      },
      
      -- Превью
      preview = {
        treesitter = true,
      },
      
      -- Цвета для результатов
      color_devicons = true,
      
      -- Показывать скрытые файлы
      hidden = true,
    },
    
    pickers = {
      -- Поиск файлов
      find_files = {
        hidden = true,
        find_command = { "rg", "--files", "--hidden", "--glob", "!.git/*" },
      },
      
      -- Буферы
      buffers = {
        show_all_buffers = true,
        sort_lastused = true,
        mappings = {
          i = {
            ["<C-d>"] = "delete_buffer",
          },
        },
      },
      
      -- Живой поиск
      live_grep = {
        additional_args = function()
          return { "--hidden" }
        end,
      },
    },
    
    extensions = {
      -- FZF для быстрого поиска
      fzf = {
        fuzzy = true,
        override_generic_sorter = true,
        override_file_sorter = true,
        case_mode = "smart_case",
      },
      
      -- UI Select
      ["ui-select"] = {
        require("telescope.themes").get_dropdown({}),
      },
    },
  },
  
  config = function(_, opts)
    local telescope = require("telescope")
    telescope.setup(opts)
    
    -- Загрузка расширений
    pcall(telescope.load_extension, "fzf")
    pcall(telescope.load_extension, "ui-select")
  end,
  
  -- Горячие клавиши
  keys = {
    { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Найти файлы" },
    { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Поиск текста (grep)" },
    { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Буферы" },
    { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Справка" },
    { "<leader>fr", "<cmd>Telescope oldfiles<cr>", desc = "Недавние файлы" },
    { "<leader>fc", "<cmd>Telescope grep_string<cr>", desc = "Найти слово под курсором" },
    { "<leader>/", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Поиск в буфере" },
    { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "История команд" },
    { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Git коммиты" },
    { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Git статус" },
    { "<leader>gb", "<cmd>Telescope git_branches<cr>", desc = "Git ветки" },
    { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Диагностика" },
    { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Сочетания клавиш" },
  },
}
