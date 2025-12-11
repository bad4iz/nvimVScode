
--[[
=====================================================================
                    STANDALONE NEOVIM КОНФИГУРАЦИЯ
=====================================================================
Полная конфигурация для standalone Neovim.
Загружается когда Neovim запущен НЕ в VSCode/Windsurf.

Включает:
  - Цветовая схема (tokyonight)
  - LSP для веб-разработки
  - Автодополнение (blink.cmp)
  - AI помощник (Supermaven)
  - Файловый менеджер (neo-tree)
  - Fuzzy finder (snacks.picker)
  - Git интеграция (gitsigns, lazygit)
  - Терминал (snacks.terminal)
  - И многое другое...
=====================================================================
--]]

-- Загружаем дополнительные настройки для nvim
require("user.nvim.options")
require("user.nvim.autocmds")

-- Собираем все плагины из common и nvim
local common_plugins = {}
local nvim_plugins = {}

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

-- Загружаем nvim плагины
local nvim_path = vim.fn.stdpath("config") .. "/lua/user/nvim/plugins"
for _, file in ipairs(vim.fn.readdir(nvim_path) or {}) do
  if file:match("%.lua$") and file ~= "init.lua" then
    local module_name = file:gsub("%.lua$", "")
    local ok, plugin = pcall(require, "user.nvim.plugins." .. module_name)
    if ok and plugin then
      if vim.islist(plugin) then
        vim.list_extend(nvim_plugins, plugin)
      else
        table.insert(nvim_plugins, plugin)
      end
    end
  end
end

-- Объединяем все плагины
local all_plugins = {}
vim.list_extend(all_plugins, common_plugins)
vim.list_extend(all_plugins, nvim_plugins)

-- Инициализация Lazy.nvim
require("lazy").setup(all_plugins, {
  defaults = {
    lazy = true, -- Ленивая загрузка по умолчанию
    version = false, -- Всегда использовать последнюю версию
  },
  
  install = {
    colorscheme = { "tokyonight", "habamax" },
  },
  
  ui = {
    border = "rounded",
    icons = {
      cmd = " ",
      config = "",
      event = "",
      ft = " ",
      init = " ",
      import = " ",
      keys = " ",
      lazy = "󰂠 ",
      loaded = "●",
      not_loaded = "○",
      plugin = " ",
      runtime = " ",
      require = "󰢱 ",
      source = " ",
      start = "",
      task = "✔ ",
      list = {
        "●",
        "➜",
        "★",
        "‒",
      },
    },
  },
  
  checker = {
    enabled = true, -- Проверять обновления
    notify = false, -- Не уведомлять
    frequency = 86400, -- Раз в день
  },
  
  change_detection = {
    enabled = true,
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

-- =====================================================================
-- СОЧЕТАНИЯ КЛАВИШ ДЛЯ УПРАВЛЕНИЯ ПАКЕТАМИ (стиль AstroNvim, <leader>p)
-- =====================================================================

local keymap = vim.keymap.set

-- Lazy
keymap("n", "<leader>pi", function() require("lazy").install() end, { desc = "Установить плагины" })
keymap("n", "<leader>ps", function() require("lazy").home() end, { desc = "Статус плагинов" })
keymap("n", "<leader>pS", function() require("lazy").sync() end, { desc = "Синхронизировать плагины" })
keymap("n", "<leader>pu", function() require("lazy").check() end, { desc = "Проверить обновления плагинов" })
keymap("n", "<leader>pU", function() require("lazy").update() end, { desc = "Обновить плагины" })

-- Mason
keymap("n", "<leader>pm", "<cmd>Mason<CR>", { desc = "Открыть Mason" })
keymap("n", "<leader>pM", "<cmd>MasonUpdate<CR>", { desc = "Обновить Mason" })

-- Обновить всё (Lazy + Mason)
keymap("n", "<leader>pa", function()
  require("lazy").sync()
  vim.cmd("MasonUpdate")
end, { desc = "Обновить всё (Lazy + Mason)" })

-- Информация о LSP
keymap("n", "<leader>li", "<cmd>LspInfo<CR>", { desc = "Информация LSP" })

print("✓ Конфигурация standalone Neovim загружена (AstroNvim style)!")