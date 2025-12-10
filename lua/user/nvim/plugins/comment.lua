--[[
=====================================================================
                          COMMENT.NVIM
=====================================================================
Умное комментирование кода с поддержкой treesitter.

Горячие клавиши:
  gcc         - закомментировать/раскомментировать строку
  gc{motion}  - закомментировать по motion (например: gcap - параграф)
  gbc         - блочный комментарий строки
  gb{motion}  - блочный комментарий по motion
  
В визуальном режиме:
  gc          - закомментировать выделение
  gb          - блочный комментарий выделения

Примеры:
  gcc     - // строка
  gcip    - закомментировать параграф
  gc5j    - закомментировать 5 строк вниз
  gco     - добавить комментарий на следующей строке
  gcO     - добавить комментарий на предыдущей строке
  gcA     - добавить комментарий в конец строки

GitHub: https://github.com/numToStr/Comment.nvim
=====================================================================
--]]

return {
  "numToStr/Comment.nvim",
  event = { "BufReadPost", "BufNewFile" },
  
  dependencies = {
    -- Для определения типа комментария в смешанных файлах (JSX, Vue и т.д.)
    {
      "JoosepAlviste/nvim-ts-context-commentstring",
      lazy = true,
      opts = {
        enable_autocmd = false,
      },
    },
  },
  
  opts = function()
    return {
      -- Добавить пробел после комментария
      padding = true,
      
      -- Прилипать к отступу
      sticky = true,
      
      -- Игнорировать пустые строки
      ignore = "^$",
      
      -- Маппинги
      toggler = {
        line = "gcc",  -- Строчный комментарий
        block = "gbc", -- Блочный комментарий
      },
      
      opleader = {
        line = "gc",   -- Строчный для motion
        block = "gb",  -- Блочный для motion
      },
      
      extra = {
        above = "gcO", -- Добавить комментарий сверху
        below = "gco", -- Добавить комментарий снизу
        eol = "gcA",   -- Добавить комментарий в конец
      },
      
      -- Включить основные маппинги
      mappings = {
        basic = true,
        extra = true,
      },
      
      -- Интеграция с ts-context-commentstring
      pre_hook = function(ctx)
        local U = require("Comment.utils")
        
        -- Определяем, нужно ли использовать treesitter
        local location = nil
        if ctx.ctype == U.ctype.blockwise then
          location = require("ts_context_commentstring.utils").get_cursor_location()
        elseif ctx.cmotion == U.cmotion.v or ctx.cmotion == U.cmotion.V then
          location = require("ts_context_commentstring.utils").get_visual_start_location()
        end
        
        return require("ts_context_commentstring.internal").calculate_commentstring({
          key = ctx.ctype == U.ctype.linewise and "__default" or "__multiline",
          location = location,
        })
      end,
    }
  end,
}
