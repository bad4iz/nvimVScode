--[[
=====================================================================
                         БЫСТРЫЙ ДЕБАГ (DEBUG)
=====================================================================
Инструменты для быстрой вставки логов в код.
В основном предназначены для JavaScript/TypeScript (console.log).

Горячие клавиши:
  <leader>Ll  - Вставить лог переменной под курсором на следующей строке
  <leader>Lp  - Вставить лог содержимого буфера обмена (paste)
  <leader>LL  - Вставить лог-метку "here" на следующей строке
  <leader>Lv  - (Visual mode) Вставить лог для выделенного фрагмента
  <leader>Ld  - Удалить ВСЕ строки, содержащие "console.log" в текущем файле

Преимущества:
  - Автоматически определяет отступ текущей строки
  - Добавляет иконку 󰆦 для удобного поиска в консоли браузера
  - Сохраняет историю регистров при визуальном выделении
  - Работает мгновенно без внешних зависимостей
=====================================================================
--]]

return {
  {
    "none", -- фиктивное имя для lazy.nvim
    virtual = true,
    lazy = false,
    keys = {
      {
        "<leader>Ll",
        function()
          local line = vim.api.nvim_get_current_line()
          local word = vim.fn.expand("<cword>")
          local log_statement = string.format('console.log("󰆦 %s:", %s);', word, word)
          local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_lines(0, row, row, false, {
            line:match("^%s*") .. log_statement,
          })
        end,
        desc = "Лог переменной",
      },
      {
        "<leader>Lp",
        function()
          local line = vim.api.nvim_get_current_line()
          local word = vim.fn.getreg('"'):gsub("\n", ""):gsub("^%s*", ""):gsub("%s*$", "")
          local log_statement = string.format('console.log("󰆦 %s:", %s);', word, word)
          local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_lines(0, row, row, false, {
            line:match("^%s*") .. log_statement,
          })
        end,
        desc = "Лог из буфера",
      },
      {
        "<leader>LL",
        function()
          local log_statement = 'console.log("󰆦 here");'
          local line = vim.api.nvim_get_current_line()
          local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_lines(0, row, row, false, {
            line:match("^%s*") .. log_statement,
          })
        end,
        desc = "Лог здесь",
      },
      {
        "<leader>Lv",
        function()
          local old_reg = vim.fn.getreg("v")
          vim.cmd('normal! "vy')
          local word = vim.fn.getreg("v")
          vim.fn.setreg("v", old_reg)

          local line = vim.api.nvim_get_current_line()
          local log_statement = string.format('console.log("󰆦 %s:", %s);', word, word)
          local row, _ = unpack(vim.api.nvim_win_get_cursor(0))
          vim.api.nvim_buf_set_lines(0, row, row, false, {
            line:match("^%s*") .. log_statement,
          })
        end,
        mode = "v",
        desc = "Лог выделения",
      },
      {
        "<leader>Ld",
        function()
          local save_cursor = vim.fn.getpos(".")
          vim.cmd("silent! g/console.log/d")
          vim.fn.setpos(".", save_cursor)
        end,
        desc = "Удалить все логи",
      },
    },
  },
}
