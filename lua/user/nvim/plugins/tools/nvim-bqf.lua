--[[
════════════════════════════════════════════════════════════════════════════════
  nvim-bqf - Better Quickfix Window
  https://github.com/kevinhwang91/nvim-bqf
════════════════════════════════════════════════════════════════════════════════

ОПИСАНИЕ:
  Улучшает функциональность quickfix окна в Neovim:
  - Превью файлов прямо в quickfix окне
  - Fuzzy-фильтрация через fzf
  - Подсветка синтаксиса в превью (через treesitter)
  - Удобная навигация и выбор элементов

════════════════════════════════════════════════════════════════════════════════
ОСНОВНЫЕ ГОРЯЧИЕ КЛАВИШИ (в quickfix окне):
════════════════════════════════════════════════════════════════════════════════

  НАВИГАЦИЯ И ПРЕВЬЮ:
    p         - Переключить превью окно
    <Tab>     - Переключить выбор элемента и перейти к следующему
    <S-Tab>   - Переключить выбор элемента и перейти к предыдущему

  ФИЛЬТРАЦИЯ:
    zf        - Открыть fzf для fuzzy-фильтрации
    zF        - Открыть fzf (включая скрытые элементы)

  РЕЖИМЫ ПРЕВЬЮ:
    z,        - Переключить режим превью (сверху/снизу)

  ДЕЙСТВИЯ С ФАЙЛАМИ:
    <CR>      - Открыть файл в текущем окне (quickfix остаётся открытым)
    o         - Открыть файл и ЗАКРЫТЬ quickfix
    <C-v>     - Открыть в вертикальном сплите
    <C-x>     - Открыть в горизонтальном сплите
    <C-t>     - Открыть в новой вкладке

  В FZF РЕЖИМЕ:
    <C-s>     - Открыть в сплите
    <C-o>     - Переключить выбор всех элементов

════════════════════════════════════════════════════════════════════════════════
ПРИМЕРЫ ИСПОЛЬЗОВАНИЯ:
════════════════════════════════════════════════════════════════════════════════

1. ПОИСК ПО ТЕКУЩЕМУ ФАЙЛУ:
   :vimgrep /function/j % | copen

2. ПОИСК ПО ВСЕМ ФАЙЛАМ ПРОЕКТА:
   :vimgrep /TODO/gj **/*.lua | copen

3. РЕЗУЛЬТАТЫ LSP:
   - Использовать "Find References" или "Find Definitions"
   - Результаты откроются в quickfix автоматически

4. GREP ЧЕРЕЗ TELESCOPE (если настроен):
   - После поиска нажать <C-q> чтобы отправить в quickfix

5. НАВИГАЦИЯ ПО ОШИБКАМ КОМПИЛЯЦИИ:
   - После :make или :compiler результаты попадут в quickfix

6. GIT КОНФЛИКТЫ (с fugitive):
   - :Git mergetool
   - Конфликты откроются в quickfix

════════════════════════════════════════════════════════════════════════════════
НАСТРОЙКИ В ЭТОМ ФАЙЛЕ:
════════════════════════════════════════════════════════════════════════════════

  auto_enable          - Автоматическое включение при открытии quickfix
  auto_resize_height   - Автоматическое изменение высоты окна

  preview:
    win_height         - Высота превью окна (12 строк)
    border             - Стиль границ ("rounded")
    delay_syntax       - Задержка подсветки синтаксиса (80ms)
    should_preview_cb  - Фильтр: не показывать превью для файлов >100KB

  filter.fzf:
    action_for         - Дополнительные действия в fzf
    extra_opts         - Опции fzf (prompt, биндинги)

════════════════════════════════════════════════════════════════════════════════
СОВЕТЫ:
════════════════════════════════════════════════════════════════════════════════

• Используйте :copen для открытия quickfix, :cclose для закрытия
• :cnext / :cprev - навигация по quickfix без открытия окна
• :colder / :cnewer - переключение между историей quickfix списков
• Можно комбинировать с vim-unimpaired плагином для <[q> <]q> навигации

════════════════════════════════════════════════════════════════════════════════
]]

---@type LazySpec
return {
  "kevinhwang91/nvim-bqf",
  ft = "qf",
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
  },
  config = function()
    require("bqf").setup {
      auto_enable = true,
      auto_resize_height = true,
      preview = {
        win_height = 12,
        win_vheight = 12,
        delay_syntax = 80,
        border = "rounded",
        show_title = true,
        should_preview_cb = function(bufnr, qwinid)
          local ret = true
          local bufname = vim.api.nvim_buf_get_name(bufnr)
          local fsize = vim.fn.getfsize(bufname)
          if fsize > 100 * 1024 then
            ret = false
          elseif bufname:match "^fugitive://" then
            ret = false
          end
          return ret
        end,
      },
      func_map = {
        vsplit = "",
        ptogglemode = "z,",
        stoggleup = "",
      },
      filter = {
        fzf = {
          action_for = { ["ctrl-s"] = "split" },
          extra_opts = { "--bind", "ctrl-o:toggle-all", "--prompt", "> " },
        },
      },
    }

    -- Маппинг 'o' для открытия файла с закрытием quickfix
    vim.api.nvim_create_autocmd("FileType", {
      pattern = "qf",
      callback = function()
        vim.keymap.set("n", "o", function()
          local qf_idx = vim.fn.line "."
          vim.cmd("cc " .. qf_idx) -- Сначала открываем файл
          vim.cmd "cclose" -- Потом закрываем quickfix
        end, { buffer = true, desc = "Open item and close quickfix" })
      end,
    })
  end,
}
