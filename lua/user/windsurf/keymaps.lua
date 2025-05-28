local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}

-- remap leader key
keymap("n", "<Space>", " ", opts)
keymap("n", "<leader>", " ", opts)

local vscode = require('vscode')

-- В VS Code это меню отображает доступные команды с их хоткеями
-- vim.api.nvim_set_keymap('n', '<Space>', '<Cmd>call VSCodeNotify("whichkey.show")<CR>', {noremap = true, silent = true})

-- Горячая клавиша Space + e для переключения проводника (как в VSCode)
vim.api.nvim_set_keymap('n', '<Space>e', '<Cmd>call VSCodeNotify("workbench.view.explorer")<CR>', {
    noremap = true,
    silent = true
})

-- Горячая клавиша Space + c для закрытия активного редактора (как в VSCode)
vim.api.nvim_set_keymap('n', '<Space>c', '<Cmd>call VSCodeNotify("workbench.action.closeActiveEditor")<CR>', {
    noremap = true,
    silent = true
})

-- Горячая клавиша Ctrl+n для добавления следующего совпадения в выделение
vim.api.nvim_set_keymap('n', '<C-n>', '<Cmd>call VSCodeNotify("editor.action.addSelectionToNextFindMatch")<CR>', {
    noremap = true,
    silent = true
})

-- Горячая клавиша Ctrl+Left для прокрутки вниз во всплывающей подсказке
-- Примечание: Будет работать только если фокус находится на всплывающей подсказке
vim.api.nvim_set_keymap('n', '<C-Left>', '<Cmd>call VSCodeNotify("editor.action.pageDownHover")<CR>', {
    noremap = true,
    silent = true
})

-- Примечание: В Neovim не нужно явно удалять привязки клавиш, как в keybindings.json VSCode
-- Последняя привязка для комбинации клавиш имеет приоритет

-- Вывод сообщения при загрузке файла с настройками клавиш
vim.cmd([[autocmd VimEnter * lua print('keymaps загружен!')]])

-- //////////
-- ## Find

-- Поиск слова под курсором в файлах проекта
keymap.set('n', '<Space>fc', function()
    vscode.action('workbench.action.findInFiles', {
        args = {
            query = vim.fn.expand('<cword>')
        }
    })
end, {
    silent = true,
    desc = 'Найти слово под курсором в проекте'
})

keymap.set('n', '<Space>fw', function()
    vscode.action('workbench.action.findInFiles', {
        args = {}
    })
end, {
    silent = true,
    desc = 'Найти слово'
})

vim.keymap.set('n', '<Space>ff', function()
    vscode.action('workbench.action.quickOpen', {
        args = {
            query = vim.fn.expand('<cword>')
        }
    })
end, {
    silent = true,
    desc = 'Открыть файл'
})

-- vim.keymap.set('n', ' ', function()
--     vscode.action('whichkey.show', { args = { query = vim.fn.expand('<cword>') } })
-- end, { silent = true, desc = 'Показать ключи' })

-- -- harpoon keymaps
-- keymap({"n", "v"}, "<leader>ha", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>")
-- keymap({"n", "v"}, "<leader>ho", "<cmd>lua require('vscode').action('vscode-harpoon.editorQuickPick')<CR>")
-- keymap({"n", "v"}, "<leader>he", "<cmd>lua require('vscode').action('vscode-harpoon.editEditors')<CR>")
-- keymap({"n", "v"}, "<leader>h1", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor1')<CR>")
-- keymap({"n", "v"}, "<leader>h2", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor2')<CR>")
-- keymap({"n", "v"}, "<leader>h3", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor3')<CR>")
-- keymap({"n", "v"}, "<leader>h4", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor4')<CR>")
-- keymap({"n", "v"}, "<leader>h5", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor5')<CR>")
-- keymap({"n", "v"}, "<leader>h6", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor6')<CR>")
-- keymap({"n", "v"}, "<leader>h7", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor7')<CR>")
-- keymap({"n", "v"}, "<leader>h8", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor8')<CR>")
-- keymap({"n", "v"}, "<leader>h9", "<cmd>lua require('vscode').action('vscode-harpoon.gotoEditor9')<CR>")

-- -- project manager keymaps
-- keymap({"n", "v"}, "<leader>pa", "<cmd>lua require('vscode').action('projectManager.saveProject')<CR>")
-- keymap({"n", "v"}, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>")
-- keymap({"n", "v"}, "<leader>ha", "<cmd>lua require('vscode').action('vscode-harpoon.addEditor')<CR>")

-- Переключение табов
keymap({"n", "v"}, "<Tab>", function()
    vscode.action('workbench.action.nextEditor')
end, {
    silent = true,
    desc = 'Следующая вкладка'
})

keymap({"n", "v"}, "<S-Tab>", function()
    vscode.action('workbench.action.previousEditor')
end, {
    silent = true,
    desc = 'Предыдущая вкладка'
})

-- Основные хоткеи
keymap({"n", "v"}, "<leader>t", "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>", {
    silent = true,
    desc = 'Переключить встроенный терминал'
})

keymap({"n", "v"}, "<leader>b", "<cmd>lua require('vscode').action('editor.debug.action.toggleBreakpoint')<CR>", {
    silent = true,
    desc = 'Поставить/удалить точку останова'
})

keymap({"n", "v"}, "<leader>d", "<cmd>lua require('vscode').action('editor.action.showHover')<CR>", {
    silent = true,
    desc = 'Показать документацию (hover)'
})

keymap({"n", "v"}, "<leader>a", "<cmd>lua require('vscode').action('editor.action.quickFix')<CR>", {
    silent = true,
    desc = 'Быстрое исправление (quick fix)'
})

keymap({"n", "v"}, "<leader>sp", "<cmd>lua require('vscode').action('workbench.actions.view.problems')<CR>", {
    silent = true,
    desc = 'Показать проблемы (problems)'
})

keymap({"n", "v"}, "<leader>cn", "<cmd>lua require('vscode').action('notifications.clearAll')<CR>", {
    silent = true,
    desc = 'Очистить уведомления'
})

keymap({"n", "v"}, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", {
    silent = true,
    desc = 'Быстрый поиск файлов'
})

keymap({"n", "v"}, "<leader>cp", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>", {
    silent = true,
    desc = 'Показать палитру команд'
})

keymap({"n", "v"}, "<leader>pr", "<cmd>lua require('vscode').action('code-runner.run')<CR>", {
    silent = true,
    desc = 'Запустить код (Code Runner)'
})

-- keymap({"n", "v"}, "<leader>fd", "<cmd>lua require('vscode').action('editor.action.formatDocument')<CR>", {
--     silent = true,
--     desc = 'Форматировать документ'
-- })
