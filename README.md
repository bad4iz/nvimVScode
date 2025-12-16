# 🚀 Neovim Configuration

Персональная конфигурация Neovim для **веб-разработки**, оптимизированная для работы с **Windsurf**, **VSCode** и **standalone Neovim**.

## 📑 Содержание

- [Особенности](#-особенности)
- [Требования](#-требования)
- [Установка](#-установка)
- [Структура](#-структура)
- [Горячие клавиши](#️-горячие-клавиши)
- [Документация](#-документация)
- [Переключение Telescope/Snacks.picker](#-переключение-telescopesnackspicker)
- [Комментарии на русском](#-комментарии-на-русском)
- [Лицензия](#-лицензия)

## ✨ Особенности

- 🎯 **Два режима работы**:
  - VSCode/Windsurf (через vscode-neovim)
  - Standalone Neovim (полная IDE)
- ⚡ **Быстрый запуск** благодаря lazy.nvim
- 🎨 **Красивый UI** с tokyonight, lualine, bufferline
- 🛠️ **Веб-разработка**: React, TypeScript
- 🤖 **AI автодополнение** через Supermaven
- 📁 **Современные плагины** конца 2025 года

## 📋 Требования

- Neovim >= 0.10.0
- Git >= 2.19.0
- [Nerd Font](https://www.nerdfonts.com/) (для иконок)
- Node.js (для LSP серверов)
- ripgrep (для поиска)

## 📦 Установка

```bash
# Бэкап текущей конфигурации
mv ~/.config/nvim ~/.config/nvim.bak

# Клонирование
git clone git@github.com:bad4iz/nvimVScode.git ~/.config/nvim

# Запуск Neovim (плагины установятся автоматически)
nvim
```

## 📂 Структура

```
~/.config/nvim/
├── init.lua                    # Точка входа
└── lua/user/
    ├── common/                 # 🔗 Общие настройки (оба режима)
    │   ├── options.lua         # Базовые vim опции
    │   ├── keymaps.lua         # Общие сочетания клавиш
    │   └── plugins/
    │       ├── flash.lua       # Быстрая навигация
    │       ├── nvim-surround.lua
    │       ├── nvim-toggler.lua
    │       ├── mini-ai.lua
    │       └── vim-repeat.lua
    │
    ├── windsurf/               # 🆚 Только для VSCode/Windsurf
    │   ├── settings.lua
    │   └── keymaps.lua
    │
    └── nvim/                   # 🖥️ Только для standalone
        ├── options.lua
        ├── autocmds.lua
        └── plugins/            # Плагины по категориям
            ├── completion/     # 🤖 Автодополнение
            │   ├── blink-cmp.lua
            │   ├── luasnip.lua
            │   └── supermaven.lua
            │
            ├── editor/         # ✏️ Редактирование
            │   ├── autopairs.lua
            │   ├── comment.lua
            │   └── surround.lua
            │
            ├── git/            # 🔀 Git интеграция
            │   └── gitsigns.lua
            │
            ├── lang/           # 🌐 Языки и синтаксис
            │   ├── treesitter.lua
            │   ├── markdown.lua
            │   └── spell.lua
            │
            ├── lsp/            # 🛠️ LSP и линтинг
            │   ├── lsp.lua
            │   ├── mason.lua
            │   ├── conform.lua
            │   └── trouble.lua
            │
            ├── tools/          # 🔧 Инструменты
            │   ├── neo-tree.lua
            │   ├── snacks.lua
            │   └── telescope.lua
            │
            └── ui/             # 🎨 Интерфейс
                ├── tokyonight.lua
                ├── lualine.lua
                ├── bufferline.lua
                └── which-key.lua
```

## ⌨️ Горячие клавиши

**Лидер-клавиша**: `<Space>`

### Общие (работают везде)

| Клавиша            | Описание                          |
| ------------------ | --------------------------------- |
| `s`                | Flash: прыжок к символу           |
| `S`                | Flash: Treesitter выбор           |
| `ys{motion}{char}` | Окружить текст                    |
| `ds{char}`         | Удалить окружение                 |
| `cs{old}{new}`     | Изменить окружение                |
| `<leader>i`        | Переключить значение (true/false) |

### Standalone Neovim

| Клавиша      | Описание              |
| ------------ | --------------------- |
| `<leader>ff` | Найти файлы           |
| `<leader>fg` | Поиск текста (grep)   |
| `<leader>fb` | Буферы                |
| `<leader>e`  | Файловый менеджер     |
| `<leader>gg` | Lazygit               |
| `gd`         | Перейти к определению |
| `gr`         | Найти ссылки          |
| `K`          | Документация          |
| `<leader>la` | Действия кода         |
| `<leader>lf` | Форматировать         |

## 📚 Документация

Подробные руководства по использованию:

| Документ | Описание |
| -------- | -------- |
| [🧭 Навигация](docs/navigation.md) | Поиск файлов, прыжки, LSP навигация |
| [🎯 Мультикурсор](docs/multicursor.md) | Множественные курсоры и выделения |
| [🤖 AI автодополнение](docs/ai-completion.md) | Supermaven и AI помощники |
| [📋 Quickfix](docs/quickfix.md) | Работа со списком ошибок |

## 🔌 Переключение Telescope/Snacks.picker

По умолчанию используется **snacks.picker**. Для переключения на Telescope:

1. Откройте `lua/user/nvim/plugins/telescope.lua`
2. Удалите строку: `if true then return {} end`
3. Отключите picker в snacks.lua

## 📝 Комментарии на русском

Все файлы конфигурации содержат подробные комментарии на русском языке с описанием:

- Назначения плагина
- Способов использования
- Горячих клавиш
- Ссылок на документацию

## 📄 Лицензия

MIT
