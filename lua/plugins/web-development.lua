-- PHP/Laravel, Blade и Vue поверх штатных настроек AstroNvim v6.
local formatters_by_ft = {
  php = { "pint" },
  blade = { "blade-formatter" },
  vue = { "prettierd" },
  javascript = { "prettierd" },
  javascriptreact = { "prettierd" },
  typescript = { "prettierd" },
  typescriptreact = { "prettierd" },
}

local function eslint_fix_all(client, bufnr)
  client:request_sync("workspace/executeCommand", {
    command = "eslint.applyAllFixes",
    arguments = {
      { uri = vim.uri_from_bufnr(bufnr), version = vim.lsp.util.buf_versions[bufnr] },
    },
  }, 10000, bufnr)
end

local function fix_eslint(bufnr)
  for _, client in ipairs(vim.lsp.get_clients { bufnr = bufnr, name = "eslint" }) do
    eslint_fix_all(client, bufnr)
  end
end

local function format_buffer()
  fix_eslint(vim.api.nvim_get_current_buf())
  require("conform").format { async = true, lsp_format = "fallback" }
end

local function format_selection() require("conform").format { async = true, lsp_format = "fallback" } end

return {
  {
    "AstroNvim/astrocore",
    opts = {
      filetypes = { pattern = { [".*%.blade%.php"] = "blade" } },
      treesitter = {
        ensure_installed = { "javascript", "typescript", "tsx", "vue", "php", "php_only", "blade", "html", "css" },
      },
      autocmds = {
        php_blade_settings = {
          {
            event = "FileType",
            pattern = { "php", "blade" },
            desc = "Отступы PHP/Blade; проектный .editorconfig имеет приоритет",
            callback = function()
              vim.opt_local.expandtab = true
              vim.opt_local.shiftwidth = 4
              vim.opt_local.tabstop = 4
              vim.opt_local.softtabstop = 4
              if vim.bo.filetype == "blade" then vim.opt_local.commentstring = "{{-- %s --}}" end
            end,
          },
        },
      },
      mappings = {
        n = {
          ["<Leader>lf"] = { format_buffer, desc = "Форматирование и исправления ESLint" },
        },
        x = { ["<Leader>lf"] = { format_selection, desc = "Форматировать выделение" } },
      },
    },
  },
  {
    "AstroNvim/astrolsp",
    opts = function(_, opts)
      -- Веб-файлы форматирует Conform; остальные сохраняют форматирование AstroLSP.
      local previous_condition = opts.autocmds.lsp_auto_format.cond
      opts.autocmds.lsp_auto_format.cond = function(client, bufnr)
        return not formatters_by_ft[vim.bo[bufnr].filetype] and previous_condition(client, bufnr)
      end
      opts.config = vim.tbl_deep_extend("force", opts.config or {}, {
        intelephense = { root_markers = { "composer.json", ".git" } },
        vue_ls = {},
        vtsls = {
          filetypes = { "javascript", "javascriptreact", "typescript", "typescriptreact", "vue" },
          settings = {
            vtsls = {
              tsserver = {
                globalPlugins = {
                  {
                    name = "@vue/typescript-plugin",
                    location = vim.fn.stdpath "data"
                      .. "/mason/packages/vue-language-server/node_modules/@vue/language-server",
                    languages = { "vue" },
                    configNamespace = "typescript",
                    enableForWorkspaceTypeScriptVersions = true,
                  },
                },
              },
            },
          },
        },
        eslint = { settings = { workingDirectories = { mode = "auto" } } },
      })
      opts.mappings.n["<Leader>lf"] =
        { format_buffer, desc = "Форматирование и исправления ESLint" }
      opts.mappings.v["<Leader>lf"] = { format_selection, desc = "Форматировать выделение" }
      opts.mappings.x["<Leader>lf"] = { format_selection, desc = "Форматировать выделение" }
    end,
  },
  {
    "mason-org/mason-lspconfig.nvim",
    opts_extend = { "ensure_installed" },
    opts = { ensure_installed = { "intelephense", "vue_ls", "vtsls", "eslint" } },
  },
  {
    "WhoIsSethDaniel/mason-tool-installer.nvim",
    opts_extend = { "ensure_installed" },
    opts = {
      ensure_installed = {
        "intelephense",
        "vue-language-server",
        "vtsls",
        "eslint-lsp",
        "prettierd",
        "blade-formatter",
      },
    },
  },
  {
    "stevearc/conform.nvim",
    event = { "BufReadPre", "BufNewFile" },
    cmd = "ConformInfo",
    opts = {
      formatters_by_ft = formatters_by_ft,
      format_on_save = function(bufnr)
        if not formatters_by_ft[vim.bo[bufnr].filetype] or not require("astrolsp").autoformat_enabled(bufnr) then
          return
        end
        -- Один save-hook гарантирует порядок: ESLint, затем форматтер Conform.
        fix_eslint(bufnr)
        return { timeout_ms = 3000, lsp_format = "fallback" }
      end,
      formatters = {
        pint = {
          condition = function() return vim.fn.executable "php" == 1 end,
          cwd = function(_, ctx) return vim.fs.root(ctx.dirname, { "composer.json" }) end,
          require_cwd = true,
        },
        prettierd = {
          env = function()
            local runtime_dir = vim.env.XDG_RUNTIME_DIR
            if runtime_dir and vim.fn.filewritable(runtime_dir) == 2 then return {} end
            local fallback = vim.fn.stdpath "cache" .. "/prettierd"
            vim.fn.mkdir(fallback, "p", 448) -- 0700: Unix-сокет доступен только пользователю.
            vim.fn.setfperm(fallback, "rwx------")
            return { XDG_RUNTIME_DIR = fallback }
          end,
        },
      },
    },
  },
}
