--[[
=====================================================================
                    VSCODE/WINDSURF КОНФИГУРАЦИЯ
=====================================================================
Конфигурация для работы в VSCode/Windsurf через vscode-neovim.

В этом режиме НЕ загружаются:
  - Цветовые схемы (VSCode имеет свои)
  - Файловый менеджер (используется встроенный explorer)
  - Автодополнение (используется VSCode intellisense)
  - LSP (используется встроенный)
  - Statusline/bufferline (используется VSCode UI)

Загружаются только плагины для редактирования:
  - flash.nvim (быстрая навигация)
  - nvim-surround (окружение текста)
  - nvim-toggler (переключение значений)
  - mini.ai (текстовые объекты)
  - vim-repeat (повтор команд)
=====================================================================
--]]

-- Загружаем настройки для VSCode
require("user.windsurf.settings")

-- Собираем плагины только из common (они работают в VSCode)
local common_plugins = {}

-- Загружаем common плагины
local common_path = vim.fn.stdpath("config") .. "/lua/user/common/plugins"
for _, file in ipairs(vim.fn.readdir(common_path) or {}) do
  if file:match("%.lua$") and file ~= "init.lua" then
    local module_name = file:gsub("%.lua$", "")
    local ok, plugin = pcall(require, "user.common.plugins." .. module_name)
    if ok and plugin then
      if vim.islist(plugin) then
        vim.list_extend(common_plugins, plugin)
      else
        table.insert(common_plugins, plugin)
      end
    end
  end
end

-- Инициализация Lazy.nvim с минимальным набором плагинов
require("lazy").setup(common_plugins, {
  defaults = { lazy = true },
  
  ui = {
    border = "rounded",
  },
  
  change_detection = {
    notify = false,
  },
  
  performance = {
    cache = {
      enabled = true,
    },
    rtp = {
      disabled_plugins = {
        "gzip",
        "matchit",
        "matchparen",
        "netrwPlugin",
        "tarPlugin",
        "tohtml",
        "tutor",
        "zipPlugin",
      },
    },
  },
})

-- Загружаем VSCode-специфичные keymaps
require("user.windsurf.keymaps")

print("✓ Конфигурация VSCode/Windsurf загружена!")
