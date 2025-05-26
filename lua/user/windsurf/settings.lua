
local vscode = require('vscode')

-- Простая функция для тестирования
function TestConfig()
    print("Конфигурация Neovim работает!")
end

-- Создаем команду для тестирования
vim.cmd([[command! TestConfig lua TestConfig()]])

-- Поиск слова под курсором в файлах проекта
vim.keymap.set('n', '?', function()
    vscode.action('workbench.action.findInFiles', { args = { query = vim.fn.expand('<cword>') } })
end, { silent = true, desc = 'Найти слово под курсором в проекте' })



vim.keymap.set('n', ' ', function()
    vscode.action('whichkey.show', { args = { query = vim.fn.expand('<cword>') } })
end, { silent = true, desc = 'Показать ключи' })