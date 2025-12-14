--[[
=====================================================================
                    NEOVIM-SPECIFIC KEYMAPS
=====================================================================
Горячие клавиши, которые работают ТОЛЬКО в Neovim.
Требуют функциональности, недоступной в VSCode/Windsurf.

Лидер-клавиша: <Space>
Стиль: AstroNvim

ПРИНЦИП МОДУЛЬНОСТИ:
- Горячие клавиши для плагинов определяются в самих плагинах
- В этом файле только общие горячие клавиши, не привязанные к плагинам

ГОРЯЧИЕ КЛАВИШИ ДЛЯ ПЛАГИНОВ:
- snacks.nvim      → lua/user/nvim/plugins/snacks.lua
- neo-tree.nvim    → lua/user/nvim/plugins/neo-tree.lua
- gitsigns.nvim    → lua/user/nvim/plugins/gitsigns.lua
- comment.nvim     → lua/user/nvim/plugins/comment.lua
- lsp              → lua/user/nvim/plugins/lsp.lua
=====================================================================
--]]

local map = vim.keymap.set

-- =====================================================================
-- БАЗОВЫЕ КЛАВИШИ (AstroNvim style)
-- =====================================================================

-- Убрать подсветку поиска
map("n", "<Esc>", "<cmd>nohlsearch<CR>", { desc = "Убрать подсветку поиска" })

-- Сохранение
map("n", "<C-s>", "<cmd>w<CR>", { desc = "Сохранить файл" })

-- Выход
map("n", "<C-q>", "<cmd>q!<CR>", { desc = "Принудительный выход" })

-- =====================================================================
-- УПРАВЛЕНИЕ ОКНАМИ (AstroNvim style)
-- =====================================================================

-- Разделение окон
map("n", "|", "<cmd>vsplit<CR>", { desc = "Вертикальный сплит" })
map("n", "\\", "<cmd>split<CR>", { desc = "Горизонтальный сплит" })

-- Навигация между окнами (AstroNvim: Ctrl + hjkl)
map("n", "<C-h>", "<C-w>h", { desc = "Переместиться в окно слева" })
map("n", "<C-j>", "<C-w>j", { desc = "Переместиться в окно снизу" })
map("n", "<C-k>", "<C-w>k", { desc = "Переместиться в окно сверху" })
map("n", "<C-l>", "<C-w>l", { desc = "Переместиться в окно справа" })

-- Изменение размера окон (AstroNvim: Ctrl + стрелки)
map("n", "<C-Up>", "<cmd>resize -2<CR>", { desc = "Уменьшить высоту окна" })
map("n", "<C-Down>", "<cmd>resize +2<CR>", { desc = "Увеличить высоту окна" })
map("n", "<C-Left>", "<cmd>vertical resize -2<CR>", { desc = "Уменьшить ширину окна" })
map("n", "<C-Right>", "<cmd>vertical resize +2<CR>", { desc = "Увеличить ширину окна" })

-- =====================================================================
-- ЛИДЕР ГРУППА (AstroNvim style)
-- =====================================================================

-- Новый файл
map("n", "<leader>n", "<cmd>enew<CR>", { desc = "Новый файл" })

-- Закрыть окно
map("n", "<leader>q", "<cmd>confirm q<CR>", { desc = "Закрыть окно" })

-- Выход из Neovim
map("n", "<leader>Q", "<cmd>confirm qall<CR>", { desc = "Выйти из Neovim" })

