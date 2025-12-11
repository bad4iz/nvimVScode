--[[
=====================================================================
                          MASON
=====================================================================
Менеджер для установки LSP серверов, линтеров и форматтеров.

Команды:
  :Mason              - открыть UI Mason
  :MasonInstall       - установить пакет
  :MasonUninstall     - удалить пакет
  :MasonUpdate        - обновить пакеты

GitHub: https://github.com/williamboman/mason.nvim
=====================================================================
--]]

return {
  "williamboman/mason.nvim",
  cmd = "Mason",
  build = ":MasonUpdate",
  
  opts = {
    ui = {
      icons = {
        package_installed = "✓",
        package_pending = "➜",
        package_uninstalled = "✗",
      },
      border = "rounded",
    },
    
    ensure_installed = {
      -- LSP серверы (vtsls исключён - используется typescript-tools.nvim)
      "html-lsp",
      "css-lsp",
      "tailwindcss-language-server",
      "json-lsp",
      "yaml-language-server",
      "lua-language-server",
      "eslint-lsp",
      "emmet-ls",
      "marksman", -- Markdown LSP

      -- Форматтеры (претиерд быстрее)
      "prettierd",
      "stylua",

      -- Линтеры (демон для быстрой проверки)
      "eslint_d",
    },
  },
  
  config = function(_, opts)
    require("mason").setup(opts)
    
    -- Автоматически устанавливаем инструменты
    local mr = require("mason-registry")
    for _, tool in ipairs(opts.ensure_installed or {}) do
      local p = mr.get_package(tool)
      if not p:is_installed() then
        p:install()
      end
    end
  end,
}
