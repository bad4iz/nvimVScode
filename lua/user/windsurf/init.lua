require 'user.windsurf.settings'

-- Загрузка плагинов
require('lazy').setup('user.windsurf.plugins', {
  defaults = { lazy = true },
  install = { colorscheme = { 'tokyonight' } },
  ui = {
    border = 'rounded',
  },
  change_detection = {
    notify = false
  },
  performance = {
    rtp = {
      disabled_plugins = {
        'gzip',
        'matchit',
        'matchparen',
        'netrwPlugin',
        'tarPlugin',
        'tohtml',
        'tutor',
        'zipPlugin',
      },
    },
  },
})

require 'user.windsurf.keymaps'


print("Конфигурация Windsurf загружена!")
