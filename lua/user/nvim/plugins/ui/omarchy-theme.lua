--[[
=====================================================================
                    OMARCHY THEME INTEGRATION
=====================================================================
Интеграция с системой тем Omarchy.
Автоматически определяет окружение Omarchy и загружает тему оттуда.

В обычных окружениях (не Omarchy) этот модуль ничего не делает,
и используется стандартная тема из tokyonight.lua.

Как это работает в Omarchy:
  1. Omarchy создаёт симлинк ~/.config/omarchy/current/theme/neovim.lua
  2. Этот файл содержит спецификацию плагина темы
  3. При смене темы через omarchy-theme-set симлинк обновляется
  4. omarchy-theme-hotreload.lua отслеживает изменения и применяет новую тему
=====================================================================
--]]

-- Проверяем, находимся ли мы в окружении Omarchy
local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local is_omarchy = vim.fn.filereadable(omarchy_theme_file) == 1

if not is_omarchy then
  -- Не в Omarchy - возвращаем пустую таблицу
  -- Тема будет загружена из tokyonight.lua
  return {}
end

-- Мы в Omarchy - загружаем тему из симлинка
local ok, theme_spec = pcall(dofile, omarchy_theme_file)
if not ok or not theme_spec then
  vim.notify("Omarchy: не удалось загрузить тему из " .. omarchy_theme_file, vim.log.levels.WARN)
  return {}
end

-- Возвращаем спецификацию темы
return theme_spec
