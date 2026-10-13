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

## Структура

- `init.lua` → `lua/lazy_setup.lua` → `lua/polish.lua`.
- `lua/community.lua` — пакеты AstroCommunity (Lua и Dart).
- `lua/plugins/` — настройки плагинов поверх AstroNvim.
- `lua/plugins/web-development.lua` — PHP/Blade/Vue, LSP и форматирование.
- `lua/plugins/opencode.lua` — OpenCode V2, хоткеи и `ask_this`.
- `lua/plugins/snacks.lua` — выбранные файлы picker в вопрос OpenCode.

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

## PHP, Laravel и Vue

[Настройки, требования проекта и проверка](docs/php-laravel-vue.md).
Лидер — `Space`, локальный лидер — `,`. Навигацию и остальные хоткеи предоставляет AstroNvim.
