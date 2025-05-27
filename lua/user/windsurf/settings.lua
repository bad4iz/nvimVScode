
local vscode = require('vscode')

-- Простая функция для тестирования
function TestConfig()
    print("Конфигурация Neovim работает!")
end

-- Создаем команду для тестирования
vim.cmd([[command! TestConfig lua TestConfig()]])



-- Загружаем конфигурацию MCP сервера Git
