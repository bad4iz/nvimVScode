--[[
=====================================================================
              ДОПОЛНИТЕЛЬНЫЕ НАСТРОЙКИ ДЛЯ STANDALONE NEOVIM
=====================================================================
Настройки, которые работают только в standalone Neovim
(не в VSCode/Windsurf режиме).
=====================================================================
--]]

local opt = vim.opt

-- =====================================================================
-- ВНЕШНИЙ ВИД (только для standalone)
-- =====================================================================

-- Прозрачность фона (если хотите прозрачный терминал)
-- vim.api.nvim_set_hl(0, "Normal", { bg = "none" })
-- vim.api.nvim_set_hl(0, "NormalFloat", { bg = "none" })

-- Граница между окнами и специальные символы
opt.fillchars = {
  diff = "╱",
  eob = " ", -- Скрыть ~ в конце буфера
}

-- Полноэкранный режим для GUI (neovide и т.д.)
if vim.g.neovide then
  vim.g.neovide_transparency = 0.95
  vim.g.neovide_cursor_animation_length = 0.1
  vim.g.neovide_cursor_trail_length = 0.3
  vim.g.neovide_refresh_rate = 60
  vim.g.neovide_remember_window_size = true
  vim.o.guifont = "VictorMono Nerd Font Propo:h12"
end

-- =====================================================================
-- FOLDING (сворачивание кода)
-- =====================================================================
opt.foldcolumn = "1"
opt.foldlevel = 99
opt.foldlevelstart = 99

-- =====================================================================
-- СТАТУСНАЯ СТРОКА И ТАБЫ
-- =====================================================================
opt.laststatus = 3     -- Глобальная статусная строка (для lualine)
opt.showtabline = 2    -- Всегда показывать строку табов (для bufferline)

-- =====================================================================
-- ПРОИЗВОДИТЕЛЬНОСТЬ
-- =====================================================================
opt.lazyredraw = false -- Отключено, т.к. может конфликтовать с noice
opt.synmaxcol = 240    -- Максимум колонок для подсветки синтаксиса

-- =====================================================================
-- СЕССИИ
-- =====================================================================
opt.sessionoptions = {
  "buffers",
  "curdir", 
  "tabpages",
  "winsize",
  "help",
  "globals",
  "skiprtp",
  "folds",
}

-- =====================================================================
-- SPELLCHECK (проверка орфографии)
-- =====================================================================
opt.spelllang = { "en", "ru" }
opt.spell = false -- Включается через <leader>us

-- =====================================================================
-- WILDMENU (автодополнение команд)
-- =====================================================================
opt.wildmode = "longest:full,full"
opt.wildignore:append({
  "*.o", "*.obj", "*.dll", "*.exe",
  "*.pyc", "*.pyo", "__pycache__",
  "*.swp", "*.swo", "*~",
  "node_modules/*", ".git/*",
  "*.jpg", "*.jpeg", "*.png", "*.gif", "*.svg",
})

-- =====================================================================
-- ДИАГНОСТИКА (иконки ошибок, предупреждений и т.д.)
-- =====================================================================
-- Настраиваем здесь, чтобы иконки применялись сразу при старте
local icons = {
   error = '', warn = ' ', info = ' ', hint = ' '
}

vim.diagnostic.config({
  underline = true,
  update_in_insert = false,
  severity_sort = true,
  
  -- Виртуальный текст справа от кода
  virtual_text = {
    spacing = 4,
    source = "if_many",
    prefix = function(diagnostic)
      local severity_icons = {
        [vim.diagnostic.severity.ERROR] = icons.error,
        [vim.diagnostic.severity.WARN] = icons.warn,
        [vim.diagnostic.severity.HINT] = icons.hint,
        [vim.diagnostic.severity.INFO] = icons.info,
      }
      return severity_icons[diagnostic.severity] or "● "
    end,
  },
  
  -- Иконки в колонке знаков (слева от номеров строк)
  signs = {
    text = {
      [vim.diagnostic.severity.ERROR] = icons.error,
      [vim.diagnostic.severity.WARN] = icons.warn,
      [vim.diagnostic.severity.HINT] = icons.hint,
      [vim.diagnostic.severity.INFO] = icons.info,
    },
  },
  
  -- Плавающее окно диагностики
  float = {
    focusable = true,
    style = "minimal",
    border = "rounded",
    source = true,
    header = "",
    prefix = function(diagnostic)
      local severity_icons = {
        [vim.diagnostic.severity.ERROR] = icons.error,
        [vim.diagnostic.severity.WARN] = icons.warn,
        [vim.diagnostic.severity.HINT] = icons.hint,
        [vim.diagnostic.severity.INFO] = icons.info,
      }
      local severity_names = {
        [vim.diagnostic.severity.ERROR] = "Error",
        [vim.diagnostic.severity.WARN] = "Warn",
        [vim.diagnostic.severity.HINT] = "Hint",
        [vim.diagnostic.severity.INFO] = "Info",
      }
      return severity_icons[diagnostic.severity] or "● ", 
             "DiagnosticSign" .. (severity_names[diagnostic.severity] or "")
    end,
  },
})

print("✓ Дополнительные настройки nvim загружены")
