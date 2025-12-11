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
-- ОТКЛЮЧЕНИЕ OVERRIDE КЛАВИШ Z
-- =====================================================================

-- Попытка отключить override прокрутки vscode-neovim
-- Это выполнится при загрузке settings.lua
vim.api.nvim_create_autocmd("VimEnter", {
  callback = function()
    vim.defer_fn(function()
      -- Отключаем все z-команды, которые переопределяет расширение
      for _, key in ipairs({"zz", "zb", "zt", "z-", "z.", "z<CR>", "z=", "zo", "zc", "za", "zr", "zm", "zR", "zM", "zn", "zN", "zh", "zl", "zk", "zj"}) do
        vim.keymap.set("n", key, "<Nop>", { noremap = true, silent = true })
      end
    end, 150)
  end,
})

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