# Neovim — AstroNvim v6

Конфигурация на базе [AstroNvim](https://github.com/AstroNvim/AstroNvim).
Сохраняет Lua/Dart-настройки и добавляет PHP/Laravel, Blade, Vue и OpenCode V2.

## Требования

- Neovim >= 0.12.0, Git, Nerd Font.
- Node.js для веб-LSP и форматтеров.
- ripgrep для поиска, C-компилятор и tree-sitter CLI для парсеров.
- PHP CLI нужен для запуска Laravel, Artisan, тестов и проектного Pint.

## Установка

Сохраните свою текущую конфигурацию, затем клонируйте репозиторий:

```sh
git clone https://github.com/bad4iz/nvimVScode ~/.config/nvim
nvim
```

Дождитесь установки плагинов и инструментов Mason. После первой установки
Vue Language Server перезапустите Neovim.

## Обновление существующей установки

После перехода на AstroNvim v6 на каждой машине со старой установкой
один раз обновите оба Treesitter-плагина:

```vim
:Lazy update nvim-treesitter nvim-treesitter-textobjects
```

Дождитесь завершения и перезапустите Neovim. Оба плагина должны использовать
ветку `main`: старый `master` у textobjects несовместим с новым Treesitter
и вызывает ошибку `module 'nvim-treesitter.configs' not found`.

Обновление Git-конфигурации не обновляет установленные плагины автоматически:
локальный `lazy-lock.json` может сохранять старые версии. Для чистой установки
без старого lock-файла этот дополнительный шаг не нужен; ежедневно повторять
его тоже не надо.

## Структура

- `init.lua` → `lua/lazy_setup.lua` → `lua/polish.lua`.
- `lua/community.lua` — пакеты AstroCommunity (Lua и Dart).
- `lua/plugins/` — настройки плагинов поверх AstroNvim.
- `lua/plugins/web-development.lua` — PHP/Blade/Vue, LSP и форматирование.
- `lua/plugins/opencode.lua` — OpenCode V2, хоткеи и `ask_this`.
- `lua/plugins/snacks.lua` — выбранные файлы picker в вопрос OpenCode.
- `lua/plugins/testing.lua` — Vitest через Neotest и запуск с покрытием.

Старая структура `lua/user/` больше не используется.

## OpenCode

- `Ctrl+A` — вопрос с готовым `@this: `.
- `Ctrl+X` — меню; третий пункт `ask_this` открывает вопрос с `@this: `.
- `go` / `goo` — отправить диапазон / текущую строку.
- В Snacks picker `,o` — добавить выбранные файлы в вопрос.
- `:checkhealth opencode` — проверить подключение.

Плагин выбирает последнюю обновлённую сессию для текущей папки Neovim (`:pwd`),
а не обязательно чат, открытый в соседней вкладке. Изменённые файлы сохраняйте
перед отправкой — OpenCode читает их с диска.

## Codewars

Плагин `codewars.nvim` позволяет решать ката прямо в Neovim. Для входа выполните
`:CW cookie` и вставьте `CSRF-TOKEN` и `_session_id` из cookies Codewars в браузере.
Это секреты сессии: не публикуйте их и не добавляйте в Git.

- `Space kl` — выбрать ката; `Space kf` — подобрать задание.
- `Space kr` / `:CWPractice` — разминка: список 8–7 kyu в случайном порядке.
  В меню: `Katas` → `Warm-up 8/7 kyu (shuffle)` (клавиши `k`, затем `r` без Space).
- `Space kR` / `:CWResume` — продолжить последнюю открытую кату на том же языке.
  В меню: `Katas` → `Resume last kata` (`k`, затем `p`). Задача запоминается
  после открытия; код перед выходом нужно сохранить через `:w`.
- `Space kt` — примерные тесты; `Space ka` — полный набор; `Space ks` — отправить решение.
- `Space km` — меню; `Space kh` — справка; `Space ki` — диагностика.
- `Space kb` — открыть текущую кату в браузере (`:CW open`).
- По умолчанию JavaScript; смена языка: `:CW lang default typescript`.
- Отдельный запуск: `nvim codewars.nvim`.

Тесты и решения отправляются на Codewars. Исходники решений и cookies сохраняются
локально вне репозитория, в каталогах данных и кэша Neovim.

## Мультикурсор

- `Ctrl+n` — выбрать слово под курсором, повторное нажатие добавляет следующее вхождение.
- `Space ma` — выбрать все вхождения слова или визуально выделенного текста в текущем буфере.
- `c` — заменить выбранный текст одновременно; после ввода `Esc`, ещё один `Esc` — выйти.

## Codi — интерактивный черновик

- `Space jj` — новый черновик JavaScript; `Space jp` — Python.
- `Space js` — выбрать язык; `Space jt` — включить/выключить Codi в текущем буфере.
- `Space je` — развернуть результат; `Space jq` — выключить; `Space jh` — справка.
- В нижней строке `Codi ON` означает, что Codi включён для текущего буфера.
- Команды без хоткеев: `:CodiNew javascript`, `:CodiNew python`.

Для переключения и выключения в inline-режиме используйте `Space jt` / `Space jq`:
они обходят ошибку штатного выключения Codi, не закрывая исходный файл.

JavaScript требует `node`, Python — `python3`, TypeScript — отдельный REPL `tsun`.
Codi выполняет код локально и пересчитывает его при редактировании. Не включайте
его в файлах с опасными побочными эффектами: код выполняется повторно. Для
React/Vue-компонентов используйте приложение с dev-сервером, а не Codi.

## Vitest и покрытие

Открывайте Neovim из корня JS/TS-проекта с установленным `vitest`.
Для покрытия нужен `@vitest/coverage-v8` той же версии, что и `vitest`
(либо `@vitest/coverage-istanbul`, если проект использует Istanbul).

Меню тестов — `Space T` (заглавная `T`):

- `Space Tt` — тест под курсором; `Space Tf` — текущий файл; `Space Tp` — весь проект.
- `Space T Enter` — дерево тестов; `Space To` — вывод теста; `Space TO` — панель вывода.
- `Space TWf` — включить/выключить watch текущего тестового файла; `Space TWS` — остановить все watches.
  Для watch откройте тестовый файл и дождитесь подключения JS/TS LSP.
  При сохранении теста или связанного исходника тесты перезапускаются.
- `Space Ts` — остановить выполняющиеся тесты текущего файла.
- `Space TCr` — запустить проект с LCOV-покрытием, включая отчёт при падении тестов.
- После завершения `Space TCl` — загрузить отчёт и показать покрытие возле строк.
- `Space TCt` — скрыть/показать покрытие; `Space TCs` — сводка; `Space TCc` — очистить.

По умолчанию читается `coverage/lcov.info`; после первой загрузки изменения
отчёта подхватываются автоматически. Если проект меняет `coverage.reportsDirectory`,
укажите соответствующий путь в `nvim-coverage`: `opts.lang.javascript.coverage_file`
(настройка общая для JavaScript и TypeScript).

## PHP, Laravel и Vue

[Настройки, требования проекта и проверка](docs/php-laravel-vue.md).
Лидер — `Space`, локальный лидер — `,`. Навигацию и остальные хоткеи предоставляет AstroNvim.
