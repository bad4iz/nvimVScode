local plugins = {}

-- Импортируем все файлы плагинов из текущей директории
local function import_plugins()
  local files = vim.fn.globpath(vim.fn.stdpath('config') .. '/lua/plugins', '*.lua', false, true)
  
  for _, file in ipairs(files) do
    -- Пропускаем сам init.lua
    if not file:match('init%.lua$') then
      -- Получаем имя модуля (без расширения .lua)
      local module_name = file:match('.*/([^/]+)%.lua$')
      if module_name then
        local ok, plugin = pcall(require, 'plugins.' .. module_name)
        if ok and type(plugin) == 'table' then
          vim.list_extend(plugins, plugin)
        end
      end
    end
  end
end

-- Импортируем плагины
import_plugins()

return plugins
