--[[
=====================================================================
                    SPELL CHECKING - ПРОВЕРКА ОРФОГРАФИИ
=====================================================================

Проверка орфографии для русского и английского языков.

=====================================================================
                        ГОРЯЧИЕ КЛАВИШИ
=====================================================================

ОСНОВНЫЕ:
  <leader>us    - Включить/выключить проверку орфографии
  <leader>ul    - Переключить язык (en,ru → en → ru → en,ru)
                  По умолчанию: оба языка одновременно (en,ru)

В РЕЖИМЕ С ВКЛЮЧЕННЫМ SPELL:
  ]s            - Следующая ошибка
  [s            - Предыдущая ошибка
  z=            - Показать варианты исправления
  zg            - Добавить слово в словарь (good word)
  zw            - Пометить слово как неправильное (wrong word)
  zug           - Убрать слово из словаря (undo good)
  zuw           - Убрать пометку "неправильное" (undo wrong)

АВТОМАТИЧЕСКИ ВКЛЮЧАЕТСЯ ДЛЯ:
  - Git commit сообщений
  - (можно добавить другие типы файлов ниже)

КОМАНДЫ:
  :SpellInstall       - Установить все словари (en + ru)
  :SpellInstall ru    - Установить только русский
  :SpellInstall en    - Установить только английский
  :SpellInfo          - Показать информацию и статус словарей

СЛОВАРИ ХРАНЯТСЯ:
  Системные:  ~/.local/share/nvim/site/spell/
  Личные:     ~/.config/nvim/spell/en.utf-8.add
              ~/.config/nvim/spell/ru.utf-8.add

ПЕРВАЯ УСТАНОВКА:
  1. Запустите Neovim
  2. Выполните :SpellInstall
  3. Перезапустите Neovim
  4. Готово! Используйте <leader>us для включения

=====================================================================
--]]

