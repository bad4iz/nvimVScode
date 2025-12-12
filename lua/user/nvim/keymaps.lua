--[[
=====================================================================
                    NEOVIM-SPECIFIC KEYMAPS
=====================================================================
Горячие клавиши, которые работают ТОЛЬКО в Neovim.
Требуют функциональности, недоступной в VSCode/Windsurf.

Лидер-клавиша: <Space>
=====================================================================
--]]

local function term_nav(dir)
  return function()
    if vim.api.nvim_win_get_config(0).zindex then
      vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<C-" .. dir .. ">", true, false, true), "n", false)
    else
      vim.cmd.wincmd(dir)
    end
  end
end

local M = {}

-- =====================================================================
-- NORMAL MODE
-- =====================================================================
M.n = {
  -- Простые клавиши
  ["<Esc>"] = { "<cmd>nohlsearch<CR>", desc = "Убрать подсветку поиска" },
  ["|"] = { "<cmd>vsplit<CR>", desc = "Вертикальный сплит" },
  ["\\"] = { "<cmd>split<CR>", desc = "Горизонтальный сплит" },
  ["J"] = { "mzJ`z", desc = "Объединить строки (сохранить курсор)" },

  -- ═══════════════════════════════════════════════════════════════
  -- <leader> группа
  -- ═══════════════════════════════════════════════════════════════
  ["<leader>"] = {
    ["/"] = { "gcc", remap = true, desc = "Toggle comment line" },
    ["n"] = { "<cmd>enew<CR>", desc = "Новый файл" },
    ["q"] = { "<cmd>confirm q<CR>", desc = "Закрыть окно" },
    ["Q"] = { "<cmd>confirm qall<CR>", desc = "Выйти из Neovim" },
    ["d"] = { [["_d]], desc = "Удалить в черную дыру" },
    ["y"] = { [["+y]], desc = "Копировать в буфер обмена" },
    ["Y"] = { [["+Y]], desc = "Копировать строку в буфер обмена" },
    ["c"] = { function() require("snacks").bufdelete() end, desc = "Закрыть буфер" },
    ["C"] = { function() require("snacks").bufdelete({ force = true }) end, desc = "Принудительно закрыть буфер" },

    -- <leader>b - буферы
    b = {
      p = { "<cmd>bprevious<CR>", desc = "Предыдущий буфер" },
    },

    -- <leader>l - LSP
    l = {
      d = { function() vim.diagnostic.open_float() end, desc = "Диагностика строки" },
    },

    -- <leader>x - списки
    x = {
      q = { "<cmd>copen<CR>", desc = "Список quickfix" },
      l = { "<cmd>lopen<CR>", desc = "Список расположения" },
    },

    -- <leader>u - UI/Toggle
    u = {
      Y = {
        function() require("astrolsp.toggles").buffer_semantic_tokens() end,
        desc = "Toggle LSP semantic highlight (buffer)",
        cond = function(client)
          return client.supports_method "textDocument/semanticTokens/full" and vim.lsp.semantic_tokens
        end,
      },
    },
  },


  -- ═══════════════════════════════════════════════════════════════
  -- [ группа (предыдущий)
  -- ═══════════════════════════════════════════════════════════════
  ["["] = {
    b = { "<cmd>bprevious<CR>", desc = "Предыдущий буфер" },
    t = { "<cmd>tabprevious<CR>", desc = "Предыдущая вкладка" },
    q = { "<cmd>cprev<CR>", desc = "Предыдущий quickfix" },
    Q = { "<cmd>cfirst<CR>", desc = "Первый quickfix" },
    l = { "<cmd>lprev<CR>", desc = "Предыдущий loclist" },
    L = { "<cmd>lfirst<CR>", desc = "Первый loclist" },
    d = { function() vim.diagnostic.goto_prev() end, desc = "Предыдущая диагностика" },
    e = { function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Предыдущая ошибка" },
    w = { function() vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN }) end, desc = "Предыдущее предупреждение" },
  },

  -- ═══════════════════════════════════════════════════════════════
  -- ] группа (следующий)
  -- ═══════════════════════════════════════════════════════════════
  ["]"] = {
    b = { "<cmd>bnext<CR>", desc = "Следующий буфер" },
    t = { "<cmd>tabnext<CR>", desc = "Следующая вкладка" },
    q = { "<cmd>cnext<CR>", desc = "Следующий quickfix" },
    Q = { "<cmd>clast<CR>", desc = "Последний quickfix" },
    l = { "<cmd>lnext<CR>", desc = "Следующий loclist" },
    L = { "<cmd>llast<CR>", desc = "Последний loclist" },
    d = { function() vim.diagnostic.goto_next() end, desc = "Следующая диагностика" },
    e = { function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR }) end, desc = "Следующая ошибка" },
    w = { function() vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN }) end, desc = "Следующее предупреждение" },
  },

  -- ═══════════════════════════════════════════════════════════════
  -- <C-> группа (Ctrl+)
  -- ═══════════════════════════════════════════════════════════════
  ["<C-"] = {
    ["q>"] = { "<cmd>q!<CR>", desc = "Принудительный выход" },
    ["h>"] = { "<C-w>h", desc = "Влево в окно" },
    ["j>"] = { "<C-w>j", desc = "Вниз в окно" },
    ["k>"] = { "<C-w>k", desc = "Вверх в окно" },
    ["l>"] = { "<C-w>l", desc = "Вправо в окно" },
    ["Up>"] = { "<cmd>resize -2<CR>", desc = "Уменьшить высоту окна" },
    ["Down>"] = { "<cmd>resize +2<CR>", desc = "Увеличить высоту окна" },
    ["Left>"] = { "<cmd>vertical resize -2<CR>", desc = "Уменьшить ширину окна" },
    ["Right>"] = { "<cmd>vertical resize +2<CR>", desc = "Увеличить ширину окна" },
  },

  -- ═══════════════════════════════════════════════════════════════
  -- <S-> группа (Shift+)
  -- ═══════════════════════════════════════════════════════════════
  ["<S-"] = {
    ["h>"] = { "<cmd>bprevious<CR>", desc = "Предыдущий буфер" },
    ["l>"] = { "<cmd>bnext<CR>", desc = "Следующий буфер" },
  },
}

-- =====================================================================
-- VISUAL MODE
-- =====================================================================
M.v = {
  ["J"] = { ":m '>+1<CR>gv=gv", desc = "Переместить строку вниз" },
  ["K"] = { ":m '<-2<CR>gv=gv", desc = "Переместить строку вверх" },
  ["<"] = { "<gv", desc = "Сдвиг влево" },
  [">"] = { ">gv", desc = "Сдвиг вправо" },

  g = {
    s = { ":sort<CR>", desc = "Сортировать выделение" },
  },

  ["<leader>"] = {
    d = { [["_d]], desc = "Удалить в черную дыру" },
    y = { [["+y]], desc = "Копировать в буфер обмена" },
  },
}

-- =====================================================================
-- VISUAL-BLOCK MODE (x)
-- =====================================================================
M.x = {
  ["<leader>"] = {
    ["/"] = { "gc", remap = true, desc = "Toggle comment" },
    p = { [["_dP]], desc = "Вставить без замены буфера" },
  },
}

-- =====================================================================
-- TERMINAL MODE
-- =====================================================================
M.t = {
  ["<C-"] = {
    ["h>"] = { term_nav("h"), desc = "Терминал: окно слева" },
    ["j>"] = { term_nav("j"), desc = "Терминал: окно ниже" },
    ["k>"] = { term_nav("k"), desc = "Терминал: окно выше" },
    ["l>"] = { term_nav("l"), desc = "Терминал: окно справа" },
  },
}

-- =====================================================================
-- ПРИМЕНЕНИЕ KEYMAPS (рекурсивно для вложенной структуры)
-- =====================================================================
local function is_keymap_def(tbl)
  -- Проверяем, является ли таблица определением keymap (имеет [1] как action)
  return type(tbl) == "table" and (type(tbl[1]) == "function" or type(tbl[1]) == "string")
end

local function apply_keymaps_recursive(mode, prefix, mappings)
  for key, value in pairs(mappings) do
    if is_keymap_def(value) then
      -- Это определение keymap
      local full_key = prefix .. key
      local action = value[1]
      local keymap_opts = {
        desc = value.desc,
        remap = value.remap,
        silent = value.silent ~= false,
      }
      vim.keymap.set(mode, full_key, action, keymap_opts)
    elseif type(value) == "table" then
      -- Это вложенная группа
      apply_keymaps_recursive(mode, prefix .. key, value)
    end
  end
end

local function apply_keymaps()
  for mode, mappings in pairs(M) do
    apply_keymaps_recursive(mode, "", mappings)
  end
end

apply_keymaps()

-- =====================================================================
-- ПОДСВЕТКА ПРИ КОПИРОВАНИИ
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

print("✓ Neovim-specific keymaps loaded")

return M
