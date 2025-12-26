--[[
=====================================================================
                          NVIM-DAP
=====================================================================
Debug Adapter Protocol для Neovim.
Поддержка отладки для различных языков программирования.

Горячие клавиши (AstroNvim style):
  <leader>dc  или F5      - Продолжить / Запустить
  <leader>dp  или F6      - Пауза
  <leader>dr  или Ctrl+F5 - Перезапустить
  <leader>ds             - Запустить до курсора
  <leader>dq             - Закрыть сессию
  <leader>dQ  или Shift+F5 - Остановить
  <leader>db  или F9      - Переключить breakpoint
  <leader>dC  или Shift+F9 - Условный breakpoint
  <leader>dB             - Очистить все breakpoints
  <leader>do  или F10     - Step over
  <leader>di  или F11     - Step into
  <leader>dO  или Shift+F11 - Step out
  <leader>dE             - Evaluate выражение
  <leader>dR             - Toggle REPL
  <leader>du             - Toggle UI
  <leader>dh             - Hover переменной

GitHub: https://github.com/mfussenegger/nvim-dap
=====================================================================
--]]

return {
  "mfussenegger/nvim-dap",

  dependencies = {
    -- UI для dap с красивым интерфейсом
    {
      "rcarriga/nvim-dap-ui",
      dependencies = {
        "nvim-neotest/nvim-nio",
      },
    },

    -- Virtual text для показа значений переменных
    {
      "theHamsta/nvim-dap-virtual-text",
      opts = {},
    },
  },

  -- Lazy load при использовании debugger команд
  keys = {
    -- =====================================================================
    -- ЗАПУСК И УПРАВЛЕНИЕ СЕССИЕЙ (AstroNvim style)
    -- =====================================================================
    {
      "<leader>dc",
      function() require("dap").continue() end,
      desc = "Debugger: Continue"
    },
    {
      "<F5>",
      function() require("dap").continue() end,
      desc = "Debugger: Continue"
    },

    {
      "<leader>dp",
      function() require("dap").pause() end,
      desc = "Debugger: Pause"
    },
    {
      "<F6>",
      function() require("dap").pause() end,
      desc = "Debugger: Pause"
    },

    {
      "<leader>dr",
      function() require("dap").restart() end,
      desc = "Debugger: Restart"
    },
    {
      "<C-F5>",
      function() require("dap").restart() end,
      desc = "Debugger: Restart"
    },

    {
      "<leader>ds",
      function() require("dap").run_to_cursor() end,
      desc = "Debugger: Run to Cursor"
    },

    {
      "<leader>dq",
      function() require("dap").close() end,
      desc = "Debugger: Close Session"
    },

    {
      "<leader>dQ",
      function() require("dap").terminate() end,
      desc = "Debugger: Terminate"
    },
    {
      "<S-F5>",
      function() require("dap").terminate() end,
      desc = "Debugger: Terminate"
    },

    -- =====================================================================
    -- BREAKPOINTS (AstroNvim style)
    -- =====================================================================
    {
      "<leader>db",
      function() require("dap").toggle_breakpoint() end,
      desc = "Debugger: Toggle Breakpoint"
    },
    {
      "<F9>",
      function() require("dap").toggle_breakpoint() end,
      desc = "Debugger: Toggle Breakpoint"
    },

    {
      "<leader>dC",
      function()
        local condition = vim.fn.input("Breakpoint condition: ")
        require("dap").set_breakpoint(condition)
      end,
      desc = "Debugger: Conditional Breakpoint"
    },
    {
      "<S-F9>",
      function()
        local condition = vim.fn.input("Breakpoint condition: ")
        require("dap").set_breakpoint(condition)
      end,
      desc = "Debugger: Conditional Breakpoint"
    },

    {
      "<leader>dB",
      function() require("dap").clear_breakpoints() end,
      desc = "Debugger: Clear Breakpoints"
    },

    -- =====================================================================
    -- STEPPING (AstroNvim style)
    -- =====================================================================
    {
      "<leader>do",
      function() require("dap").step_over() end,
      desc = "Debugger: Step Over"
    },
    {
      "<F10>",
      function() require("dap").step_over() end,
      desc = "Debugger: Step Over"
    },

    {
      "<leader>di",
      function() require("dap").step_into() end,
      desc = "Debugger: Step Into"
    },
    {
      "<F11>",
      function() require("dap").step_into() end,
      desc = "Debugger: Step Into"
    },

    {
      "<leader>dO",
      function() require("dap").step_out() end,
      desc = "Debugger: Step Out"
    },
    {
      "<S-F11>",
      function() require("dap").step_out() end,
      desc = "Debugger: Step Out"
    },

    -- =====================================================================
    -- EVALUATION И UI (AstroNvim style)
    -- =====================================================================
    {
      "<leader>dE",
      function()
        local expr = vim.fn.input("Expression: ")
        if expr ~= "" then
          require("dap.ui.widgets").hover(expr)
        end
      end,
      desc = "Debugger: Evaluate"
    },

    {
      "<leader>dh",
      function()
        require("dap.ui.widgets").hover()
      end,
      desc = "Debugger: Hover",
      mode = { "n", "v" }
    },

    {
      "<leader>dR",
      function() require("dap").repl.toggle() end,
      desc = "Debugger: Toggle REPL"
    },

    {
      "<leader>du",
      function() require("dapui").toggle() end,
      desc = "Debugger: Toggle UI"
    },
  },

  config = function()
    local dap = require("dap")
    local dapui = require("dapui")

    -- =====================================================================
    -- НАСТРОЙКА DAPUI
    -- =====================================================================
    dapui.setup({
      icons = { expanded = "", collapsed = "", current_frame = "" },
      layouts = {
        {
          elements = {
            { id = "scopes", size = 0.33 },
            { id = "breakpoints", size = 0.17 },
            { id = "stacks", size = 0.25 },
            { id = "watches", size = 0.25 },
          },
          size = 0.33,
          position = "right",
        },
        {
          elements = {
            { id = "repl", size = 0.45 },
            { id = "console", size = 0.55 },
          },
          size = 0.27,
          position = "bottom",
        },
      },
      floating = {
        max_height = 0.9,
        max_width = 0.5,
        border = "rounded",
        mappings = {
          close = { "q", "<Esc>" },
        },
      },
    })

    -- =====================================================================
    -- АВТОМАТИЧЕСКОЕ ОТКРЫТИЕ/ЗАКРЫТИЕ UI
    -- =====================================================================
    dap.listeners.after.event_initialized["dapui_config"] = function()
      dapui.open()
    end

    dap.listeners.before.event_terminated["dapui_config"] = function()
      dapui.close()
    end

    dap.listeners.before.event_exited["dapui_config"] = function()
      dapui.close()
    end

    -- =====================================================================
    -- ЗНАКИ ДЛЯ BREAKPOINTS
    -- =====================================================================
    vim.fn.sign_define("DapBreakpoint", {
      text = "",
      texthl = "DiagnosticError",
      linehl = "",
      numhl = ""
    })

    vim.fn.sign_define("DapBreakpointCondition", {
      text = "",
      texthl = "DiagnosticWarn",
      linehl = "",
      numhl = ""
    })

    vim.fn.sign_define("DapBreakpointRejected", {
      text = "",
      texthl = "DiagnosticHint",
      linehl = "",
      numhl = ""
    })

    vim.fn.sign_define("DapStopped", {
      text = "",
      texthl = "DiagnosticInfo",
      linehl = "DapStoppedLine",
      numhl = ""
    })

    vim.fn.sign_define("DapLogPoint", {
      text = "",
      texthl = "DiagnosticInfo",
      linehl = "",
      numhl = ""
    })

    -- =====================================================================
    -- БАЗОВЫЕ КОНФИГУРАЦИИ АДАПТЕРОВ
    -- =====================================================================

    -- Node.js / JavaScript / TypeScript (через vscode-js-debug)
    -- Установка: npm install -g vscode-js-debug
    dap.adapters["pwa-node"] = {
      type = "server",
      host = "localhost",
      port = "${port}",
      executable = {
        command = "node",
        args = {
          vim.fn.stdpath("data") .. "/mason/packages/js-debug-adapter/js-debug/src/dapDebugServer.js",
          "${port}"
        },
      }
    }

    -- Python (через debugpy)
    -- Установка: pip install debugpy
    dap.adapters.python = {
      type = "executable",
      command = "python",
      args = { "-m", "debugpy.adapter" },
    }

    -- КОНФИГУРАЦИИ ДЛЯ ЯЗЫКОВ

    -- JavaScript / TypeScript
    dap.configurations.javascript = {
      {
        type = "pwa-node",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        cwd = "${workspaceFolder}",
      },
    }

    dap.configurations.typescript = dap.configurations.javascript

    -- Python
    dap.configurations.python = {
      {
        type = "python",
        request = "launch",
        name = "Launch file",
        program = "${file}",
        pythonPath = function()
          return "python"
        end,
      },
    }
  end,
}
