--[[
╔═══════════════════════════════════════════════════════════════════╗
║                                                                   ║
║   ███╗   ██╗███████╗ ██████╗ ██╗   ██╗██╗███╗   ███╗              ║
║   ████╗  ██║██╔════╝██╔═══██╗██║   ██║██║████╗ ████║              ║
║   ██╔██╗ ██║█████╗  ██║   ██║██║   ██║██║██╔████╔██║              ║
║   ██║╚██╗██║██╔══╝  ██║   ██║╚██╗ ██╔╝██║██║╚██╔╝██║              ║
║   ██║ ╚████║███████╗╚██████╔╝ ╚████╔╝ ██║██║ ╚═╝ ██║              ║
║   ╚═╝  ╚═══╝╚══════╝ ╚═════╝   ╚═══╝  ╚═╝╚═╝     ╚═╝              ║
║                                                                   ║
║   Персональная конфигурация для веб-разработки                    ║
║   Работает в режимах: VSCode/Windsurf и standalone Neovim         ║
║                                                                   ║
╚═══════════════════════════════════════════════════════════════════╝

Структура конфигурации:
  ~/.config/nvim/
  ├── init.lua                 <- Вы здесь (точка входа)
  └── lua/user/
      ├── common/              <- Общие настройки и плагины
      │   ├── options.lua      <- Базовые vim опции
      │   ├── keymaps.lua      <- Общие сочетания клавиш
      │   └── plugins/         <- Плагины для обоих режимов
      │
      ├── windsurf/            <- Для VSCode/Windsurf
      │   ├── settings.lua     <- VSCode настройки
      │   └── keymaps.lua      <- VSCode сочетания
      │
      └── nvim/                <- Для standalone Neovim
          ├── options.lua      <- Дополнительные опции
          ├── autocmds.lua     <- Автокоманды
          └── plugins/         <- Полный набор плагинов

--]]

-- =====================================================================
-- BOOTSTRAP LAZY.NVIM
-- =====================================================================
local lazypath = vim.env.LAZY or vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  vim.fn.system({
    "git",
    "clone",
    "--filter=blob:none",
    "https://github.com/folke/lazy.nvim.git",
    "--branch=stable",
    lazypath,
  })
end
vim.opt.rtp:prepend(lazypath)

-- Проверяем что lazy загружен
if not pcall(require, "lazy") then
  vim.api.nvim_echo({
    { ("Ошибка загрузки lazy.nvim из: %s\n"):format(lazypath), "ErrorMsg" },
    { "Нажмите любую клавишу для выхода...", "MoreMsg" },
  }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end

-- =====================================================================
-- ЗАГРУЗКА ОБЩИХ НАСТРОЕК
-- =====================================================================
require("user.common")

-- =====================================================================
-- ВЫБОР РЕЖИМА РАБОТЫ
-- =====================================================================
if vim.g.vscode then
  -- ═══════════════════════════════════════════════════════════════
  -- РЕЖИМ VSCODE/WINDSURF
  -- Загружает минимальный набор плагинов для редактирования
  -- ═══════════════════════════════════════════════════════════════
  require("user.windsurf")
else
  -- ═══════════════════════════════════════════════════════════════
  -- РЕЖИМ STANDALONE NEOVIM
  -- Загружает полную конфигурацию с LSP, автодополнением и т.д.
  -- ═══════════════════════════════════════════════════════════════
  require("user.nvim")
end

_G.random_char_timer = nil

vim.api.nvim_create_user_command("StartSpam", function()
  if _G.random_char_timer then
    return
  end

  local timer = vim.loop.new_timer()
  _G.random_char_timer = timer

  timer:start(
    0,
    42000,
    vim.schedule_wrap(function()
      local chars = "abcdefghijklmnopqrstuvwxyz0123456789"
      local i = math.random(#chars)
      local c = chars:sub(i, i)

      -- Используем feedkeys, чтобы WakaTime видел это как ввод пользователя
      vim.api.nvim_feedkeys(c, "i", false)
    end)
  )
end, {})

vim.api.nvim_create_user_command("StopSpam", function()
  if _G.random_char_timer then
    _G.random_char_timer:stop()
    _G.random_char_timer:close()
    _G.random_char_timer = nil
  end
end, {})
