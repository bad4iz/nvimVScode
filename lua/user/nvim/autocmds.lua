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
    -- Spell checking отключен - настраивается в lua/user/nvim/plugins/markdown.lua
    -- vim.opt_local.spell = true
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
    if not client then
      return
    end

    local bufnr = event.buf

    -- -----------------------------------------------------------------
    -- LSP keymaps (AstroNvim style)
    -- We set them here because in Nvim 0.11 + mason-lspconfig v2 servers
    -- are enabled via vim.lsp.enable(), so per-server on_attach in our
    -- old lspconfig setup may never run.
    -- -----------------------------------------------------------------
    local map = function(mode, lhs, rhs, desc)
      vim.keymap.set(mode, lhs, rhs, { buffer = bufnr, desc = desc })
    end

    -- Navigation
    map("n", "gd", vim.lsp.buf.definition, "LSP: Перейти к определению")
    map("n", "gD", vim.lsp.buf.declaration, "LSP: Перейти к объявлению")
    map("n", "gri", vim.lsp.buf.implementation, "LSP: Перейти к реализации")
    map("n", "grr", vim.lsp.buf.references, "LSP: Показать использования")
    map("n", "gy", vim.lsp.buf.type_definition, "LSP: Перейти к определению типа")

    -- Info
    map("n", "K", vim.lsp.buf.hover, "LSP: Показать документацию")
    map("n", "gK", vim.lsp.buf.signature_help, "LSP: Сигнатура функции")
    map("n", "<Leader>lh", vim.lsp.buf.signature_help, "LSP: Сигнатура функции")

    -- LSP menu
    map("n", "<Leader>li", "<cmd>LspInfo<cr>", "LSP: Информация")
    map("n", "<Leader>lI", "<cmd>Mason<cr>", "LSP: Mason")

    map({ "n", "v" }, "<Leader>la", vim.lsp.buf.code_action, "LSP: Действия кода")
    map({ "n", "v" }, "<Leader>lA", function()
      vim.lsp.buf.code_action({ context = { only = { "source" } } })
    end, "LSP: Source Action")

    map({ "n", "v" }, "<Leader>lf", function()
      -- Prefer ESLint fixes (includes Prettier via eslint-plugin-prettier) when available.
      local has_eslint = false
      for _, c in ipairs(vim.lsp.get_clients({ bufnr = bufnr })) do
        if c.name == "eslint" then
          has_eslint = true
          break
        end
      end

      if has_eslint and vim.fn.exists(":EslintFixAll") == 2 then
        pcall(vim.cmd, "EslintFixAll")
        return
      end

      local ok, conform = pcall(require, "conform")
      if ok then
        conform.format({ async = true, lsp_fallback = true })
      else
        vim.lsp.buf.format({ async = true })
      end
    end, "LSP: Форматировать")

    map("n", "<Leader>lr", vim.lsp.buf.rename, "LSP: Переименовать символ")

    -- Diagnostics
    map("n", "<Leader>ld", vim.diagnostic.open_float, "LSP: Диагностика строки")
    map("n", "<Leader>lD", "<cmd>Telescope diagnostics bufnr=0<cr>", "LSP: Диагностика буфера")

    -- CodeLens
    map("n", "<Leader>ll", vim.lsp.codelens.refresh, "LSP: Обновить CodeLens")
    map("n", "<Leader>lL", vim.lsp.codelens.run, "LSP: Запустить CodeLens")

    -- Symbols
    map("n", "<Leader>ls", vim.lsp.buf.document_symbol, "LSP: Символы документа")
    map("n", "<Leader>lG", vim.lsp.buf.workspace_symbol, "LSP: Символы проекта")
    map("n", "<Leader>lS", "<cmd>LspRestart<cr>", "LSP: Перезапустить LSP")

    -- Highlight symbol under cursor (if supported)
    if client.server_capabilities and client.server_capabilities.documentHighlightProvider then
      local highlight_group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
      vim.api.nvim_clear_autocmds({ group = highlight_group, buffer = bufnr })
      vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.document_highlight,
      })
      vim.api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI" }, {
        buffer = bufnr,
        group = highlight_group,
        callback = vim.lsp.buf.clear_references,
      })
    end

    -- -----------------------------------------------------------------
    -- ESLint: auto-fix on save (single source of truth: eslint-lsp)
    -- In Nvim 0.11 the eslint config provides buffer-local :LspEslintFixAll.
    -- -----------------------------------------------------------------
    if client.name == "eslint" then
      local function eslint_fix_all()
        local params = {
          command = "eslint.applyAllFixes",
          arguments = {
            {
              uri = vim.uri_from_bufnr(bufnr),
              version = vim.lsp.util.buf_versions[bufnr],
            },
          },
        }

        -- Default `client:request_sync()` timeout is 1000ms, which is often too
        -- small for TypeScript projects (it just silently times out).
        client:request_sync("workspace/executeCommand", params, 10000, bufnr)
      end

      -- Provide a familiar command name for manual use.
      pcall(vim.api.nvim_buf_create_user_command, bufnr, "EslintFixAll", eslint_fix_all, {
        desc = "ESLint: Fix all auto-fixable problems",
      })

      local group = vim.api.nvim_create_augroup("LspEslintFixAll", { clear = false })
      vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
      vim.api.nvim_create_autocmd("BufWritePre", {
        group = group,
        buffer = bufnr,
        callback = function()
          pcall(eslint_fix_all)
        end,
        desc = "ESLint: Fix all auto-fixable problems",
      })
    end
  end,
  desc = "Настройки при подключении LSP",
})

-- =====================================================================
-- АВТОЗАКРЫТИЕ СПЕЦИАЛЬНЫХ БУФЕРОВ
-- =====================================================================
autocmd("BufDelete", {
  group = augroup("auto_close_special_buffers", { clear = true }),
  callback = function()
    vim.schedule(function()
      -- Список специальных буферов для закрытия
      local special_buffers = { "coder_claudecode" }

      -- Проверяем, остались ли обычные буферы
      local has_normal_buffers = false
      for _, buf in ipairs(vim.api.nvim_list_bufs()) do
        if vim.api.nvim_buf_is_valid(buf) and vim.bo[buf].buflisted then
          local bufname = vim.api.nvim_buf_get_name(buf)
          local filetype = vim.bo[buf].filetype

          -- Игнорируем специальные буферы
          local is_special = filetype == "neo-tree"
            or filetype == "snacks_dashboard"
            or filetype == "alpha"
            or filetype == "dashboard"
            or bufname:match("coder_claudecode")

          if not is_special then
            has_normal_buffers = true
            break
          end
        end
      end

      -- Если нет обычных буферов, закрываем специальные
      if not has_normal_buffers then
        for _, buf in ipairs(vim.api.nvim_list_bufs()) do
          if vim.api.nvim_buf_is_valid(buf) then
            local bufname = vim.api.nvim_buf_get_name(buf)
            for _, pattern in ipairs(special_buffers) do
              if bufname:match(pattern) then
                pcall(vim.api.nvim_buf_delete, buf, { force = false })
              end
            end
          end
        end
      end
    end)
  end,
  desc = "Автоматически закрывать специальные буферы когда нет обычных",
})
