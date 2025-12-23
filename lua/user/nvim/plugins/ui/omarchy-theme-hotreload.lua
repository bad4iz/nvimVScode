--[[
=====================================================================
                    OMARCHY THEME HOT-RELOAD
=====================================================================
Плагин для горячей перезагрузки темы при смене через Omarchy.

Работает только в окружении Omarchy.
В обычных окружениях модуль ничего не делает.

Механизм работы:
  1. Слушает событие LazyReload
  2. При получении события выгружает текущую тему
  3. Загружает новую тему из обновлённого симлинка
  4. Применяет прозрачность (если включена)
=====================================================================
--]]

-- Проверяем, находимся ли мы в окружении Omarchy
local omarchy_theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")
local is_omarchy = vim.fn.filereadable(omarchy_theme_file) == 1

if not is_omarchy then
  -- Не в Omarchy - возвращаем пустую таблицу
  return {}
end

return {
  {
    name = "omarchy-theme-hotreload",
    dir = vim.fn.stdpath("config"),
    lazy = false,
    priority = 1000,
    config = function()
      local transparency_file = vim.fn.stdpath("config") .. "/plugin/after/transparency.lua"

      vim.api.nvim_create_autocmd("User", {
        pattern = "LazyReload",
        callback = function()
          -- Путь к файлу темы Omarchy
          local theme_file = vim.fn.expand("~/.config/omarchy/current/theme/neovim.lua")

          -- Проверяем что файл существует
          if vim.fn.filereadable(theme_file) ~= 1 then
            return
          end

          vim.schedule(function()
            -- Загружаем спецификацию темы напрямую из файла
            local ok, theme_spec = pcall(dofile, theme_file)
            if not ok or not theme_spec then
              return
            end

            -- Находим плагин темы и выгружаем его
            local theme_plugin_name = nil
            for _, spec in ipairs(theme_spec) do
              if spec[1] and spec[1] ~= "LazyVim/LazyVim" then
                theme_plugin_name = spec.name or spec[1]
                break
              end
            end

            -- Очищаем все highlight группы перед применением новой темы
            vim.cmd("highlight clear")
            if vim.fn.exists("syntax_on") then
              vim.cmd("syntax reset")
            end

            -- Сбрасываем background к dark (светлые темы установят свой)
            vim.o.background = "dark"

            -- Выгружаем модули плагина темы для полной перезагрузки
            if theme_plugin_name then
              local lazy_ok, lazy_config = pcall(require, "lazy.core.config")
              if lazy_ok and lazy_config.plugins[theme_plugin_name] then
                local plugin = lazy_config.plugins[theme_plugin_name]
                local plugin_dir = plugin.dir .. "/lua"
                local util_ok, lazy_util = pcall(require, "lazy.core.util")
                if util_ok then
                  lazy_util.walkmods(plugin_dir, function(modname)
                    package.loaded[modname] = nil
                    package.preload[modname] = nil
                  end)
                end
              end
            end

            -- Находим и применяем новую цветовую схему
            for _, spec in ipairs(theme_spec) do
              if spec[1] == "LazyVim/LazyVim" and spec.opts and spec.opts.colorscheme then
                local colorscheme = spec.opts.colorscheme

                -- Загружаем плагин цветовой схемы
                local loader_ok, loader = pcall(require, "lazy.core.loader")
                if loader_ok then
                  loader.colorscheme(colorscheme)
                end

                vim.defer_fn(function()
                  -- Применяем цветовую схему
                  pcall(vim.cmd.colorscheme, colorscheme)

                  -- Принудительная перерисовка
                  vim.cmd("redraw!")

                  -- Перезагружаем настройки прозрачности
                  if vim.fn.filereadable(transparency_file) == 1 then
                    vim.defer_fn(function()
                      vim.cmd.source(transparency_file)

                      -- Триггерим обновление UI для плагинов
                      vim.api.nvim_exec_autocmds("ColorScheme", { modeline = false })
                      vim.api.nvim_exec_autocmds("VimEnter", { modeline = false })

                      -- Финальная перерисовка
                      vim.cmd("redraw!")
                    end, 5)
                  end
                end, 5)

                break
              end
            end
          end)
        end,
      })
    end,
  },
}
