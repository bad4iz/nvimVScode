--[[
=====================================================================
                    OMARCHY ALL THEMES
=====================================================================
Предзагрузка всех тем для горячей перезагрузки в Omarchy.

Работает только в окружении Omarchy.
В обычных окружениях модуль ничего не делает.

Это нужно чтобы при смене темы через omarchy-theme-set
все цветовые схемы были уже доступны для мгновенного переключения.
=====================================================================
--]]

-- Проверяем, находимся ли мы в окружении Omarchy
local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local is_omarchy = vim.fn.filereadable(omarchy_theme_file) == 1

if not is_omarchy then
  -- Не в Omarchy - возвращаем пустую таблицу
  return {}
end

-- Предзагружаем все темы которые используются в Omarchy
return {
  {
    "ribru17/bamboo.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/aether.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/ethereal.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "bjarneo/hackerman.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "catppuccin/nvim",
    name = "catppuccin",
    lazy = true,
    priority = 1000,
  },
  {
    "sainnhe/everforest",
    lazy = true,
    priority = 1000,
  },
  {
    "kepano/flexoki-neovim",
    lazy = true,
    priority = 1000,
  },
  {
    "ellisonleao/gruvbox.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rebelot/kanagawa.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "tahayvr/matteblack.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "loctvl842/monokai-pro.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "shaunsingh/nord.nvim",
    lazy = true,
    priority = 1000,
  },
  {
    "rose-pine/neovim",
    name = "rose-pine",
    lazy = true,
    priority = 1000,
  },
  -- tokyonight уже загружается в tokyonight.lua
}
