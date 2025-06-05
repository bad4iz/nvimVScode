local keymap = vim.keymap.set
local opts = {
    noremap = true,
    silent = true
}

-- remap leader key
keymap("n", "<leader>", " ", opts)

local vscode = require('vscode')

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

-- //////////
-- ## Find

-- Поиск слова под курсором в файлах проекта
keymap('n', '<leader>fc', function()
    vscode.action('workbench.action.findInFiles', {
        args = {
            query = vim.fn.expand('<cword>')
        }
    })
end, {
    silent = true,
    desc = 'Найти слово под курсором в проекте'
})

keymap('n', '<leader>fw', function()
    vscode.action('workbench.action.findInFiles', {
        args = {}
    })
end, {
    silent = true,
    desc = 'Найти слово'
})

keymap('n', '<leader>ff', function()
    vscode.action('workbench.action.quickOpen', {})
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
-- keymap({"n", "v"}, "<Tab>", function()
--     vscode.action('workbench.action.nextEditor')
-- end, 
--     silent = true,
--     desc = 'Следующая вкладка'
-- })

-- keymap({"n", "v"}, "<S-Tab>", function()
--     vscode.action('workbench.action.previousEditor')
-- end, {
--     silent = true,
--     desc = 'Предыдущая вкладка'
-- })

-- Основные хоткеи

-- ===========================================================================
-- РАБОТА С ТЕРМИНАЛОМ
-- ===========================================================================
-- Основные команды для работы с интегрированным терминалом VSCode
-- Используйте leader t в качестве префикса для всех команд терминала
keymap({"n", "v"}, "<leader>tt", "<cmd>lua require('vscode').action('workbench.action.terminal.toggleTerminal')<CR>", {
    silent = true,
    desc = 'Показать/скрыть терминал (toggle)'
})

keymap({"n", "v"}, "<leader>tn", "<cmd>lua require('vscode').action('workbench.action.terminal.new')<CR>", {
    silent = true,
    desc = 'Новый терминал (new)'
})

keymap({"n", "v"}, "<leader>tk", "<cmd>lua require('vscode').action('workbench.action.terminal.kill')<CR>", {
    silent = true,
    desc = 'Закрыть терминал (kill)'
})

keymap({"n", "v"}, "<leader>t\"", "<cmd>lua require('vscode').action('workbench.action.terminal.split')<CR>", {
    silent = true,
    desc = 'Разделить терминал (split)'
})

keymap({"n", "v"}, "<leader>t\'\'", "<cmd>lua require('vscode').action('workbench.action.terminal.split')<CR>", {
    silent = true,
    desc = 'Разделить терминал (split)'
})

-- Отключаем Ctrl+g (аналог отключения в VS Code с префиксом -)
keymap('n', '<C-g>', '<Nop>', {
    silent = true,
    desc = 'Отключено (был переход к строке)'
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

keymap({"n", "v"}, "<leader>lr", "<cmd>lua require('vscode').action('editor.action.changeAll')<CR>", {
    silent = true,
    desc = 'Заменить все вхождения (change all)'
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

-- ========================================================================= --
-- =============================== НАВИГАЦИЯ ============================== --
-- ========================================================================= --

-- Переход к строке
keymap('n', 'g l', "<cmd>lua require('vscode').action('workbench.action.gotoLine')<CR>", {
    silent = true,
    desc = 'Перейти к строке'
})

-- Навигация по файлам
keymap({"n", "v"}, "<leader>e", "<Cmd>call VSCodeNotify(\"workbench.view.explorer\")<CR>", {
    noremap = true,
    silent = true,
    desc = 'Показать проводник'
})

-- Закрытие активного редактора
keymap({"n", "v"}, "<leader>c", "<Cmd>call VSCodeNotify(\"workbench.action.closeActiveEditor\")<CR>", {
    noremap = true,
    silent = true,
    desc = 'Закрыть активный редактор'
})

-- Поиск в проекте
keymap('n', '<leader>fc', function()
    vscode.action('workbench.action.findInFiles', {
        args = {
            query = vim.fn.expand('<cword>')
        }
    })
end, {
    silent = true,
    desc = 'Найти слово под курсором в проекте'
})

-- Быстрый поиск файлов
keymap({"n", "v"}, "<leader>ff", "<cmd>lua require('vscode').action('workbench.action.quickOpen')<CR>", {
    silent = true,
    desc = 'Быстрый поиск файлов'
})

-- Показать палитру команд
keymap({"n", "v"}, "<leader>cp", "<cmd>lua require('vscode').action('workbench.action.showCommands')<CR>", {
    silent = true,
    desc = 'Показать палитру команд'
})

-- Переопределение Ctrl+R для открытия недавних файлов
keymap('n', '<leader>fo', '<Cmd>call VSCodeNotify("workbench.action.quickOpenRecent")<CR>', {
    silent = true,
    desc = 'Открыть недавние файлы'
})

-- ========================================================================= --
-- ======================= НИЖЕ НЕ РЕДАКТИРОВАТЬ ======================= --
-- ========================================================================= --

print("Конфигурация клавиш загружена!")
