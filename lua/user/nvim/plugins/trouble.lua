--[[
=====================================================================
                          TROUBLE.NVIM
=====================================================================
Красивый список диагностики, ссылок, quickfix и т.д.

Горячие клавиши:
  <leader>xx  - переключить диагностику (workspace)
  <leader>xX  - диагностика буфера
  <leader>xL  - Location List
  <leader>xQ  - Quickfix List
  <leader>xs  - символы документа
  <leader>xS  - символы LSP (references, definitions и т.д.)

Навигация в Trouble:
  j/k         - вверх/вниз
  <CR>        - перейти к элементу
  o           - открыть и закрыть Trouble
  q           - закрыть Trouble
  r           - обновить
  ?           - справка

GitHub: https://github.com/folke/trouble.nvim
=====================================================================
--]]

return {
  "folke/trouble.nvim",
  cmd = { "Trouble" },
  
  opts = {
    -- Автоматически закрывать при переходе
    auto_close = false,
    
    -- Автоматически открывать превью
    auto_preview = true,
    
    -- Автоматически обновлять
    auto_refresh = true,
    
    -- Фокусироваться на окне при открытии
    focus = false,
    
    -- Следовать за курсором
    follow = true,
    
    -- Отступы
    indent_guides = true,
    
    -- Максимум элементов
    max_items = 200,
    
    -- Мульти-строчные элементы
    multiline = true,
    
    -- Закрепить размер окна
    pinned = false,
    
    -- Предупреждения о неустановленных плагинах
    warn_no_results = true,
    
    -- Режимы
    modes = {
      -- Диагностика всего проекта
      diagnostics = {
        mode = "diagnostics",
        preview = {
          type = "split",
          relative = "win",
          position = "right",
          size = 0.3,
        },
      },
      
      -- Символы документа
      symbols = {
        mode = "lsp_document_symbols",
        focus = false,
        win = { position = "right" },
        filter = {
          -- Исключить определённые типы символов
          ["not"] = { ft = "lua", kind = "Package" },
          any = {
            ft = { "help", "markdown" },
            kind = {
              "Class",
              "Constructor",
              "Enum",
              "Field",
              "Function",
              "Interface",
              "Method",
              "Module",
              "Namespace",
              "Package",
              "Property",
              "Struct",
              "Trait",
            },
          },
        },
      },
    },
    
    -- Иконки
    icons = {
      indent = {
        top = "│ ",
        middle = "├╴",
        last = "└╴",
        fold_open = " ",
        fold_closed = " ",
        ws = "  ",
      },
      folder_closed = " ",
      folder_open = " ",
      kinds = {
        Array = " ",
        Boolean = "󰨙 ",
        Class = " ",
        Constant = "󰏿 ",
        Constructor = " ",
        Enum = " ",
        EnumMember = " ",
        Event = " ",
        Field = " ",
        File = " ",
        Function = "󰊕 ",
        Interface = " ",
        Key = " ",
        Method = "󰊕 ",
        Module = " ",
        Namespace = "󰦮 ",
        Null = " ",
        Number = "󰎠 ",
        Object = " ",
        Operator = " ",
        Package = " ",
        Property = " ",
        String = " ",
        Struct = "󰆼 ",
        TypeParameter = " ",
        Variable = "󰀫 ",
      },
    },
  },
  
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Диагностика (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Диагностика буфера" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Символы (Trouble)" },
    { 
      "<leader>xS", 
      "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", 
      desc = "LSP ссылки (Trouble)" 
    },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
    {
      "[q",
      function()
        if require("trouble").is_open() then
          require("trouble").prev({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cprev)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Предыдущий элемент trouble/quickfix",
    },
    {
      "]q",
      function()
        if require("trouble").is_open() then
          require("trouble").next({ skip_groups = true, jump = true })
        else
          local ok, err = pcall(vim.cmd.cnext)
          if not ok then
            vim.notify(err, vim.log.levels.ERROR)
          end
        end
      end,
      desc = "Следующий элемент trouble/quickfix",
    },
  },
}
