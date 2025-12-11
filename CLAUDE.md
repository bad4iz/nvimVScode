# CLAUDE.md

This file provides guidance to Claude Code (claude.ai/code) when working with code in this repository.

## Обзор проекта

Это модульная конфигурация Neovim для веб-разработки с **двумя режимами работы**:
- **VSCode/Windsurf режим** — минимальный набор плагинов для vscode-neovim
- **Standalone Neovim режим** — полноценная IDE с LSP, автодополнением и UI

**Стиль горячих клавиш: AstroNvim**

## Архитектура

```
lua/user/
├── common/          # Базовые настройки для ОБОИХ режимов
│   ├── options.lua  # Базовые vim опции (leader = Space, отступы 2 пробела)
│   ├── keymaps.lua  # Общие горячие клавиши (AstroNvim style)
│   └── plugins/     # 5 навигационных плагинов (flash, surround, toggler, mini.ai, repeat)
├── windsurf/        # Конфигурация для VSCode режима
└── nvim/            # Полная конфигурация для standalone
    ├── options.lua  # Дополнительные опции
    ├── autocmds.lua # Автокоманды
    └── plugins/     # 27+ плагинов (LSP, treesitter, UI и т.д.)
```

**Определение режима** происходит в `init.lua` через проверку `vim.g.vscode`.

## Менеджер плагинов

**lazy.nvim** с автоматическим bootstrap при первом запуске.

| Команда | Описание |
|---------|----------|
| `:Lazy` | UI управления плагинами |
| `<leader>ps` | Статус плагинов |
| `<leader>pS` | Синхронизация |
| `<leader>pu` | Проверить обновления |
| `<leader>pU` | Обновить плагины |
| `<leader>pm` | Mason |
| `<leader>pa` | Обновить всё (Lazy + Mason) |

Lock-файл: `lazy-lock.json`

## Горячие клавиши (AstroNvim style)

Лидер-клавиша: **Space**

### General

| Комбинация | Действие |
|------------|----------|
| `jj` / `jk` | Выход из insert режима |
| `<C-s>` | Сохранить файл |
| `<C-q>` | Принудительный выход |
| `<leader>w` | Сохранить |
| `<leader>q` | Закрыть окно |
| `<leader>n` | Новый файл |
| `\|` | Вертикальный сплит |
| `\` | Горизонтальный сплит |
| `<leader>/` | Комментировать строку |

### Find / Search (`<leader>f`)

| Комбинация | Действие |
|------------|----------|
| `<leader>ff` | Найти файлы |
| `<leader>fF` | Найти ВСЕ файлы (включая скрытые) |
| `<leader>fg` | Git файлы |
| `<leader>fw` | Поиск слов (grep) |
| `<leader>fW` | Поиск во ВСЕХ файлах |
| `<leader>fc` | Слово под курсором |
| `<leader>fb` | Буферы |
| `<leader>fo` | Недавние файлы |
| `<leader>fh` | Справка |
| `<leader>fk` | Горячие клавиши |
| `<leader>fC` | Команды |
| `<leader>f'` | Marks |
| `<leader>fr` | Регистры |
| `<leader>fs` | Smart поиск |
| `<leader>ft` | Темы |
| `<leader>fu` | Undo history |
| `<leader>fa` | Config файлы |
| `<leader>f<CR>` | Возобновить поиск |

### Buffers (`<leader>b`)

| Комбинация | Действие |
|------------|----------|
| `<leader>c` | Закрыть буфер |
| `<leader>bb` | Выбрать буфер |
| `<leader>bd` | Удалить буфер |
| `<leader>bD` | Удалить все буферы |
| `<leader>bo` | Удалить другие буферы |
| `[b` / `]b` | Предыдущий/следующий буфер |
| `<S-h>` / `<S-l>` | Предыдущий/следующий буфер |

### Git (`<leader>g`)

| Комбинация | Действие |
|------------|----------|
| `<leader>gg` | Lazygit |
| `<leader>gb` | Git branches |
| `<leader>gc` | Git commits (repo) |
| `<leader>gC` | Git commits (file) |
| `<leader>gt` | Git status |
| `<leader>gT` | Git stash |
| `<leader>go` | Git browse (open in browser) |
| `<leader>gB` | Git blame line |

