local keymap = vim.keymap.set
local opts = { noremap = true, silent = true }

-- remap leader key
keymap("n", "<Space>", "", opts)

local vscode = require('vscode')

-- В VS Code это меню отображает доступные команды с их хоткеями
vim.api.nvim_set_keymap('n', '<Space>', '<Cmd>call VSCodeNotify("whichkey.show")<CR>', {noremap = true, silent = true})

-- Горячая клавиша Space + e для переключения проводника (как в VSCode)
vim.api.nvim_set_keymap('n', '<Space>e', '<Cmd>call VSCodeNotify("workbench.view.explorer")<CR>', {noremap = true, silent = true})

-- Горячая клавиша Space + c для закрытия активного редактора (как в VSCode)
vim.api.nvim_set_keymap('n', '<Space>c', '<Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>', {noremap = true, silent = true})



-- Горячая клавиша Ctrl+n для добавления следующего совпадения в выделение
vim.api.nvim_set_keymap('n', '<C-n>', '<Cmd>call VSCodeNotify("editor.action.addSelectionToNextFindMatch")<CR>', {noremap = true, silent = true})

-- Горячая клавиша Ctrl+Left для прокрутки вниз во всплывающей подсказке
-- Примечание: Будет работать только если фокус находится на всплывающей подсказке
vim.api.nvim_set_keymap('n', '<C-Left>', '<Cmd>call VSCodeNotify("editor.action.pageDownHover")<CR>', {noremap = true, silent = true})

-- Примечание: В Neovim не нужно явно удалять привязки клавиш, как в keybindings.json VSCode
-- Последняя привязка для комбинации клавиш имеет приоритет

-- Вывод сообщения при загрузке файла с настройками клавиш
vim.cmd([[autocmd VimEnter * lua print('keymaps загружен!')]])


-- Поиск слова под курсором в файлах проекта
vim.keymap.set('n', '?', function()
    vscode.action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })
end, { silent = true, desc = 'Найти слово под курсором в проекте' })



-- vim.keymap.set('n', ' ', function()
--     vscode.action('whichkey.show', { args = { query = vim.fn.expand('<cword>') } })
-- end, { silent = true, desc = 'Показать ключи' })