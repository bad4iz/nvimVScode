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
  -- Load early so ensure_installed runs automatically
  event = { "BufReadPre", "BufNewFile" },
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
      -- LSP устанавливаются через mason-lspconfig в lsp.lua.
      "prettierd",
      "stylua",
      "blade-formatter",
    },
  },

  config = function(_, opts)
    require("mason").setup(opts)

    -- Автоматически устанавливаем инструменты
    local mr = require("mason-registry")
    mr.refresh(function()
      for _, tool in ipairs(opts.ensure_installed or {}) do
        local package = mr.get_package(tool)
        if not package:is_installed() and not package:is_installing() then
          package:install()
        end
      end
    end)
  end,
}
