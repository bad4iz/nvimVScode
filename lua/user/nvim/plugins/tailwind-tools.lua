--[[
=====================================================================
                      TAILWIND-TOOLS
=====================================================================
Утилиты для работы с Tailwind CSS в Neovim.

Возможности:
  - Подсветка цветов классов
  - Сортировка классов
  - Скрытие/показ длинных классов
  - Автодополнение (через LSP)

Горячие клавиши:
  <leader>tc  - скрыть/показать классы (conceal)
  <leader>ts  - сортировать классы

Команды:
  :TailwindConcealToggle  - переключить скрытие
  :TailwindSort           - сортировать классы
  :TailwindSortSelection  - сортировать выделенные классы
  :TailwindColorToggle    - переключить подсветку цветов

GitHub: https://github.com/luckasRanaworrison/tailwind-tools.nvim
=====================================================================
--]]

return {
  "luckasRanarison/tailwind-tools.nvim",
  name = "tailwind-tools",
  build = ":UpdateRemotePlugins",
  
  -- Загружать для веб-файлов
  ft = { 
    "html", "css", "scss", 
    "javascript", "javascriptreact", 
    "typescript", "typescriptreact",
    "vue", "svelte"
  },
  
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "nvim-telescope/telescope.nvim", -- Опционально, для picker
    "neovim/nvim-lspconfig",         -- Для LSP
  },
  
  opts = {
    -- Режим работы
    server = {
      override = false, -- Отключить переопределение LSP (несовместимо с новым API)
      settings = {},
    },
    
    -- Подсветка цветов
    document_color = {
      enabled = true,
      kind = "inline", -- "inline", "foreground", "background"
      inline_symbol = "󰝤 ", -- Символ для inline
      debounce = 200,
    },
    
    -- Скрытие длинных классов
    conceal = {
      enabled = false, -- По умолчанию выключено
      min_length = nil,  -- Минимальная длина для скрытия
      symbol = "󱏿", -- Символ замены
      highlight = {
        fg = "#38BDF8", -- Цвет Tailwind
      },
    },
    
    -- Сортировка классов
    custom_filetypes = {},
    
    -- Расширение файлов
    extension = {
      queries = {},
      patterns = {
        javascript = { "clsx%(([^)]*)%)" },
        typescript = { "clsx%(([^)]*)%)" },
        javascriptreact = { "clsx%(([^)]*)%)", "cn%(([^)]*)%)" },
        typescriptreact = { "clsx%(([^)]*)%)", "cn%(([^)]*)%)" },
      },
    },
  },
  
  config = function(_, opts)
    require("tailwind-tools").setup(opts)
  end,
  
  keys = {
    { "<leader>tc", "<cmd>TailwindConcealToggle<cr>", desc = "Toggle Tailwind скрытие" },
    { "<leader>ts", "<cmd>TailwindSort<cr>", desc = "Сортировать Tailwind классы" },
    { "<leader>ts", "<cmd>TailwindSortSelection<cr>", mode = "v", desc = "Сортировать выделенные классы" },
  },
}