return {
  {
    -- Используем lazy.nvim для создания "виртуального" плагина
    dir = vim.fn.stdpath("config"),
    name = "spell-config",
    lazy = false,
    priority = 100,

    config = function()
      -- ═══════════════════════════════════════════════════════════
      -- СОЗДАНИЕ ДИРЕКТОРИЙ
      -- ═══════════════════════════════════════════════════════════

      -- Директория для пользовательских словарей
      local spell_dir = vim.fn.stdpath("config") .. "/spell"
      if vim.fn.isdirectory(spell_dir) == 0 then
        vim.fn.mkdir(spell_dir, "p")
      end

      -- Создать пустые файлы для пользовательских слов
      local user_dicts = {
        spell_dir .. "/en.utf-8.add",
        spell_dir .. "/ru.utf-8.add",
      }
      for _, dict_file in ipairs(user_dicts) do
        if vim.fn.filereadable(dict_file) == 0 then
          vim.fn.writefile({}, dict_file)
        end
      end

      -- Директория для системных словарей
      local spell_system_dir = vim.fn.stdpath("data") .. "/site/spell"
      if vim.fn.isdirectory(spell_system_dir) == 0 then
        vim.fn.mkdir(spell_system_dir, "p")
      end

      -- ═══════════════════════════════════════════════════════════
      -- ФУНКЦИЯ СКАЧИВАНИЯ СЛОВАРЯ
      -- ═══════════════════════════════════════════════════════════

      local function download_spell_file(lang)
        vim.notify("Скачивание словаря для языка: " .. lang, vim.log.levels.INFO)

        local url_base = "https://ftp.nluug.nl/pub/vim/runtime/spell/"
        local files = {
          lang .. ".utf-8.spl",
          lang .. ".utf-8.sug",
        }

        for _, file in ipairs(files) do
          local url = url_base .. file
          local target = spell_system_dir .. "/" .. file
          local curl_cmd = string.format('curl -fLo "%s" --create-dirs "%s"', target, url)

          vim.notify("Скачивание: " .. file .. "...", vim.log.levels.INFO)
          local output = vim.fn.system(curl_cmd)

          if vim.v.shell_error == 0 then
            vim.notify("✓ Скачан: " .. file, vim.log.levels.INFO)
          else
            vim.notify("✗ Ошибка при скачивании: " .. file .. "\n" .. output, vim.log.levels.ERROR)
          end
        end
      end

      -- ═══════════════════════════════════════════════════════════
      -- НАСТРОЙКИ ПО УМОЛЧАНИЮ
      -- ═══════════════════════════════════════════════════════════

      -- Включить spell checking по умолчанию
      vim.opt.spell = true
      vim.opt.spelllang = { "en", "ru" }

      -- Указать файлы для пользовательских слов
      vim.opt.spellfile = {
        spell_dir .. "/en.utf-8.add",
        spell_dir .. "/ru.utf-8.add",
      }

      -- ═══════════════════════════════════════════════════════════
      -- ГОРЯЧИЕ КЛАВИШИ
      -- ═══════════════════════════════════════════════════════════

      -- Переключение языка
      vim.keymap.set("n", "<leader>ul", function()
        local current = vim.opt.spelllang:get()
        local lang_cycle = {
          ["en,ru"] = { "en", "🇬🇧 Только английский" },
          ["en"] = { "ru", "🇷🇺 Только русский" },
          ["ru"] = { "en,ru", "🌍 Английский + Русский" },
        }

        local current_key = table.concat(current, ",")
        local next_lang = lang_cycle[current_key] or { "en,ru", "🌍 Английский + Русский" }

        vim.opt.spelllang = vim.split(next_lang[1], ",")
        vim.notify("Язык проверки: " .. next_lang[2], vim.log.levels.INFO)
      end, { desc = "Переключить язык spell" })

      -- Навигация по ошибкам
      vim.keymap.set("n", "<leader>sn", "]s", { desc = "Следующая ошибка spell" })
      vim.keymap.set("n", "<leader>sp", "[s", { desc = "Предыдущая ошибка spell" })

      -- Исправление
      vim.keymap.set("n", "<leader>sf", "z=", { desc = "Исправить слово (spell)" })

      -- Добавление в словарь
      vim.keymap.set("n", "<leader>sa", "zg", { desc = "Добавить в словарь (spell)" })
      vim.keymap.set("n", "<leader>sw", "zw", { desc = "Пометить как неправильное (spell)" })

      -- ═══════════════════════════════════════════════════════════
      -- АВТОКОМАНДЫ
      -- ═══════════════════════════════════════════════════════════

      local spell_group = vim.api.nvim_create_augroup("spell_settings", { clear = true })

      -- Git commit - автоматически включаем spell
      vim.api.nvim_create_autocmd("FileType", {
        group = spell_group,
        pattern = { "gitcommit", "gitrebase" },
        callback = function()
          vim.opt_local.spell = true
        end,
        desc = "Включить spell для Git commit",
      })

      -- Проверка наличия словарей при старте
      vim.api.nvim_create_autocmd("VimEnter", {
        group = spell_group,
        once = true,
        callback = function()
          local spell_files = {
            { path = spell_system_dir .. "/en.utf-8.spl", lang = "en" },
            { path = spell_system_dir .. "/ru.utf-8.spl", lang = "ru" },
          }

          local missing = {}
          for _, file in ipairs(spell_files) do
            if vim.fn.filereadable(file.path) == 0 then
              table.insert(missing, file.lang)
            end
          end

          if #missing > 0 then
            vim.notify(
              "⚠ Словари не найдены: " .. table.concat(missing, ", ") .. "\n" ..
              "Используйте :SpellInstall для установки",
              vim.log.levels.WARN,
              { title = "Spell Checking" }
            )
          end
        end,
        desc = "Проверить наличие словарей spell",
      })

      -- ═══════════════════════════════════════════════════════════
      -- КОМАНДЫ
      -- ═══════════════════════════════════════════════════════════

      -- Команда для добавления слова
      vim.api.nvim_create_user_command("SpellAdd", function(opts)
        local word = opts.args ~= "" and opts.args or vim.fn.expand("<cword>")
        vim.cmd("normal! zg")
        vim.notify("Добавлено в словарь: " .. word, vim.log.levels.INFO)
      end, {
        nargs = "?",
        desc = "Добавить слово в словарь",
      })

      -- Команда для установки словарей
      vim.api.nvim_create_user_command("SpellInstall", function(opts)
        local lang = opts.args ~= "" and opts.args or "all"

        if lang == "all" then
          vim.notify("📥 Установка словарей для русского и английского языков...", vim.log.levels.INFO)
          download_spell_file("en")
          download_spell_file("ru")
          vim.notify("✓ Установка завершена! Перезапустите Neovim.", vim.log.levels.INFO)
        else
          download_spell_file(lang)
          vim.notify("✓ Словарь установлен для: " .. lang, vim.log.levels.INFO)
        end
      end, {
        nargs = "?",
        desc = "Установить словари spell (all, en, ru)",
      })

      -- Команда для информации
      vim.api.nvim_create_user_command("SpellInfo", function()
        local enabled = vim.wo.spell
        local lang = table.concat(vim.opt.spelllang:get(), ", ")

        local en_exists = vim.fn.filereadable(spell_system_dir .. "/en.utf-8.spl") == 1
        local ru_exists = vim.fn.filereadable(spell_system_dir .. "/ru.utf-8.spl") == 1

        local info = {
          "=== Spell Checking Info ===",
          "",
          "Статус: " .. (enabled and "✓ Включен" or "✗ Отключен"),
          "Язык: " .. lang,
          "",
          "Установленные словари:",
          "  Английский: " .. (en_exists and "✓" or "✗ НЕ УСТАНОВЛЕН"),
          "  Русский: " .. (ru_exists and "✓" or "✗ НЕ УСТАНОВЛЕН"),
          "",
          not (en_exists and ru_exists) and "⚠ Используйте :SpellInstall для установки словарей" or "",
          "",
          "Горячие клавиши:",
          "  <leader>us  - включить/выключить",
          "  <leader>ul  - переключить язык",
          "  ]s / [s     - навигация по ошибкам",
          "  z=          - показать варианты",
          "  zg          - добавить в словарь",
          "",
          "Команды:",
          "  :SpellInstall     - установить все словари",
          "  :SpellInstall ru  - установить только русский",
          "  :SpellInstall en  - установить только английский",
          "",
          "Директории:",
          "  Системные: " .. spell_system_dir,
          "  Личные: " .. spell_dir,
        }

        vim.notify(table.concat(info, "\n"), vim.log.levels.INFO, { title = "Spell Checking" })
      end, {
        desc = "Показать информацию о spell checking",
      })
    end,
  },
}
