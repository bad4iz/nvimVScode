--[[
=====================================================================
                        TOKYONIGHT
=====================================================================
Красивая цветовая схема для Neovim с поддержкой Treesitter и LSP.

Варианты стилей:
  - tokyonight-night   : тёмная тема (основная)
  - tokyonight-storm   : тёмная с синим оттенком
  - tokyonight-day     : светлая тема
  - tokyonight-moon    : тёмная с фиолетовым оттенком

Команды:
  :colorscheme tokyonight-night  - сменить тему

GitHub: https://github.com/folke/tokyonight.nvim

Совместимость с Omarchy:
  В окружении Omarchy тема загружается из omarchy-theme.lua,
  а этот файл только настраивает плагин без применения colorscheme.
=====================================================================
--]]

-- Проверяем, находимся ли мы в окружении Omarchy
local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local is_omarchy = vim.fn.filereadable(omarchy_theme_file) == 1

return {
  "folke/tokyonight.nvim",
  lazy = false,    -- Загружать сразу (это цветовая схема)
  priority = 1000, -- Загружать первым
  
  opts = {
    -- Стиль темы: storm, moon, night, day
    style = "night",
    
    -- Прозрачный фон (для терминалов с прозрачностью)
    transparent = false,
    
    -- Стили для элементов
    styles = {
      -- Стиль для комментариев
      comments = { italic = true },
      -- Стиль для ключевых слов
      keywords = { italic = true },
      -- Стиль для функций
      functions = {},
      -- Стиль для переменных
      variables = {},
      -- Боковые панели (neo-tree, terminal и др.)
      sidebars = "dark",
      -- Плавающие окна
      floats = "dark",
    },
    
    -- Боковые панели со тёмным фоном
    sidebars = { 
      "qf",           -- quickfix
      "help",         -- справка
      "terminal",     -- терминал
      "packer",       -- packer
      "lazy",         -- lazy.nvim
      "neo-tree",     -- файловый менеджер
      "Trouble",      -- диагностика
    },
    
    -- Более яркие цвета для функций
    day_brightness = 0.3,
    
    -- Затемнить неактивные окна
    dim_inactive = false,
    
    -- Скрыть неактивные статусные строки
    lualine_bold = true,
    
    -- Кастомные цвета и подсветка
    on_colors = function(colors)
      -- Можно переопределить цвета
      -- colors.bg = "#1a1b26"
    end,
    
    on_highlights = function(hl, colors)
      -- Более заметный курсор в строке
      hl.CursorLine = { bg = colors.bg_highlight }
      
      -- Подсветка для flash.nvim
      hl.FlashBackdrop = { fg = colors.dark3 }
      hl.FlashLabel = { 
        bg = colors.magenta2, 
        bold = true, 
        fg = colors.fg 
      }
      
      -- Более яркие границы окон
      hl.WinSeparator = { fg = colors.blue0 }
      
      -- Подсветка для indent-blankline
      hl.IblIndent = { fg = colors.bg_highlight }
      hl.IblScope = { fg = colors.blue }
    end,
  },
  
  config = function(_, opts)
    require("tokyonight").setup(opts)

    -- Применяем цветовую схему только если НЕ в Omarchy
    -- В Omarchy тема применяется через omarchy-theme.lua
    if not is_omarchy then
      vim.cmd.colorscheme("tokyonight-night")
    end
  end,
}
