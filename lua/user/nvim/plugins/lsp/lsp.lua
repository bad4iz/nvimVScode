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
    "williamboman/mason.nvim",

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
      -- Иконки для разных типов диагностики (новый API Neovim 0.10+)
      signs = {
        text = {
          [vim.diagnostic.severity.ERROR] = "", -- Ошибка
          [vim.diagnostic.severity.WARN] = "", -- Предупреждение
          [vim.diagnostic.severity.HINT] = "󰌵", -- Подсказка
          [vim.diagnostic.severity.INFO] = "󰙎", -- Информация
        },
      },
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

    -- Горячие клавиши, подсветка символов и ESLint настраиваются
    -- единственным обработчиком LspAttach в user/nvim/autocmds.lua.

    -- ========================================================================
    -- Настройка возможностей клиента (capabilities)
    -- Расширяем стандартные возможности для поддержки автодополнения
    -- ========================================================================
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    -- Используем blink.cmp для автодополнения (новый движок)
    -- Если blink.cmp загружен, добавляем его возможности
    local has_blink, blink_cmp = pcall(require, "blink.cmp")
    if has_blink then
      capabilities = vim.tbl_deep_extend("force", capabilities, blink_cmp.get_lsp_capabilities())
    else
      -- Fallback на старый cmp_nvim_lsp если blink не загружен
      local has_cmp, cmp_lsp = pcall(require, "cmp_nvim_lsp")
      if has_cmp then
        capabilities = vim.tbl_deep_extend("force", capabilities, cmp_lsp.default_capabilities())
      end
    end

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

      -- PHP / Laravel (работает на Node.js, PHP CLI для LSP не нужен)
      intelephense = {
        root_markers = { "composer.json", ".git" },
      },

      -- Vue: HTML/CSS обслуживает vue_ls, TypeScript внутри SFC — vtsls
      vue_ls = {},

      -- TypeScript / JavaScript / Vue
      vtsls = {
        filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
        settings = {
          vtsls = {
            tsserver = {
              globalPlugins = {
                {
                  name = "@vue/typescript-plugin",
                  location = vim.fn.stdpath("data")
                    .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                  languages = { "vue" },
                  configNamespace = "typescript",
                  enableForWorkspaceTypeScriptVersions = true,
                },
              },
            },
          },
          typescript = {
            -- Подсказки для параметров функций
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
            },
            -- Preferences
            preferences = {
              importModuleSpecifier = "relative",
            },
          },
          javascript = {
            inlayHints = {
              parameterNames = { enabled = "all" },
              parameterTypes = { enabled = true },
              variableTypes = { enabled = true },
              propertyDeclarationTypes = { enabled = true },
              functionLikeReturnTypes = { enabled = true },
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

      -- ESLint (линтер для JS/TS)
      eslint = {
        settings = {
          workingDirectories = { mode = "auto" },
          codeAction = {
            disableRuleComment = {
              enable = true,
              location = "separateLine",
            },
            showDocumentation = {
              enable = true,
            },
          },
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
    -- Neovim 0.11: конфигурации нужно зарегистрировать до включения серверов
    -- ========================================================================
    for server_name, server_opts in pairs(servers) do
      server_opts.capabilities = capabilities
      vim.lsp.config(server_name, server_opts)
    end

    -- Mason настраивается в mason.lua; здесь только установка и включение LSP.
    require("mason-lspconfig").setup({
      ensure_installed = vim.tbl_keys(servers),
      automatic_enable = vim.tbl_keys(servers),
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
