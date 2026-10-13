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
  - stylua      : Lua
  - pint        : PHP (из vendor/bin проекта, при наличии PHP CLI)
  - blade-formatter : Laravel Blade (работает на Node.js)

GitHub: https://github.com/stevearc/conform.nvim
=====================================================================
--]]

return {
  "stevearc/conform.nvim",
  -- Load before first save so format_on_save works immediately
  event = { "BufReadPre", "BufNewFile" },
  cmd = { "ConformInfo" },
  
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- ФОРМАТТЕРЫ ДЛЯ ТИПОВ ФАЙЛОВ
    -- ═══════════════════════════════════════════════════════════════
    formatters_by_ft = {
      -- JavaScript / TypeScript
      -- ESLint fixes are handled by eslint-lsp (:EslintFixAll) in lsp.lua.
      -- Formatting is handled by prettierd.
      javascript = { "prettierd" },
      javascriptreact = { "prettierd" },
      typescript = { "prettierd" },
      typescriptreact = { "prettierd" },
      
      -- Веб
      html = { "prettierd" },
      css = { "prettierd" },
      scss = { "prettierd" },
      less = { "prettierd" },
      
      -- Данные
      json = { "prettierd" },
      jsonc = { "prettierd" },
      yaml = { "prettierd" },
      
      -- Markdown
      markdown = { "prettierd" },
      ["markdown.mdx"] = { "prettierd" },
      
      -- Vue / Svelte
      vue = { "prettierd" },
      svelte = { "prettierd" },

      -- PHP / Laravel: без доступного Pint используется форматирование LSP.
      php = { "pint" },
      blade = { "blade-formatter" },
      
      -- GraphQL
      graphql = { "prettierd" },
      
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
      pint = {
        condition = function()
          return vim.fn.executable("php") == 1
        end,
        cwd = function(_, ctx)
          return vim.fs.root(ctx.dirname, { "composer.json" })
        end,
        require_cwd = true,
      },

      -- Prefer prettierd (installed via Mason), but fall back to local prettier.
      prettierd = {
        env = function()
          -- В headless/SSH-сессии XDG_RUNTIME_DIR может указывать на недоступный каталог.
          local runtime_dir = vim.env.XDG_RUNTIME_DIR
          if not runtime_dir or vim.fn.filewritable(runtime_dir) ~= 2 then
            return { XDG_RUNTIME_DIR = vim.fn.stdpath("cache") .. "/prettierd" }
          end
          return {}
        end,
        command = function()
          local prettierd = vim.fn.exepath("prettierd")
          if prettierd and prettierd ~= "" then
            return prettierd
          end

          local local_prettier = vim.fn.getcwd() .. "/node_modules/.bin/prettier"
          if vim.fn.executable(local_prettier) == 1 then
            return local_prettier
          end

          return "prettier"
        end,
        prepend_args = {
          "--single-quote",
          "--jsx-single-quote",
        },
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