-- Буфер обмена (AstroNvim style)
map({ "n", "v" }, "<leader>y", [["+y]], { desc = "Копировать в системный буфер" })
map("n", "<leader>Y", [["+Y]], { desc = "Копировать строку в буфер" })
map({ "n", "v" }, "<leader>d", [["_d]], { desc = "Удалить в чёрную дыру" })
map("x", "<leader>p", [["_dP]], { desc = "Вставить без замены буфера" })

-- Закрыть буфер (определяется в snacks.nvim, но добавим fallback)
map("n", "<leader>c", function()
  if pcall(require, "snacks") then
    require("snacks").bufdelete()
  else
    vim.cmd("confirm bd")
  end
end, { desc = "Закрыть буфер" })

map("n", "<leader>C", function()
  if pcall(require, "snacks") then
    require("snacks").bufdelete({ force = true })
  else
    vim.cmd("bd!")
  end
end, { desc = "Принудительно закрыть буфер" })

-- =====================================================================
-- НАВИГАЦИЯ ПО БУФЕРАМ (AstroNvim style)
-- =====================================================================

-- Следующий/предыдущий буфер (]b, [b)
map("n", "]b", "<cmd>bnext<CR>", { desc = "Следующий буфер" })
map("n", "[b", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })

-- Shift + h/l для переключения буферов (AstroNvim style)
map("n", "<S-h>", "<cmd>bprevious<CR>", { desc = "Предыдущий буфер" })
map("n", "<S-l>", "<cmd>bnext<CR>", { desc = "Следующий буфер" })

-- =====================================================================
-- НАВИГАЦИЯ ПО ТАБАМ (AstroNvim style)
-- =====================================================================

map("n", "]t", "<cmd>tabnext<CR>", { desc = "Следующая вкладка" })
map("n", "[t", "<cmd>tabprevious<CR>", { desc = "Предыдущая вкладка" })

-- =====================================================================
-- QUICKFIX И LOCATION СПИСКИ (AstroNvim style)
-- =====================================================================

-- Quickfix
map("n", "]q", "<cmd>cnext<CR>", { desc = "Следующий quickfix" })
map("n", "[q", "<cmd>cprev<CR>", { desc = "Предыдущий quickfix" })
map("n", "]Q", "<cmd>clast<CR>", { desc = "Последний quickfix" })
map("n", "[Q", "<cmd>cfirst<CR>", { desc = "Первый quickfix" })

-- Location list
map("n", "]l", "<cmd>lnext<CR>", { desc = "Следующий loclist" })
map("n", "[l", "<cmd>lprev<CR>", { desc = "Предыдущий loclist" })
map("n", "]L", "<cmd>llast<CR>", { desc = "Последний loclist" })
map("n", "[L", "<cmd>lfirst<CR>", { desc = "Первый loclist" })

-- Открыть списки
map("n", "<leader>xq", "<cmd>copen<CR>", { desc = "Открыть quickfix" })
map("n", "<leader>xl", "<cmd>lopen<CR>", { desc = "Открыть location list" })

-- =====================================================================
-- ДИАГНОСТИКА (AstroNvim style)
-- =====================================================================

-- Навигация по диагностике
map("n", "]d", function() vim.diagnostic.goto_next() end, { desc = "Следующая диагностика" })
map("n", "[d", function() vim.diagnostic.goto_prev() end, { desc = "Предыдущая диагностика" })

-- Навигация по ошибкам
map("n", "]e", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Следующая ошибка" })
map("n", "[e", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
end, { desc = "Предыдущая ошибка" })

-- Навигация по предупреждениям
map("n", "]w", function()
  vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Следующее предупреждение" })
map("n", "[w", function()
  vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
end, { desc = "Предыдущее предупреждение" })

-- Показать диагностику строки
map("n", "gl", function() vim.diagnostic.open_float() end, { desc = "Показать диагностику строки" })
map("n", "<leader>ld", function() vim.diagnostic.open_float() end, { desc = "Диагностика строки" })

-- =====================================================================
-- РЕДАКТИРОВАНИЕ (AstroNvim style)
-- =====================================================================

-- Объединить строки с сохранением позиции курсора
map("n", "J", "mzJ`z", { desc = "Объединить строки (курсор на месте)" })

-- Сдвиги в визуальном режиме с сохранением выделения
map("v", "<", "<gv", { desc = "Сдвиг влево" })
map("v", ">", ">gv", { desc = "Сдвиг вправо" })

-- Перемещение строк вверх/вниз (AstroNvim style)
map("v", "J", ":m '>+1<CR>gv=gv", { desc = "Переместить строку вниз" })
map("v", "K", ":m '<-2<CR>gv=gv", { desc = "Переместить строку вверх" })

-- Сортировка (AstroNvim style)
map("v", "gs", ":sort<CR>", { desc = "Сортировать выделение" })

-- =====================================================================
-- ТЕРМИНАЛ (AstroNvim style)
-- =====================================================================

-- Функция навигации в терминале (из AstroNvim)
local function term_nav(dir)
  return function()
    if vim.api.nvim_win_get_config(0).zindex then
      -- Если в плавающем окне
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-" .. dir .. ">", true, false, true), "n", false)
    else
      -- Обычное окно
      vim.cmd.wincmd(dir)
    end
  end
end

-- Навигация в терминале (AstroNvim style)
map("t", "<C-h>", term_nav("h"), { desc = "Терминал: окно слева" })
map("t", "<C-j>", term_nav("j"), { desc = "Терминал: окно снизу" })
map("t", "<C-k>", term_nav("k"), { desc = "Терминал: окно сверху" })
map("t", "<C-l>", term_nav("l"), { desc = "Терминал: окно справа" })

-- Выход из терминала (Esc два раза)
map("t", "<Esc><Esc>", "<C-\\><C-n>", { desc = "Выйти из режима терминала" })

-- =====================================================================
-- ПОДСВЕТКА ПРИ КОПИРОВАНИИ (AstroNvim style)
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
-- ДОПОЛНИТЕЛЬНЫЕ ПОЛЕЗНЫЕ МАППИНГИ
-- =====================================================================

-- Переименовать текущий файл (AstroNvim style)
map("n", "<leader>R", function()
  local old_name = vim.fn.expand("%")
  local new_name = vim.fn.input("Новое имя: ", old_name, "file")
  if new_name ~= "" and new_name ~= old_name then
    vim.cmd("saveas " .. new_name)
    vim.cmd("silent !rm " .. old_name)
    vim.cmd("bd " .. old_name)
  end
end, { desc = "Переименовать файл" })

print("✓ Neovim keymaps загружены (AstroNvim style)")