### LSP (`<leader>l`)

| Комбинация | Действие |
|------------|----------|
| `gd` | Определение |
| `gr` | Ссылки |
| `gI` | Реализация |
| `gy` | Тип |
| `gO` | Символы документа |
| `K` | Документация |
| `<leader>la` | Code actions |
| `<leader>lr` | Переименовать |
| `<leader>lf` | Форматировать |
| `<leader>ld` | Диагностика строки |
| `<leader>lD` | Все диагностики |
| `<leader>ls` | Символы документа |
| `<leader>lG` | Символы проекта |
| `<leader>li` | LSP info |
| `[d` / `]d` | Предыдущая/следующая диагностика |
| `[e` / `]e` | Предыдущая/следующая ошибка |
| `[w` / `]w` | Предыдущее/следующее предупреждение |

### Terminal (`<leader>t`)

| Комбинация | Действие |
|------------|----------|
| `<leader>tf` | Floating terminal |
| `<leader>th` | Horizontal terminal |
| `<leader>tv` | Vertical terminal |
| `<leader>tl` | Lazygit |
| `<F7>` / `<C-/>` | Toggle terminal |

### UI Toggles (`<leader>u`)

| Комбинация | Действие |
|------------|----------|
| `<leader>ub` | Toggle background |
| `<leader>ud` | Toggle diagnostics |
| `<leader>uD` | Dismiss notifications |
| `<leader>uh` | Toggle inlay hints |
| `<leader>un` | Toggle line numbers |
| `<leader>uL` | Toggle relative numbers |
| `<leader>us` | Toggle spelling |
| `<leader>uT` | Toggle treesitter |
| `<leader>uw` | Toggle wrap |
| `<leader>uZ` | Toggle zen mode |
| `<leader>u\|` | Toggle indent guides |

### Session (`<leader>S`)

| Комбинация | Действие |
|------------|----------|
| `<leader>Ss` | Сохранить сессию |
| `<leader>Sl` | Загрузить последнюю |
| `<leader>S.` | Загрузить (cwd) |
| `<leader>Sf` | Найти сессии |

### Quickfix (`<leader>x`)

| Комбинация | Действие |
|------------|----------|
| `<leader>xq` | Quickfix list |
| `<leader>xl` | Location list |
| `]q` / `[q` | Следующий/предыдущий |

### Навигация

| Комбинация | Действие |
|------------|----------|
| `<C-h/j/k/l>` | Навигация между окнами |
| `<C-Up/Down/Left/Right>` | Изменение размера окна |
| `s` + 2 символа | Flash jump |

## Ключевые компоненты

### LSP (lua/user/nvim/plugins/lsp.lua + mason.lua)
- **Mason** автоматически устанавливает LSP серверы
- Серверы: `vtsls` (TypeScript), `html`, `css`, `tailwindcss`, `lua_ls`, `eslint`, `emmet`
- Команды: `:Mason`, `:LspInfo`

### Автодополнение (blink-cmp.lua)
- **blink.cmp** — Rust-based автодополнение
- Интеграция с LuaSnip и friendly-snippets

### Форматирование и линтинг
- **conform.nvim** — форматирование (`prettierd`, `stylua`)
- **nvim-lint** — линтинг (`eslint_d`)
- Автоформатирование при сохранении включено

### UI и навигация
- **snacks.nvim** — dashboard, picker, notifier, terminal
- **neo-tree.nvim** — файловый менеджер (`<leader>e`)
- **which-key.nvim** — подсказки горячих клавиш

### Git
- **gitsigns.nvim** — изменения в signcolumn, stage/unstage
- **Snacks.lazygit** — интеграция с lazygit

### AI
- **supermaven-nvim** — AI автодополнение

## Добавление нового плагина

1. Создать файл в `lua/user/nvim/plugins/` (или `common/plugins/` для обоих режимов)
2. Вернуть таблицу конфигурации lazy.nvim
3. Запустить `:Lazy sync`

## Особенности

- **Better Escape** — `jj`/`jk` для выхода из insert режима
- **Lazy loading** — все плагины загружаются лениво
- **Persistent undo** — история отмены в `~/.local/share/nvim/undo_history`
- Treesitter отключается для файлов > 100KB
- Используются демоны (`prettierd`, `eslint_d`) для быстрой работы
