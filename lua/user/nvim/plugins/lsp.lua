-- ============================================================================
-- Конфигурация LSP (Language Server Protocol) для Neovim
-- LSP обеспечивает: автодополнение, переход к определению, рефакторинг,
-- диагностику ошибок, подсказки и многое другое
-- ============================================================================

return {
  -- Основной плагин для настройки LSP серверов
  "neovim/nvim-lspconfig",

  -- Загружать при открытии файла (ленивая загрузка)
  event = { "BufReadPre", "BufNewFile" },

  -- Зависимости плагина
  dependencies = {
    -- mason.nvim - менеджер для установки LSP серверов, линтеров, форматтеров
    -- Позволяет устанавливать серверы командой :MasonInstall
    { "williamboman/mason.nvim", config = true },

    -- Мост между mason и lspconfig - автоматически настраивает установленные серверы
    "williamboman/mason-lspconfig.nvim",

    -- Улучшенные подсказки для Neovim Lua API (полезно при написании конфигов)
    { "folke/neodev.nvim", opts = {} },

    -- Индикатор прогресса загрузки LSP в правом нижнем углу
    { "j-hui/fidget.nvim", opts = {} },

    -- JSON Schema Store для YAML и JSON серверов
    "b0o/schemastore.nvim",
  },

  config = function()
    -- ========================================================================
    -- Настройка диагностики (отображение ошибок и предупреждений)
    -- ========================================================================
    vim.diagnostic.config({
      -- Показывать виртуальный текст справа от строки с ошибкой
      virtual_text = {
        prefix = "●", -- Символ перед текстом ошибки
        spacing = 4, -- Отступ от кода
      },
      -- Показывать знаки в колонке слева (●, ▲ и т.д.)
      signs = true,
      -- Подчёркивать проблемный код
      underline = true,
      -- Обновлять диагностику в режиме вставки
      update_in_insert = false,
      -- Сортировка по важности (ошибки выше предупреждений)
      severity_sort = true,
      -- Настройка всплывающего окна с диагностикой
      float = {
        border = "rounded", -- Скруглённые углы окна
        source = "always", -- Всегда показывать источник (eslint, typescript и т.д.)
        header = "", -- Без заголовка
        prefix = "", -- Без префикса
      },
    })

    -- Иконки для разных типов диагностики в колонке знаков
    local signs = {
      Error = "", -- Ошибка
      Warn = "", -- Предупреждение
      Hint = "󰌵", -- Подсказка
      Info = "", -- Информация
    }
    for type, icon in pairs(signs) do
      local hl = "DiagnosticSign" .. type
      vim.fn.sign_define(hl, { text = icon, texthl = hl, numhl = hl })
    end

    -- ========================================================================
    -- Функция, вызываемая при подключении LSP к буферу
    -- Здесь настраиваются клавиши для работы с LSP
    -- ========================================================================
    local on_attach = function(client, bufnr)
      -- Вспомогательная функция для создания маппингов
      local map = function(keys, func, desc)
        vim.keymap.set("n", keys, func, { buffer = bufnr, desc = "LSP: " .. desc })
      end

      -- ======================================================================
      -- Навигация по коду (в стиле AstroNvim)
      -- ======================================================================
      -- gd - перейти к определению функции/переменной (где она объявлена)
      map("gd", vim.lsp.buf.definition, "Перейти к определению")

      -- gD - перейти к объявлению (declaration) - для C/C++ это прототип функции
      map("gD", vim.lsp.buf.declaration, "Перейти к объявлению")

      -- gri - перейти к реализации интерфейса/абстрактного метода
      map("gri", vim.lsp.buf.implementation, "Перейти к реализации")

      -- grr - показать все места, где используется символ под курсором
      map("grr", vim.lsp.buf.references, "Показать использования")

      -- gy - перейти к определению типа переменной
      map("gy", vim.lsp.buf.type_definition, "Перейти к определению типа")

      -- ======================================================================
      -- Информация о коде
      -- ======================================================================
      -- K - показать документацию для символа под курсором (hover)
      map("K", vim.lsp.buf.hover, "Показать документацию")

      -- gK или <Leader>lh - показать сигнатуру функции (параметры)
      map("gK", vim.lsp.buf.signature_help, "Сигнатура функции")
      map("<Leader>lh", vim.lsp.buf.signature_help, "Сигнатура функции")

      -- ======================================================================
      -- LSP меню (<Leader>l) - в стиле AstroNvim
      -- ======================================================================
      -- <Leader>li - информация о LSP серверах для текущего буфера
      map("<Leader>li", "<cmd>LspInfo<cr>", "Информация о LSP")

      -- <Leader>lI - информация о Mason (установленные серверы)
      map("<Leader>lI", "<cmd>Mason<cr>", "Информация о Mason")

      -- <Leader>la - показать доступные действия (исправления, импорты и т.д.)
      map("<Leader>la", vim.lsp.buf.code_action, "Code Action (действия)")

      -- <Leader>lA - показать только source actions (организация импортов и т.д.)
      map("<Leader>lA", function()
        vim.lsp.buf.code_action({ context = { only = { "source" }, diagnostics = {} } })
      end, "Source Action")

      -- <Leader>lr - переименовать символ во всём проекте
      map("<Leader>lr", vim.lsp.buf.rename, "Переименовать символ")

      -- <Leader>lR - показать все использования символа
      map("<Leader>lR", vim.lsp.buf.references, "Поиск использований")

      -- <Leader>lf - отформатировать текущий буфер
      map("<Leader>lf", function()
        vim.lsp.buf.format({ async = true })
      end, "Форматировать буфер")

      -- <Leader>ll - обновить CodeLens (если поддерживается)
      map("<Leader>ll", vim.lsp.codelens.refresh, "Обновить CodeLens")

      -- <Leader>lL - запустить CodeLens
      map("<Leader>lL", vim.lsp.codelens.run, "Запустить CodeLens")

      -- <Leader>ls - символы в текущем буфере (document symbols)
      map("<Leader>ls", vim.lsp.buf.document_symbol, "Символы документа")

      -- <Leader>lG - символы во всём проекте (workspace symbols)
      map("<Leader>lG", vim.lsp.buf.workspace_symbol, "Символы проекта")

      -- <Leader>lS - перезапустить LSP сервер
      map("<Leader>lS", "<cmd>LspRestart<cr>", "Перезапустить LSP")

      -- ======================================================================
      -- Диагностика (ошибки и предупреждения)
      -- ======================================================================
      -- gl или <Leader>ld - показать диагностику для текущей строки
      map("<Leader>ld", vim.diagnostic.open_float, "Диагностика строки")

      -- <Leader>lD - показать все ошибки в буфере
      map("<Leader>lD", "<cmd>Telescope diagnostics bufnr=0<cr>", "Диагностика буфера")

      -- [d - перейти к предыдущей ошибке/предупреждению
      map("gE", vim.diagnostic.goto_prev, "Предыдущая ошибка")

      -- ]d - перейти к следующей ошибке/предупреждению
      map("ge", vim.diagnostic.goto_next, "Следующая ошибка")

      -- ]e / [e - навигация только по ошибкам (без предупреждений)
      map("]e", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
      end, "Следующая ERROR")

      map("[e", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
      end, "Предыдущая ERROR")

      -- ]w / [w - навигация только по предупреждениям
      map("]w", function()
        vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
      end, "Следующий WARN")
      map("[w", function()
        vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
      end, "Предыдущий WARN")

      -- <Leader>xq - открыть список ошибок в quickfix
      map("<Leader>xq", vim.diagnostic.setqflist, "Диагностика в quickfix")

      -- <Leader>xl - открыть список ошибок в loclist
      map("<Leader>xl", vim.diagnostic.setloclist, "Диагностика в loclist")

      -- Подсветка символа под курсором (если сервер поддерживает)
      if client.server_capabilities.documentHighlightProvider then
        local highlight_group = vim.api.nvim_create_augroup("LSPDocumentHighlight", { clear = false })
        -- При остановке курсора - подсветить все вхождения символа
        vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
          buffer = bufnr,
          group = highlight_group,
          callback = vim.lsp.buf.document_highlight,
        })
        -- При движении курсора - убрать подсветку
        vim.api.nvim_create_autocmd({ "CursorMove f", "CursorMovedI" }, {
          buffer = bufnr,
          group = highlight_group,
          callback = vim.lsp.buf.clear_references,
        })
      end
    end

    -- ========================================================================
    -- Настройка возможностей клиента (capabilities)
    -- Расширяем стандартные возможности для поддержки автодополнения
    -- ========================================================================
    -- local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- -- Используем blink.cmp для автодополнения (новый движок)
    -- -- Если blink.cmp загружен, добавляем его возможности
    -- local has_blink, blink_cmp = pcall(require, "blink.cmp")
    -- if has_blink then
    --   capabilities = vim.tbl_deep_extend("force", capabilities, blink_cmp.get_lsp_capabilities())
    -- else
    --   -- Fallback на старый cmp_nvim_lsp если blink не загружен
    --   local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
    --   if has_cmp then
    --     capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
    --   end
    -- end
    

    -- ========================================================================
    -- Список LSP серверов и их настройки
    -- Установить сервер: :MasonInstall <имя_сервера>
    -- ========================================================================
    local servers = {
      -- Lua (для конфигов Neovim)
      lua_ls = {
        settings = {
          Lua = {
            -- Не показывать предупреждение о глобальной переменной vim
            diagnostics = { globals = { "vim" } },
            -- Настройки рабочего пространства
            workspace = {
              -- Подключить библиотеку Neovim для автодополнения API
              library = vim.api.nvim_get_runtime_file("", true),
              checkThirdParty = false, -- Не спрашивать о сторонних библиотеках
            },
            -- Отключить телеметрию
            telemetry = { enable = false },
          },
        },
      },

      -- TypeScript/JavaScript (веб-разработка)
      ts_ls = {
        settings = {
          typescript = {
            -- Подсказки для параметров функций
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
          },
          javascript = {
            inlayHints = {
              includeInlayParameterNameHints = "all",
              includeInlayFunctionParameterTypeHints = true,
              includeInlayVariableTypeHints = true,
            },
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

      -- HTML
      html = {},

      -- CSS/SCSS/LESS
      cssls = {},

      -- Tailwind CSS (автодополнение классов)
      tailwindcss = {},

      -- ESLint (линтер для JS/TS)
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
          "html",
          "css",
          "scss",
          "javascript",
          "javascriptreact",
          "typescript",
          "typescriptreact",
          "vue",
          "svelte",
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
    }

    -- ========================================================================
    -- Настройка Mason (менеджер LSP серверов)
    -- ========================================================================
    require("mason").setup({
      ui = {
        border = "rounded",
        icons = {
          package_installed = "✓",
          package_pending = "➜",
          package_uninstalled = "✗",
        },
      },
    })

    -- Автоматическая настройка серверов через mason-lspconfig
    require("mason-lspconfig").setup({
      -- Серверы, которые будут установлены автоматически
      ensure_installed = vim.tbl_keys(servers),
      -- Автоматически настраивать установленные серверы
      automatic_installation = true,
      -- Обработчики для настройки серверов (новый API mason-lspconfig v2)
      handlers = {
        -- Обработчик по умолчанию для всех серверов
        function(server_name)
          local server_opts = servers[server_name] or {}
          server_opts.on_attach = on_attach
          server_opts.capabilities = capabilities
          require("lspconfig")[server_name].setup(server_opts)
        end,
      },
    })

    -- ========================================================================
    -- Полезные команды
    -- ========================================================================
    -- :LspInfo - информация о подключённых LSP серверах
    -- :LspStart - запустить LSP для текущего буфера
    -- :LspStop - остановить LSP
    -- :LspRestart - перезапустить LSP
    -- :Mason - открыть менеджер серверов
    -- :MasonInstall <server> - установить сервер
    -- :MasonUninstall <server> - удалить сервер
  end,
}
