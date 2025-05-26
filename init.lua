--[[

=====================================================================
==================== ПРОЧТИТЕ ПЕРЕД ПРОДОЛЖЕНИЕМ ==================
=====================================================================
========                                    .-----.          ========
========         .----------------------.   | === |          ========
========         |.-""""""""""""""""".|   |-----|          ========
========         ||                    ||   | === |          ========
========         ||   VSCode.NVIM   ||   |-----|          ========
========         ||                    ||   | === |          ========
========         ||                    ||   |-----|          ========
========         ||:Tutor              ||   |:::::|          ========
========         |'-..................-'|   |____o|          ========
========         `"")----------------("'   ___________      ========
========        /::::::::::|  |::::::::::\  \ no mouse \     ========
========       /:::========|  |==hjkl==:::\  \ required \    ========
========      '""""""""""""'  '""""""""""""'  '""""""""""'   ========
========                                                     ========
=====================================================================
=====================================================================
]]

-- Синхронизировать буфер обмена между ОС и Neovim.
--  Настройка откладывается до события `UiEnter`, так как это может увеличить время запуска.
--  Удалите эту опцию, если хотите, чтобы буфер обмена ОС оставался независимым.
--  См. `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)
-- vim.opt.clipboard = "unnamedplus"


-- This file simply bootstraps the installation of Lazy.nvim and then calls other files for execution
-- This file doesn't necessarily need to be touched, BE CAUTIOUS editing this file and proceed at your own risk.
local lazypath = vim.env.LAZY or vim.fn.stdpath "data" .. "/lazy/lazy.nvim"
if not (vim.env.LAZY or (vim.uv or vim.loop).fs_stat(lazypath)) then
  -- stylua: ignore
  vim.fn.system({ "git", "clone", "--filter=blob:none", "https://github.com/folke/lazy.nvim.git", "--branch=stable", lazypath })
end
vim.opt.rtp:prepend(lazypath)

-- validate that lazy is available
if not pcall(require, "lazy") then
  -- stylua: ignore
  vim.api.nvim_echo({ { ("Unable to load lazy from: %s\n"):format(lazypath), "ErrorMsg" }, { "Press any key to exit...", "MoreMsg" } }, true, {})
  vim.fn.getchar()
  vim.cmd.quit()
end


-- require "lazy_setup"
-- require "polish"

-- Инициализация Lazy.nvim с загрузкой плагинов из user/windsurf/plugins
require('lazy').setup('user.windsurf.plugins')

-- Минимальная рабочая конфигурация Neovim

-- Включаем нумерацию строк
vim.wo.number = true
vim.wo.relativenumber = true

-- Настройки табуляции
vim.opt.tabstop = 4
vim.opt.shiftwidth = 4
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Настройки поиска
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

if vim.g.vscode then
    -- VSCode extension
    require "user.windsurf.init"
else
    -- ordinary Neovim
end

-- Сообщение при загрузке
-- vim.cmd([[autocmd VimEnter * lua print('Neovim загружен!')]])