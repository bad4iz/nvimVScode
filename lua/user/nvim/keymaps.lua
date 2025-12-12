--[[
=====================================================================
                    NEOVIM-SPECIFIC KEYMAPS
=====================================================================
Горячие клавиши, которые работают ТОЛЬКО в Neovim.
Требуют функциональности, недоступной в VSCode/Windsurf.

Лидер-клавиша: <Space>
=====================================================================
--]]

local keymap = vim.keymap.set

-- =====================================================================
-- ВЫХОД (Neovim only)
-- =====================================================================

keymap("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Закрыть окно" })
keymap("n", "<leader>Q", "<cmd>confirm qall<CR>", { desc = "Выйти из Neovim" })
keymap("n", "<C-q>", "<cmd>q!<CR>", { desc = "Принудительный выход" })

-- =====================================================================
-- НОВЫЙ ФАЙЛ И СПЛИТЫ (Neovim only)
-- =====================================================================

keymap("n", "<leader>n", "<cmd>enew<CR>", { desc = "Новый файл" })
keymap("n", "|", "<cmd>vsplit<CR>", { desc = "Вертикальный сплит" })
keymap("n", "\\", "<cmd>split<CR>", { desc = "Горизонтальный сплит" })

-- =====================================================================
-- ОТМЕНА ПОДСВЕТКИ ПОИСКА (Neovim only)
-- =====================================================================

keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Убрать подсветку поиска" })

-- =====================================================================
-- КОММЕНТИРОВАНИЕ (Neovim only - зависит от comment.nvim)
-- =====================================================================

keymap("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
keymap("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })
keymap("n", "gco", "o<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>", { desc = "Добавить комментарий ниже" })
keymap("n", "gcO", "O<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>", { desc = "Добавить комментарий выше" })

-- =====================================================================
-- РЕДАКТИРОВАНИЕ (Neovim only)
-- =====================================================================

-- Перемещение строк в визуальном режиме
keymap("v", "J", ":m '>+1<CR>gv=gv", { desc = "Переместить строку вниз" })
keymap("v", "K", ":m '<-2<CR>gv=gv", { desc = "Переместить строку вверх" })

-- Сохранение позиции курсора при J (объединение строк)
keymap("n", "J", "mzJ`z", { desc = "Объединить строки (сохранить курсор)" })

-- Вставка без потери буфера
keymap("x", "<leader>p", [["_dP]], { desc = "Вставить без замены буфера" })

-- Удаление в черную дыру (не в буфер)
keymap({ "n", "v" }, "<leader>d", [["_d]], { desc = "Удалить в черную дыру" })

-- Копирование в системный буфер
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Копировать в буфер обмена" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Копировать строку в буфер обмена" })

-- =====================================================================
-- ОТСТУПЫ В ВИЗУАЛЬНОМ РЕЖИМЕ (Neovim only)
-- =====================================================================

keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Сдвиг вправо" })

-- =====================================================================
-- РАБОТА С ОКНАМИ (Neovim only)
-- =====================================================================

-- Навигация между окнами
keymap("n", "<C-h>", "<C-w>h", { desc = "Влево в окно" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Вниз в окно" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Вверх в окно" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Вправо в окно" })

-- Изменение размера окон
keymap("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Уменьшить высоту окна" })
keymap("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Увеличить высоту окна" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Уменьшить ширину окна" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Увеличить ширину окна" })

-- =====================================================================
-- БУФЕРЫ (Neovim only)
-- =====================================================================

-- Навигация по буферам
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Следующий буфер" })
keymap("n", "[b", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })
keymap("n", "]b", "<cmd>bnext<CR>", { desc = "Следующий буфер" })
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })

-- Закрытие буфера (умное удаление через Snacks)
keymap("n", "<leader>c", function() require("snacks").bufdelete() end, { desc = "Закрыть буфер" })
keymap("n", "<leader>C", function() require("snacks").bufdelete({ force = true }) end, { desc = "Принудительно закрыть буфер" })

-- =====================================================================
-- ТАБЫ (Neovim only)
-- =====================================================================

keymap("n", "]t", "<cmd>tabnext<CR>", { desc = "Следующая вкладка" })
keymap("n", "[t", "<cmd>tabprevious<CR>", { desc = "Предыдущая вкладка" })

-- =====================================================================
-- QUICKFIX/LOCLIST (Neovim only)
-- =====================================================================

keymap("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Список quickfix" })
keymap("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Список расположения" })
keymap("n", "]q", "<cmd>cnext<CR>", { desc = "Следующий quickfix" })
keymap("n", "[q", "<cmd>cprev<CR>", { desc = "Предыдущий quickfix" })
keymap("n", "]Q", "<cmd>clast<CR>", { desc = "Последний quickfix" })
keymap("n", "[Q", "<cmd>cfirst<CR>", { desc = "Первый quickfix" })
keymap("n", "]l", "<cmd>lnext<CR>", { desc = "Следующий loclist" })
keymap("n", "[l", "<cmd>lprev<CR>", { desc = "Предыдущий loclist" })
keymap("n", "]L", "<cmd>llast<CR>", { desc = "Последний loclist" })
keymap("n", "[L", "<cmd>lfirst<CR>", { desc = "Первый loclist" })

-- =====================================================================
-- ДИАГНОСТИКА (Neovim only - использует vim.diagnostic API)
-- =====================================================================

keymap("n", "gl", vim.diagnostic.open_float, { desc = "Диагностика под курсором" })
keymap("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Диагностика строки" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Предыдущая диагностика" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Следующая диагностика" })

-- Ошибки и предупреждения
keymap("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Предыдущая ошибка" })
keymap("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Следующая ошибка" })
keymap("n", "[w", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Предыдущее предупреждение" })
keymap("n", "]w", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Следующее предупреждение" })

-- =====================================================================
-- СОРТИРОВКА (Neovim only)
-- =====================================================================

keymap("v", "gs", ":sort<CR>", { desc = "Сортировать выделение" })

-- =====================================================================
-- ПОДСВЕТКА ПРИ КОПИРОВАНИИ (Neovim only - использует autocmd)
-- =====================================================================

vim.api.nvim_create_autocmd("TextYankPost", {
  group = vim.api.nvim_create_augroup("highlight_yank", { clear = true }),
  pattern = "*",
  callback = function()
    vim.highlight.on_yank({
      higroup = "IncSearch",
      timeout = 200,
    })
  end,
  desc = "Подсветка при копировании (yank)",
})

-- =====================================================================
-- ТЕРМИНАЛ НАВИГАЦИЯ (Neovim only)
-- =====================================================================

local function term_nav(dir)
  return function()
    if vim.api.nvim_win_get_config(0).zindex then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-" .. dir .. ">", true, false, true), "n", false)
    else
      vim.cmd.wincmd(dir)
    end
  end
end

keymap("t", "<C-h>", term_nav("h"), { desc = "Terminal left window" })
keymap("t", "<C-j>", term_nav("j"), { desc = "Терминал: окно ниже" })
keymap("t", "<C-k>", term_nav("k"), { desc = "Терминал: окно выше" })
keymap("t", "<C-l>", term_nav("l"), { desc = "Терминал: окно справа" })

print("✓ Neovim-specific keymaps loaded")
