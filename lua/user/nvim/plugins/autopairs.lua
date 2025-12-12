--[[
=====================================================================
                        NVIM-AUTOPAIRS
=====================================================================
Автоматическое закрытие скобок, кавычек и тегов.

При вводе:
  (  -> ()
  {  -> {}
  [  -> []
  "  -> ""
  '  -> ''
  `  -> ``

Умные функции:
  - Не добавлять если следующий символ буква
  - Авто-удаление парных символов
  - Перепрыгивание через закрывающий символ
  - Интеграция с treesitter

GitHub: https://github.com/windwp/nvim-autopairs
=====================================================================
--]]

return {
  "windwp/nvim-autopairs",
  enabled = false, -- Выключено - autopairs настроен в nvim-cmp.lua
  event = "InsertEnter",
  
  opts = {
    -- Проверять treesitter для более умного поведения
    check_ts = true,
    
    -- Правила для treesitter
    ts_config = {
      lua = { "string", "source" },
      javascript = { "string", "template_string" },
      typescript = { "string", "template_string" },
      javascriptreact = { "string", "template_string" },
      typescriptreact = { "string", "template_string" },
    },
    
    -- Отключить для определённых типов файлов
    disable_filetype = { "TelescopePrompt", "spectre_panel" },
    
    -- Отключить в комментариях и строках
    disable_in_macro = true,
    disable_in_visualblock = false,
    disable_in_replace_mode = true,
    
    -- Игнорировать следующие символы
    ignored_next_char = [=[[%w%%%'%[%"%.%`%$]]=],
    
    -- Быстрая перемотка
    fast_wrap = {
      map = "<M-e>", -- Alt+e для быстрой обёртки
      chars = { "{", "[", "(", '"', "'" },
      pattern = [=[[%'%"%>%]%)%}%,]]=],
      end_key = "$",
      keys = "qwertyuiopzxcvbnmasdfghjkl",
      check_comma = true,
      highlight = "Search",
      highlight_grey = "Comment",
    },
    
    -- Включить проверку на уже закрытые пары
    enable_check_bracket_line = true,
    
    -- Авто-добавление пробелов между скобками
    map_bs = true,
    map_c_h = false,
    map_c_w = false,
  },
  
  config = function(_, opts)
    local npairs = require("nvim-autopairs")
    npairs.setup(opts)
    
    -- Правила для конкретных языков
    local Rule = require("nvim-autopairs.rule")
    local cond = require("nvim-autopairs.conds")
    
    -- Добавить пробелы между скобками
    local brackets = { { "(", ")" }, { "[", "]" }, { "{", "}" } }
    npairs.add_rules({
      Rule(" ", " ")
        :with_pair(function(opt)
          local pair = opt.line:sub(opt.col - 1, opt.col)
          return vim.tbl_contains({
            brackets[1][1] .. brackets[1][2],
            brackets[2][1] .. brackets[2][2],
            brackets[3][1] .. brackets[3][2],
          }, pair)
        end)
        :with_move(cond.none())
        :with_cr(cond.none())
        :with_del(function(opt)
          local col = vim.api.nvim_win_get_cursor(0)[2]
          local context = opt.line:sub(col - 1, col + 2)
          return vim.tbl_contains({
            brackets[1][1] .. "  " .. brackets[1][2],
            brackets[2][1] .. "  " .. brackets[2][2],
            brackets[3][1] .. "  " .. brackets[3][2],
          }, context)
        end),
    })
    
    -- Стрелочные функции в JavaScript/TypeScript
    npairs.add_rules({
      Rule("%(.*%)%s*%=>$", " {  }", { "typescript", "typescriptreact", "javascript", "javascriptreact" })
        :use_regex(true)
        :set_end_pair_length(2),
    })
  end,
}
