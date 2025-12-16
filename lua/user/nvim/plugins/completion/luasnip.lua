--[[
=====================================================================
                          LUASNIP
=====================================================================
Мощный движок сниппетов для Neovim.

Использование:
  В Insert mode введите триггер сниппета и нажмите <Tab> для раскрытия.
  
Навигация:
  <Tab>       - следующая точка остановки
  <S-Tab>     - предыдущая точка остановки
  <C-l>       - выбор вариантов (choice node)

Примеры сниппетов (после установки friendly-snippets):
  JS/TS:
    clg     -> console.log()
    imp     -> import ... from '...'
    expf    -> export function
    af      -> arrow function
    
  React:
    rfc     -> React Functional Component
    uef     -> useEffect
    ust     -> useState
    
  HTML:
    !       -> HTML5 шаблон
    div.class -> <div class="class"></div>

GitHub: https://github.com/L3MON4D3/LuaSnip
=====================================================================
--]]

return {
  "L3MON4D3/LuaSnip",
  version = "v2.*",
  build = "make install_jsregexp",
  
  dependencies = {
    -- Готовые сниппеты для разных языков
    {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
  },
  
  opts = {
    -- История для перехода назад
    history = true,
    
    -- Обновлять при вводе
    update_events = "TextChanged,TextChangedI",
    
    -- Удалять сниппеты при выходе
    delete_check_events = "TextChanged",
    
    -- Включить autosnippets
    enable_autosnippets = true,
    
    -- Хранить последний сниппет
    store_selection_keys = "<Tab>",
    
    -- Расширенное поведение
    ext_opts = {
      [require("luasnip.util.types").choiceNode] = {
        active = {
          virt_text = { { "●", "DiagnosticInfo" } },
        },
      },
      [require("luasnip.util.types").insertNode] = {
        active = {
          virt_text = { { "●", "DiagnosticHint" } },
        },
      },
    },
  },
  
  config = function(_, opts)
    local ls = require("luasnip")
    ls.setup(opts)
    
    -- Загружаем сниппеты из разных источников
    require("luasnip.loaders.from_vscode").lazy_load()
    require("luasnip.loaders.from_lua").lazy_load()
    
    -- Загружаем пользовательские сниппеты если есть
    local snippets_path = vim.fn.stdpath("config") .. "/lua/user/nvim/snippets"
    if vim.fn.isdirectory(snippets_path) == 1 then
      require("luasnip.loaders.from_lua").lazy_load({ paths = { snippets_path } })
    end
    
    -- Команда для редактирования сниппетов
    vim.api.nvim_create_user_command("LuaSnipEdit", function()
      require("luasnip.loaders").edit_snippet_files()
    end, { desc = "Редактировать сниппеты" })
  end,
  
  keys = {
    {
      "<Tab>",
      function()
        local ls = require("luasnip")
        if ls.expand_or_jumpable() then
          ls.expand_or_jump()
        else
          -- Fallback к обычному табу
          vim.api.nvim_feedkeys(
            vim.api.nvim_replace_termcodes("<Tab>", true, false, true),
            "n",
            false
          )
        end
      end,
      mode = { "i", "s" },
      silent = true,
    },
    {
      "<S-Tab>",
      function()
        local ls = require("luasnip")
        if ls.jumpable(-1) then
          ls.jump(-1)
        end
      end,
      mode = { "i", "s" },
      silent = true,
    },
    {
      "<C-l>",
      function()
        local ls = require("luasnip")
        if ls.choice_active() then
          ls.change_choice(1)
        end
      end,
      mode = { "i", "s" },
      desc = "Следующий вариант сниппета",
    },
  },
}
