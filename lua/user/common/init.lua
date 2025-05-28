
vim.g.mapleader = " "
vim.g.maplocalleader = " "


-- Настройки для истории отмены
if vim.fn.has('persistent_undo') == 1 then
    local undodir = vim.fn.stdpath('data') .. '/undo_history'
    if vim.fn.isdirectory(undodir) == 0 then
        vim.fn.mkdir(undodir, 'p')
    end
    vim.opt.undodir = undodir
    vim.opt.undofile = true
    vim.opt.undolevels = 1000
    vim.opt.undoreload = 10000
end

-- Синхронизировать буфер обмена между ОС и Neovim.
--  Настройка откладывается до события `UiEnter`, так как это может увеличить время запуска.
--  Удалите эту опцию, если хотите, чтобы буфер обмена ОС оставался независимым.
--  См. `:help 'clipboard'`
vim.schedule(function()
  vim.o.clipboard = 'unnamedplus'
end)



-- Включаем нумерацию строк
vim.wo.number = true
vim.wo.relativenumber = true

-- Настройки табуляции
vim.opt.tabstop = 2
vim.opt.shiftwidth = 2
vim.opt.expandtab = true
vim.opt.autoindent = true

-- Настройки поиска
vim.opt.ignorecase = true
vim.opt.smartcase = true
vim.opt.hlsearch = true

-- vim.opt.clipboard = "unnamedplus"
-- Другие общие настройки...
-- 


print("Конфигурация общих настроек загружена!")