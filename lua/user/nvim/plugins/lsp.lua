--[[
=====================================================================
                          LSP CONFIG
=====================================================================
Конфигурация Language Server Protocol для умной работы с кодом.

Возможности:
  - Автодополнение
  - Переход к определению
  - Поиск ссылок
  - Рефакторинг
  - Диагностика ошибок

Горячие клавиши:
  gd          - перейти к определению
  gD          - перейти к объявлению
  gr          - найти ссылки
  gI          - перейти к реализации
  K           - показать документацию
  <leader>la  - действия кода (code actions)
  <leader>lr  - переименовать
  <leader>lf  - форматировать
  <leader>ld  - диагностика буфера
  [d          - предыдущая ошибка
  ]d          - следующая ошибка

GitHub: https://github.com/neovim/nvim-lspconfig
=====================================================================
--]]

return {
  -- ═══════════════════════════════════════════════════════════════
  -- NVIM-LSPCONFIG - Конфигурация LSP серверов
  -- ═══════════════════════════════════════════════════════════════
  {
    "neovim/nvim-lspconfig",
    event = { "BufReadPost", "BufNewFile", "BufWritePre" },
    
    dependencies = {
      -- Менеджер LSP серверов
      "williamboman/mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      
      -- Улучшенные возможности для Lua (neovim конфигурация)
      { "folke/neodev.nvim", opts = {} },
      
      -- Схемы для JSON
      "b0o/schemastore.nvim",
      
      -- Индикатор прогресса LSP
      { "j-hui/fidget.nvim", opts = {} },
    },
    
    opts = {
      -- Включить inlay hints (если сервер поддерживает)
      inlay_hints = {
        enabled = true,
      },
      
      -- Включить codelens (если сервер поддерживает)
      codelens = {
        enabled = false,
      },
      
      -- Возможности клиента
      capabilities = {},
      
      -- Серверы LSP
      servers = {
        -- ─────────────────────────────────────────────────────────
        -- TypeScript / JavaScript
        -- ─────────────────────────────────────────────────────────
        ts_ls = {
          enabled = false, -- Используем typescript-tools вместо этого
        },
        
        -- ─────────────────────────────────────────────────────────
        -- HTML
        -- ─────────────────────────────────────────────────────────
        html = {
          filetypes = { "html", "templ" },
        },
        
        -- ─────────────────────────────────────────────────────────
        -- CSS / SCSS
        -- ─────────────────────────────────────────────────────────
        cssls = {},
        
        -- ─────────────────────────────────────────────────────────
        -- Tailwind CSS
        -- ─────────────────────────────────────────────────────────
        tailwindcss = {
          filetypes = { 
            "html", "css", "scss", "javascript", "javascriptreact", 
            "typescript", "typescriptreact", "vue", "svelte" 
          },
        },
        
        -- ─────────────────────────────────────────────────────────
        -- JSON
        -- ─────────────────────────────────────────────────────────
        jsonls = {
          settings = {
            json = {
              schemas = require("schemastore").json.schemas(),
              validate = { enable = true },
            },
          },
        },
        
        -- ─────────────────────────────────────────────────────────
        -- YAML
        -- ─────────────────────────────────────────────────────────
        yamlls = {
          settings = {
            yaml = {
              schemaStore = {
                enable = false,
                url = "",
              },
              schemas = require("schemastore").yaml.schemas(),
            },
          },
        },
        
        -- ─────────────────────────────────────────────────────────
        -- Lua (для Neovim конфигурации)
        -- ─────────────────────────────────────────────────────────
        lua_ls = {
          settings = {
            Lua = {
              workspace = {
                checkThirdParty = false,
              },
              codeLens = {
                enable = true,
              },
              completion = {
                callSnippet = "Replace",
              },
              diagnostics = {
                globals = { "vim" },
              },
            },
          },
        },

        -- ─────────────────────────────────────────────────────────
        -- Markdown
        -- ─────────────────────────────────────────────────────────
        marksman = {
          filetypes = { "markdown", "markdown.mdx" },
          -- Отключить диагностику (только автодополнение и навигация)
          handlers = {
            ["textDocument/publishDiagnostics"] = function() end,
          },
          settings = {
            marksman = {
              -- Включить автодополнение
              completion = {
                enabled = true,
              },
              -- Включить навигацию
              references = {
                enabled = true,
              },
            },
          },
        },

        -- ─────────────────────────────────────────────────────────
        -- ESLint
        -- ─────────────────────────────────────────────────────────
        eslint = {
          settings = {
            workingDirectories = { mode = "auto" },
          },
        },
        
        -- ─────────────────────────────────────────────────────────
        -- Emmet (для быстрого написания HTML)
        -- ─────────────────────────────────────────────────────────
        emmet_ls = {
          filetypes = { 
            "html", "css", "scss", "javascript", "javascriptreact",
            "typescript", "typescriptreact", "vue", "svelte"
          },
        },
      },
      
      -- Настройка серверов
      setup = {},
    },
    
    config = function(_, opts)
      -- Диагностика настроена в user.nvim.options
      
      -- Возможности клиента с blink.cmp
      local capabilities = vim.tbl_deep_extend(
        "force",
        {},
        vim.lsp.protocol.make_client_capabilities(),
        opts.capabilities or {}
      )
      
      -- Пытаемся добавить возможности blink.cmp
      local has_blink, blink = pcall(require, "blink.cmp")
      if has_blink then
        capabilities = blink.get_lsp_capabilities(capabilities)
      end
      
      -- Функция при подключении LSP к буферу
      local on_attach = function(client, bufnr)
        local map = function(keys, func, desc)
          vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
        end
        
        -- Навигация
        map("gd", vim.lsp.buf.definition, "Определение")
        map("gD", vim.lsp.buf.declaration, "Объявление")
        map("gI", vim.lsp.buf.implementation, "Реализация")
        map("gy", vim.lsp.buf.type_definition, "Тип")
        
        -- Используем snacks.picker для ссылок (если доступен)
        map("gr", function()
          if package.loaded["snacks"] then
            Snacks.picker.lsp_references()
          else
            vim.lsp.buf.references()
          end
        end, "Ссылки")
        
        -- Документация
        map("K", vim.lsp.buf.hover, "Документация")
        map("<C-k>", vim.lsp.buf.signature_help, "Сигнатура")
        
        -- Действия
        map("<leader>la", vim.lsp.buf.code_action, "Действия кода")
        map("<leader>lr", vim.lsp.buf.rename, "Переименовать")
        
        -- Диагностика
        map("<leader>ld", vim.diagnostic.open_float, "Диагностика строки")
        map("[d", vim.diagnostic.goto_prev, "Предыдущая ошибка")
        map("]d", vim.diagnostic.goto_next, "Следующая ошибка")
        
        -- Переключение виртуального текста диагностики
        map("<leader>uv", function()
          local current = vim.diagnostic.config().virtual_text
          vim.diagnostic.config({ virtual_text = not current })
          vim.notify(
            "Виртуальный текст диагностики: " .. (current and "OFF" or "ON"),
            vim.log.levels.INFO
          )
        end, "Переключить виртуальный текст диагностики")
        
        -- Форматирование
        map("<leader>lf", function()
          vim.lsp.buf.format({ async = true })
        end, "Форматировать")
        
        -- Inlay hints (если поддерживается)
        if client.supports_method("textDocument/inlayHint") then
          vim.lsp.inlay_hint.enable(true, { bufnr = bufnr })
        end
      end
      
      -- Настраиваем mason-lspconfig
      require("mason-lspconfig").setup({
        ensure_installed = vim.tbl_keys(opts.servers or {}),
        handlers = {
          function(server_name)
            local server = opts.servers[server_name] or {}
            
            -- Пропускаем отключённые серверы
            if server.enabled == false then
              return
            end
            
            server.capabilities = vim.tbl_deep_extend(
              "force",
              {},
              capabilities,
              server.capabilities or {}
            )
            
            server.on_attach = on_attach
            
            vim.lsp.config(server_name, server)
          end,
        },
      })
    end,
  },
  
  -- ═══════════════════════════════════════════════════════════════
  -- TYPESCRIPT-TOOLS - Улучшенная поддержка TypeScript
  -- ═══════════════════════════════════════════════════════════════
  {
    "pmizio/typescript-tools.nvim",
    dependencies = { "nvim-lua/plenary.nvim", "neovim/nvim-lspconfig" },
    ft = { "javascript", "javascriptreact", "typescript", "typescriptreact" },
    
    opts = {
      settings = {
        -- Раздельные параметры для ts и js
        separate_diagnostic_server = true,
        
        -- Публиковать диагностику при вставке текста
        publish_diagnostic_on = "insert_leave",
        
        -- Inlay hints
        tsserver_file_preferences = {
          includeInlayParameterNameHints = "all",
          includeInlayParameterNameHintsWhenArgumentMatchesName = false,
          includeInlayFunctionParameterTypeHints = true,
          includeInlayVariableTypeHints = true,
          includeInlayPropertyDeclarationTypeHints = true,
          includeInlayFunctionLikeReturnTypeHints = true,
          includeInlayEnumMemberValueHints = true,
        },
      },
    },
    
    keys = {
      { "<leader>lo", "<cmd>TSToolsOrganizeImports<cr>", desc = "Организовать импорты" },
      { "<leader>ls", "<cmd>TSToolsSortImports<cr>", desc = "Сортировать импорты" },
      { "<leader>lu", "<cmd>TSToolsRemoveUnused<cr>", desc = "Удалить неиспользуемое" },
      { "<leader>lm", "<cmd>TSToolsAddMissingImports<cr>", desc = "Добавить импорты" },
      { "<leader>lR", "<cmd>TSToolsRenameFile<cr>", desc = "Переименовать файл" },
    },
  },
}
