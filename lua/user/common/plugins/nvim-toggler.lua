--[[
=====================================================================
                        NVIM-TOGGLER
=====================================================================
Плагин для быстрого переключения значений под курсором.

Как использовать:
  <leader>i  - переключить значение под курсором
  
Примеры переключений:
  true  <-> false
  yes   <-> no
  on    <-> off
  +     <-> -
  ==    <-> !=
  &&    <-> ||
  and   <-> or
  вкл   <-> выкл
  
GitHub: https://github.com/nguyenvukhang/nvim-toggler
=====================================================================
--]]

return {
  "nguyenvukhang/nvim-toggler",
  event = { "BufReadPost", "BufNewFile" }, -- Загружать при открытии файла
  
  opts = {
    -- Удалить стандартные сочетания (мы зададим свои)
    remove_default_keybinds = true,
    
    -- Пары для переключения
    inverses = {
      -- Булевы значения
      ["true"] = "false",
      ["True"] = "False",
      ["TRUE"] = "FALSE",
      
      -- Да/Нет
      ["yes"] = "no",
      ["Yes"] = "No",
      ["YES"] = "NO",
      
      -- Вкл/Выкл
      ["on"] = "off",
      ["On"] = "Off",
      ["ON"] = "OFF",
      
      -- На русском языке
      ["вкл"] = "выкл",
      ["Вкл"] = "Выкл",
      ["ВКЛ"] = "ВЫКЛ",
      ["да"] = "нет",
      ["Да"] = "Нет",
      ["ДА"] = "НЕТ",
      ["истина"] = "ложь",
      ["Истина"] = "Ложь",
      
      -- Математические операторы
      ["+"] = "-",
      ["*"] = "/",
      
      -- Операторы сравнения
      ["=="] = "!=",
      ["==="] = "!==",
      ["<"] = ">",
      ["<="] = ">=",
      
      -- Логические операторы
      ["&&"] = "||",
      ["and"] = "or",
      ["AND"] = "OR",
      ["And"] = "Or",
      
      -- CSS/HTML
      ["left"] = "right",
      ["Left"] = "Right",
      ["top"] = "bottom",
      ["Top"] = "Bottom",
      ["width"] = "height",
      ["Width"] = "Height",
      ["min"] = "max",
      ["Min"] = "Max",
      ["MIN"] = "MAX",
      
      -- Flexbox
      ["row"] = "column",
      ["flex-start"] = "flex-end",
      ["start"] = "end",
      
      -- JavaScript/TypeScript
      ["const"] = "let",
      ["public"] = "private",
      ["import"] = "export",
      
      -- Git
      ["add"] = "remove",
      ["push"] = "pull",
      
      -- Разное
      ["enable"] = "disable",
      ["enabled"] = "disabled",
      ["show"] = "hide",
      ["visible"] = "hidden",
      ["open"] = "close",
      ["success"] = "error",
      ["first"] = "last",
      ["before"] = "after",
      ["prev"] = "next",
      ["above"] = "below",
    },
    
    -- Использовать только заданные пары (не пытаться автоматически определять)
    remove_default_inverses = true,
  },
  
  config = function(_, opts)
    require("nvim-toggler").setup(opts)
    
    -- Назначаем сочетание клавиш
    vim.keymap.set({ "n", "v" }, "<leader>i", function()
      require("nvim-toggler").toggle()
    end, { desc = "Переключить значение" })
  end,
}
