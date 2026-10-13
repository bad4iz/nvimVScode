# PHP, Laravel и Vue

Поддержка настроена в `lua/plugins/web-development.lua` поверх AstroNvim v6.
Открывайте редактор из корня проекта:

```bash
nvim .
```

## Что настроено

| Файлы | Возможности | Форматирование при сохранении |
| --- | --- | --- |
| `.php` | Intelephense: автодополнение, диагностика, документация и переходы по коду; Treesitter | Проектный Pint при наличии PHP CLI, иначе Intelephense |
| `.blade.php` | Отдельный тип `blade`, Treesitter с вложенными HTML/PHP, сниппеты Blade | `blade-formatter` |
| `.vue` | `vue_ls` + `vtsls`: шаблоны, стили, JavaScript/TypeScript, типы компонентов; Treesitter | `prettierd` |

Mason автоматически устанавливает Intelephense, Vue Language Server и Blade Formatter.
Vue TypeScript Plugin берётся из установленного Vue Language Server.
Сниппеты предоставляет штатная система автодополнения AstroNvim.
Отступы PHP/Blade — 4 пробела; проектный `.editorconfig` имеет приоритет.

## Требования проекта

Для работы редактора достаточно Node.js и Neovim >= 0.12.0. PHP и Composer нужны,
когда начнёте запускать приложение, Artisan, тесты или Pint.

- **Laravel:** Intelephense определяет корень по `composer.json`. Для переходов в
  Laravel, Eloquent и сторонние пакеты зависимости должны быть доступны в `vendor/`.
  PHPDoc и IDE-helper-файлы проекта помогают описать динамические методы моделей
  и фасадов; без них не все такие методы доступны статическому анализу.
- **Pint:** Conform ищет `vendor/bin/pint` вверх от открытого файла и запускает его
  из каталога с `composer.json`, учитывая проектный `pint.json`. PHP CLI должен быть в `PATH`.
- **Vue:** настройка рассчитана на Vue 3. Установите зависимости проекта, включая
  Vue и TypeScript для TS-проектов; используйте проектный `tsconfig.json`/`jsconfig.json`.
  Для Vue 2 нужна отдельная настройка Vue Language Tools.
- **ESLint:** подключается при наличии конфигурации проекта и исправляет ошибки при сохранении.
  Для `.vue` в проекте должен быть настроен `eslint-plugin-vue`.

## Основные команды

Лидер-клавиша — `Space`.

| Клавиша / команда | Действие |
| --- | --- |
| `gd` | Перейти к определению |
| `grr` | Найти использования |
| `K` | Документация символа |
| `<Space>la` | Действия кода, доступные серверу |
| `<Space>lf` | Форматирование через Conform и исправления подключённого ESLint |
| `:ConformInfo` | Проверить выбранный форматтер и его доступность |
| `:LspInfo` | Проверить серверы: PHP — `intelephense`, Vue — `vue_ls` и `vtsls` |
| `:Mason` | Посмотреть установленные инструменты |
| `:set filetype?` | Для `.blade.php` должен показывать `blade` |

После первой установки инструментов перезапустите Neovim, чтобы `vtsls` подхватил
Vue TypeScript Plugin. При переносе конфигурации на другую машину дождитесь установки
пакетов Mason и парсеров Treesitter.
