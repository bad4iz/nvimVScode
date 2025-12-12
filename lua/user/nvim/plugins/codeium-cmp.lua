--[[
=====================================================================
                        CODEIUM AI
=====================================================================
AI помощник для автодополнения кода.

GitHub: https://github.com/Exafunction/codeium.nvim
=====================================================================
--]]

return {
  "Exafunction/codeium.nvim",
  enabled = false, -- Выключено - codeium настроен в nvim-cmp.lua
  event = "InsertEnter",
  dependencies = {
    "nvim-lua/plenary.nvim",
  },
  opts = {
    enable_cmp_source = true,  -- Включить как источник для blink.cmp
    virtual_text = {
      enabled = false,         -- Отключить inline подсказки
    },
  },
}
