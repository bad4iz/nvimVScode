--[[
=====================================================================
                    ОБЩИЕ СОЧЕТАНИЯ КЛАВИШ
=====================================================================
Клавиатурные сокращения в стиле AstroNvim.
Работают в обоих режимах:
- VSCode/Windsurf (через расширение vscode-neovim)
- Standalone Neovim

Лидер-клавиша: <Space>
Локальный лидер: ,
=====================================================================
--]]

local keymap = vim.keymap.set

-- =====================================================================
-- БАЗОВАЯ НАВИГАЦИЯ
-- =====================================================================

-- Перемещение по строкам с учетом переноса (AstroNvim)
keymap({ "n", "x" }, "j", "v:count == 0 ? 'gj' : 'j'", { expr = true, silent = true, desc = "Курсор вниз" })
keymap({ "n", "x" }, "k", "v:count == 0 ? 'gk' : 'k'", { expr = true, silent = true, desc = "Курсор вверх" })

-- Быстрое перемещение по полэкрана с центрированием
-- keymap("n", "<C-d>", "<C-d>zz", { desc = "Прокрутка вниз и центрирование" })
-- keymap("n", "<C-u>", "<C-u>zz", { desc = "Прокрутка вверх и центрирование" })

-- Центрирование при поиске
keymap("n", "n", "nzzzv", { desc = "Следующее совпадение и центр" })
keymap("n", "N", "Nzzzv", { desc = "Предыдущее совпадение и центр" })

-- =====================================================================
-- СТАНДАРТНЫЕ ОПЕРАЦИИ (AstroNvim style)
-- =====================================================================

-- Отмена подсветки поиска
keymap("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Убрать подсветку поиска" })

-- Сохранение файла (AstroNvim: <leader>w и <C-s>)
keymap("n", "<leader>w", "<cmd>w<CR>", { desc = "Сохранить" })
keymap("n", "<leader>W", "<cmd>wa<CR>", { desc = "Сохранить все" })
keymap({ "n", "i", "x" }, "<C-s>", "<cmd>silent! update! | redraw<CR>", { desc = "Принудительно сохранить" })

-- Выход (AstroNvim style)
keymap("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Закрыть окно" })
keymap("n", "<leader>Q", "<cmd>confirm qall<CR>", { desc = "Выйти из Neovim" })
keymap("n", "<C-q>", "<cmd>q!<CR>", { desc = "Принудительный выход" })

-- Новый файл (AstroNvim)
keymap("n", "<leader>n", "<cmd>enew<CR>", { desc = "Новый файл" })

-- Сплиты (AstroNvim)
keymap("n", "|", "<cmd>vsplit<CR>", { desc = "Вертикальный сплит" })
keymap("n", "\\", "<cmd>split<CR>", { desc = "Горизонтальный сплит" })

-- =====================================================================
-- КОММЕНТИРОВАНИЕ (AstroNvim style)
-- =====================================================================

keymap("n", "<leader>/", "gcc", { remap = true, desc = "Toggle comment line" })
keymap("x", "<leader>/", "gc", { remap = true, desc = "Toggle comment" })
keymap("n", "gco", "o<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>", { desc = "Добавить комментарий ниже" })
keymap("n", "gcO", "O<Esc>Vcx<Esc><cmd>normal gcc<CR>fxa<BS>", { desc = "Добавить комментарий выше" })

-- =====================================================================
-- РЕДАКТИРОВАНИЕ
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

-- Копирование в системный буфер (AstroNvim)
keymap({ "n", "v" }, "<leader>y", [["+y]], { desc = "Копировать в буфер обмена" })
keymap("n", "<leader>Y", [["+Y]], { desc = "Копировать строку в буфер обмена" })

-- =====================================================================
-- ОТСТУПЫ В ВИЗУАЛЬНОМ РЕЖИМЕ (AstroNvim)
-- =====================================================================

keymap("v", "<", "<gv", { desc = "Indent left" })
keymap("v", ">", ">gv", { desc = "Сдвиг вправо" })
keymap("v", "<", "<gv", { desc = "Сдвиг влево" })

-- =====================================================================
-- РАБОТА С ОКНАМИ (AstroNvim)
-- =====================================================================

-- Навигация между окнами
keymap("n", "<C-h>", "<C-w>h", { desc = "Влево в окно" })
keymap("n", "<C-j>", "<C-w>j", { desc = "Вниз в окно" })
keymap("n", "<C-k>", "<C-w>k", { desc = "Вверх в окно" })
keymap("n", "<C-l>", "<C-w>l", { desc = "Вправо в окно" })

-- Изменение размера окон (AstroNvim)
keymap("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Уменьшить высоту окна" })
keymap("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Увеличить высоту окна" })
keymap("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Уменьшить ширину окна" })
keymap("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Увеличить ширину окна" })

-- =====================================================================
-- БУФЕРЫ (AstroNvim style)
-- =====================================================================

-- Навигация по буферам
keymap("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })
keymap("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Следующий буфер" })
keymap("n", "[b", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })
keymap("n", "]b", "<cmd>bnext<CR>", { desc = "Следующий буфер" })
keymap("n", "<leader>bp", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })

-- Закрытие буфера (AstroNvim: <leader>c)
keymap("n", "<leader>c", "<cmd>bdelete<CR>", { desc = "Закрыть буфер" })
keymap("n", "<leader>C", "<cmd>bdelete!<CR>", { desc = "Принудительно закрыть буфер" })

-- =====================================================================
-- ТАБЫ (AstroNvim)
-- =====================================================================

keymap("n", "]t", "<cmd>tabnext<CR>", { desc = "Следующая вкладка" })
keymap("n", "[t", "<cmd>tabprevious<CR>", { desc = "Предыдущая вкладка" })

-- =====================================================================
-- QUICKFIX/LOCLIST (AstroNvim)
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
-- ДИАГНОСТИКА (AstroNvim)
-- =====================================================================

keymap("n", "gl", vim.diagnostic.open_float, { desc = "Диагностика под курсором" })
keymap("n", "<leader>ld", vim.diagnostic.open_float, { desc = "Диагностика строки" })
keymap("n", "[d", vim.diagnostic.goto_prev, { desc = "Предыдущая диагностика" })
keymap("n", "]d", vim.diagnostic.goto_next, { desc = "Следующая диагностика" })

-- Ошибки и предупреждения (AstroNvim)
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
-- ТЕРМИНАЛ НАВИГАЦИЯ (AstroNvim)
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
keymap("t", "<C-h>", term_nav("h"), { desc = "Терминал: окно слева" })

-- =====================================================================
-- СОРТИРОВКА
-- =====================================================================

keymap("v", "gs", ":sort<CR>", { desc = "Сортировать выделение" })

-- =====================================================================
-- ПОДСВЕТКА ПРИ КОПИРОВАНИИ (YANK)
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

print("✓ Сочетания клавиш загружены (стиль AstroNvim)")
