--[[
=====================================================================
                      АВТОКОМАНДЫ (AUTOCMDS)
=====================================================================
Автоматические действия при определённых событиях.
Только для standalone Neovim.
=====================================================================
--]]

local augroup = vim.api.nvim_create_augroup
local autocmd = vim.api.nvim_create_autocmd

-- =====================================================================
-- ВОССТАНОВЛЕНИЕ ПОЗИЦИИ КУРСОРА
-- =====================================================================
autocmd("BufReadPost", {
  group = augroup("restore_cursor", { clear = true }),
  callback = function()
    local mark = vim.api.nvim_buf_get_mark(0, '"')
    local lcount = vim.api.nvim_buf_line_count(0)
    if mark[1] > 0 and mark[1] <= lcount then
      pcall(vim.api.nvim_win_set_cursor, 0, mark)
    end
  end,
  desc = "Восстановить позицию курсора при открытии файла",
})

-- =====================================================================
-- АВТОМАТИЧЕСКОЕ СОЗДАНИЕ ДИРЕКТОРИЙ
-- =====================================================================
autocmd("BufWritePre", {
  group = augroup("auto_create_dir", { clear = true }),
  callback = function(event)
    if event.match:match("^%w%w+://") then
      return
    end
    local file = vim.loop.fs_realpath(event.match) or event.match
    vim.fn.mkdir(vim.fn.fnamemodify(file, ":p:h"), "p")
  end,
  desc = "Создать директорию при сохранении если не существует",
})

-- =====================================================================
-- ЗАКРЫТИЕ ОПРЕДЕЛЁННЫХ БУФЕРОВ ПО q
-- =====================================================================
autocmd("FileType", {
  group = augroup("close_with_q", { clear = true }),
  pattern = {
    "help",
    "lspinfo",
    "man",
    "notify",
    "qf",
    "query",
    "spectre_panel",
    "startuptime",
    "tsplayground",
    "checkhealth",
    "PlenaryTestPopup",
  },
  callback = function(event)
    vim.bo[event.buf].buflisted = false
    vim.keymap.set("n", "q", "<cmd>close<cr>", { buffer = event.buf, silent = true })
  end,
  desc = "Закрывать эти буферы по q",
})

-- =====================================================================
-- АВТООБНОВЛЕНИЕ ФАЙЛОВ
-- =====================================================================
autocmd({ "FocusGained", "TermClose", "TermLeave" }, {
  group = augroup("checktime", { clear = true }),
  command = "checktime",
  desc = "Проверять изменения файла при фокусе",
})

-- =====================================================================
-- ПОДСВЕТКА ПРИ КОПИРОВАНИИ
-- =====================================================================
-- Уже есть в common/keymaps.lua, но дублирую на всякий случай
autocmd("TextYankPost", {
  group = augroup("highlight_yank_nvim", { clear = true }),
  callback = function()
    vim.highlight.on_yank({ higroup = "IncSearch", timeout = 200 })
  end,
  desc = "Подсветка при копировании",
})

-- =====================================================================
-- ИЗМЕНЕНИЕ РАЗМЕРА ОКОН ПРИ ИЗМЕНЕНИИ ТЕРМИНАЛА
-- =====================================================================
autocmd("VimResized", {
  group = augroup("resize_splits", { clear = true }),
  callback = function()
    local current_tab = vim.fn.tabpagenr()
    vim.cmd("tabdo wincmd =")
    vim.cmd("tabnext " .. current_tab)
  end,
  desc = "Выровнять размер окон при изменении размера терминала",
})

-- =====================================================================
-- НАСТРОЙКИ ДЛЯ КОНКРЕТНЫХ ТИПОВ ФАЙЛОВ
-- =====================================================================
autocmd("FileType", {
  group = augroup("filetype_settings", { clear = true }),
  pattern = { "json", "jsonc" },
  callback = function()
    vim.opt_local.conceallevel = 0 -- Показывать кавычки в JSON
  end,
  desc = "Настройки для JSON файлов",
})

autocmd("FileType", {
  group = augroup("markdown_settings", { clear = true }),
  pattern = { "markdown" },
  callback = function()
    vim.opt_local.wrap = true
    vim.opt_local.spell = true
  end,
  desc = "Настройки для Markdown",
})

autocmd("FileType", {
  group = augroup("git_commit_settings", { clear = true }),
  pattern = { "gitcommit", "gitrebase" },
  callback = function()
    vim.opt_local.spell = true
    vim.opt_local.wrap = true
  end,
  desc = "Настройки для Git commit",
})

-- =====================================================================
-- УБРАТЬ КОММЕНТАРИЙ ПРИ НОВОЙ СТРОКЕ
-- =====================================================================
autocmd("BufEnter", {
  group = augroup("no_auto_comment", { clear = true }),
  callback = function()
    vim.opt.formatoptions:remove({ "c", "r", "o" })
  end,
  desc = "Не продолжать комментарий на новой строке",
})

-- =====================================================================
-- LSP ATTACH СОБЫТИЯ
-- =====================================================================
autocmd("LspAttach", {
  group = augroup("lsp_attach_custom", { clear = true }),
  callback = function(event)
    local client = vim.lsp.get_client_by_id(event.data.client_id)
    if client and client.name == "eslint" then
      -- Автоисправление ESLint при сохранении
      vim.api.nvim_create_autocmd("BufWritePre", {
        buffer = event.buf,
        command = "EslintFixAll",
      })
    end
  end,
  desc = "Настройки при подключении LSP",
})

print("✓ Автокоманды загружены")
