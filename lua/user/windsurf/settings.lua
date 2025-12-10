--[[
=====================================================================
                    НАСТРОЙКИ ДЛЯ VSCODE/WINDSURF
=====================================================================
Специфичные настройки для работы в VSCode/Windsurf.
=====================================================================
--]]

local vscode = require("vscode")

-- =====================================================================
-- ПОДСВЕТКА ПРИ КОПИРОВАНИИ
-- =====================================================================
vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank_vscode", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
  desc = "Подсветка при копировании в VSCode",
})

-- =====================================================================
-- ВСПОМОГАТЕЛЬНЫЕ ФУНКЦИИ
-- =====================================================================

-- Функция для вызова команд VSCode
_G.VSCodeNotify = function(cmd, ...)
  return vscode.call(cmd, ...)
end

-- Функция для вызова действий VSCode
_G.VSCodeAction = function(cmd, opts)
  return vscode.action(cmd, opts)
end

-- =====================================================================
-- ТЕСТОВЫЕ КОМАНДЫ
-- =====================================================================
function TestConfig()
  vim.notify("✓ Конфигурация Neovim для VSCode работает!", vim.log.levels.INFO)
end

vim.api.nvim_create_user_command("TestConfig", TestConfig, { 
  desc = "Проверить конфигурацию" 
})

print("✓ Настройки VSCode загружены")