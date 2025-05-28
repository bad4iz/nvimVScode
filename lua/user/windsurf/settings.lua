
local vscode = require('vscode')

-- Простая функция для тестирования
function TestConfig()
    print("Конфигурация Neovim работает!")
end

-- Создаем команду для тестирования
vim.cmd([[command! TestConfig lua TestConfig()]])


-- настройка цвета выделения 
vim.api.nvim_create_autocmd('TextYankPost', {
  group = vim.api.nvim_create_augroup('highlight_yank', {}),
  pattern = '*',
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 200,
    })
  end,
})