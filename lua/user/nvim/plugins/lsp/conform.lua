--[[
=====================================================================
                          CONFORM.NVIM
=====================================================================
Легковесный плагин для форматирования кода.

Преимущества перед null-ls/none-ls:
  - Быстрее
  - Проще конфигурация
  - Лучше работает с LSP

Горячие клавиши:
  <leader>lf  - форматировать буфер (также в LSP)
  
Команды:
  :ConformInfo       - информация о форматтерах для текущего файла

Поддерживаемые форматтеры для веб-разработки:
  - prettier    : JS, TS, HTML, CSS, JSON, YAML, MD
  - eslint_d    : JS, TS (исправление ошибок)
  - stylua      : Lua

GitHub: https://github.com/stevearc/conform.nvim
=====================================================================
--]]

return {
  "stevearc/conform.nvim",
  event = { "BufWritePre" },
  cmd = { "ConformInfo" },
  
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- ФОРМАТТЕРЫ ДЛЯ ТИПОВ ФАЙЛОВ
    -- ═══════════════════════════════════════════════════════════════
    formatters_by_ft = {
      -- JavaScript / TypeScript
      javascript = { "prettier", "eslint_d" },
      javascriptreact = { "prettier", "eslint_d" },
      typescript = { "prettier", "eslint_d" },
      typescriptreact = { "prettier", "eslint_d" },
      
      -- Веб
      html = { "prettier" },
      css = { "prettier" },
      scss = { "prettier" },
      less = { "prettier" },
      
      -- Данные
      json = { "prettier" },
      jsonc = { "prettier" },
      yaml = { "prettier" },
      
      -- Markdown
      markdown = { "prettier" },
      ["markdown.mdx"] = { "prettier" },
      
      -- Vue / Svelte
      vue = { "prettier" },
      svelte = { "prettier" },
      
      -- GraphQL
      graphql = { "prettier" },
      
      -- Lua
      lua = { "stylua" },
      
      -- Общее (для всех типов файлов)
      ["_"] = { "trim_whitespace" },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ФОРМАТИРОВАНИЕ ПРИ СОХРАНЕНИИ
    -- ═══════════════════════════════════════════════════════════════
    format_on_save = function(bufnr)
      -- Отключить для определённых типов файлов
      local disable_filetypes = { c = true, cpp = true }
      local ft = vim.bo[bufnr].filetype
      
      if disable_filetypes[ft] then
        return
      end
      
      return {
        timeout_ms = 3000,
        lsp_fallback = true,
      }
    end,
    
    -- ═══════════════════════════════════════════════════════════════
    -- НАСТРОЙКИ ФОРМАТТЕРОВ
    -- ═══════════════════════════════════════════════════════════════
    formatters = {
      prettier = {
        -- Использовать локальный prettier если есть
        command = function()
          local local_prettier = vim.fn.getcwd() .. "/node_modules/.bin/prettier"
          if vim.fn.executable(local_prettier) == 1 then
            return local_prettier
          end
          return "prettier"
        end,
        
        -- Дополнительные аргументы
        prepend_args = {
          "--single-quote",
          "--jsx-single-quote",
        },
      },
      
      eslint_d = {
        -- Использовать для исправления ошибок
        command = "eslint_d",
        args = { "--fix-to-stdout", "--stdin", "--stdin-filename", "$FILENAME" },
        stdin = true,
      },
      
      stylua = {
        prepend_args = {
          "--indent-type", "Spaces",
          "--indent-width", "2",
        },
      },
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- УВЕДОМЛЕНИЯ
    -- ═══════════════════════════════════════════════════════════════
    notify_on_error = true,
  },
  
  -- Горячие клавиши
  keys = {
    {
      "<leader>lf",
      function()
        require("conform").format({ async = true, lsp_fallback = true })
      end,
      mode = { "n", "v" },
      desc = "Форматировать",
    },
  },
  
  init = function()
    -- Используем conform для gq
    vim.o.formatexpr = "v:lua.require'conform'.formatexpr()"
  end,
}
