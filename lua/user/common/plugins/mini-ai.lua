--[[
=====================================================================
                          MINI.AI
=====================================================================
Расширенные текстовые объекты для Vim.

Добавляет новые текстовые объекты для операторов (d, c, y, v и др.):
  a/i + объект - around/inner (вокруг/внутри)

Встроенные объекты:
  q  - кавычки (любые: ', ", `)
  b  - скобки (любые: (), [], {})
  t  - HTML/XML теги
  f  - вызов функции
  a  - аргумент функции (между запятыми)

Примеры использования:
  diq  - удалить внутри кавычек
  ciq  - изменить внутри кавычек
  vaq  - выделить с кавычками
  daf  - удалить вызов функции целиком
  cia  - изменить аргумент
  
GitHub: https://github.com/echasnovski/mini.ai
=====================================================================
--]]

return {
  "echasnovski/mini.ai",
  version = "*", -- Стабильная версия
  event = "VeryLazy",
  
  opts = {
    -- Количество строк для поиска
    n_lines = 500,
    
    -- Пользовательские текстовые объекты
    custom_textobjects = {
      -- Весь буфер
      g = function()
        local from = { line = 1, col = 1 }
        local to = {
          line = vim.fn.line("$"),
          col = math.max(vim.fn.getline("$"):len(), 1),
        }
        return { from = from, to = to }
      end,
      
      -- Код в markdown (```)
      o = require("mini.ai").gen_spec.treesitter({
        a = { "@block.outer", "@conditional.outer", "@loop.outer" },
        i = { "@block.inner", "@conditional.inner", "@loop.inner" },
      }, {}),
      
      -- Функция
      f = require("mini.ai").gen_spec.treesitter({ 
        a = "@function.outer", 
        i = "@function.inner" 
      }, {}),
      
      -- Класс
      c = require("mini.ai").gen_spec.treesitter({ 
        a = "@class.outer", 
        i = "@class.inner" 
      }, {}),
      
      -- Комментарий
      u = require("mini.ai").gen_spec.treesitter({ 
        a = "@comment.outer", 
        i = "@comment.inner" 
      }, {}),
    },
    
    -- Маппинги для перехода
    mappings = {
      around = "a",
      inside = "i",
      -- Переход к следующему/предыдущему текстовому объекту
      around_next = "an",
      inside_next = "in",
      around_last = "al",
      inside_last = "il",
      -- Переход к границам текстового объекта
      goto_left = "g[",
      goto_right = "g]",
    },
    
    -- Показывать подсказки после задержки
    search_method = "cover_or_next",
    
    -- Молчаливый режим (не показывать ошибки)
    silent = false,
  },
  
  config = function(_, opts)
    require("mini.ai").setup(opts)
  end,
}
