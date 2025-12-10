--[[
=====================================================================
                        BUFFERLINE
=====================================================================
Красивая строка табов/буферов в стиле современных редакторов.

Горячие клавиши:
  <S-h>       - предыдущий буфер
  <S-l>       - следующий буфер
  <leader>bp  - закрепить буфер
  <leader>bP  - удалить незакреплённые буферы
  <leader>bo  - закрыть все кроме текущего
  <leader>br  - буферы справа
  <leader>bl  - буферы слева

Клик мышью:
  - ЛКМ на таб - переключиться
  - СКМ на таб - закрыть
  - Колёсико - прокрутка табов

GitHub: https://github.com/akinsho/bufferline.nvim
=====================================================================
--]]

return {
  "akinsho/bufferline.nvim",
  event = "VeryLazy",
  dependencies = { "nvim-tree/nvim-web-devicons" },
  
  config = function()
    require("bufferline").setup({
      options = {
        -- Режим отображения
        mode = "buffers",
        
        -- Стиль
        style_preset = require("bufferline").style_preset.default,
        themable = true,
        
        -- Номера буферов
        numbers = function(opts)
          return string.format("%s", opts.ordinal)
        end,
        
        -- Кнопка закрытия
        close_command = function(n)
          local ok, snacks = pcall(require, "snacks")
          if ok then snacks.bufdelete(n) else vim.cmd("bdelete! " .. n) end
        end,
        right_mouse_command = function(n)
          local ok, snacks = pcall(require, "snacks")
          if ok then snacks.bufdelete(n) else vim.cmd("bdelete! " .. n) end
        end,
        
        -- Индикаторы
        indicator = {
          icon = "▎",
          style = "icon",
        },
        
        -- Иконки
        buffer_close_icon = "󰅖",
        modified_icon = "●",
        close_icon = "",
        left_trunc_marker = "",
        right_trunc_marker = "",
        
        -- Максимальная длина имени
        max_name_length = 30,
        max_prefix_length = 30,
        truncate_names = true,
        
        -- Отступы от краёв
        tab_size = 21,
        
        -- Диагностика
        diagnostics = "nvim_lsp",
        diagnostics_update_in_insert = false,
        diagnostics_indicator = function(count, level)
          local icons = {
            error = " ",
            warning = " ",
            info = " ",
            hint = " ",
          }
          return " " .. (icons[level] or "") .. count
        end,
        
        -- Смещение для neo-tree
        offsets = {
          {
            filetype = "neo-tree",
            text = "󰉓 Файлы",
            text_align = "center",
            separator = true,
            highlight = "Directory",
          },
        },
        
        -- Разделители
        separator_style = "thin",
        
        -- Закреплённые буферы
        always_show_bufferline = true,
        
        -- Сортировка
        sort_by = "insert_after_current",
        
        -- Показывать закрытие только для текущего
        show_buffer_close_icons = true,
        show_close_icon = false,
        show_tab_indicators = true,
        show_duplicate_prefix = true,
        
        -- Цвета
        color_icons = true,
        
        -- Hover эффекты
        hover = {
          enabled = true,
          delay = 200,
          reveal = { "close" },
        },
        
        -- Группы буферов
        groups = {
          items = {
            require("bufferline.groups").builtin.pinned:with({ icon = "" }),
          },
        },
      },
    })
    
    -- Исправление перехода буферов при удалении
    vim.api.nvim_create_autocmd("BufDelete", {
      callback = function(event)
        vim.schedule(function()
          pcall(vim.cmd, "BufferLineCycleNext")
        end)
      end,
    })
  end,
  
  keys = {
    { "<S-h>", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер" },
    { "<S-l>", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер" },
    { "[b", "<cmd>BufferLineCyclePrev<cr>", desc = "Предыдущий буфер" },
    { "]b", "<cmd>BufferLineCycleNext<cr>", desc = "Следующий буфер" },
    { "<leader>bp", "<cmd>BufferLineTogglePin<cr>", desc = "Закрепить буфер" },
    { "<leader>bP", "<cmd>BufferLineGroupClose ungrouped<cr>", desc = "Закрыть незакреплённые" },
    { "<leader>bo", "<cmd>BufferLineCloseOthers<cr>", desc = "Закрыть остальные" },
    { "<leader>br", "<cmd>BufferLineCloseRight<cr>", desc = "Закрыть справа" },
    { "<leader>bl", "<cmd>BufferLineCloseLeft<cr>", desc = "Закрыть слева" },
    { "<leader>b1", "<cmd>BufferLineGoToBuffer 1<cr>", desc = "Буфер 1" },
    { "<leader>b2", "<cmd>BufferLineGoToBuffer 2<cr>", desc = "Буфер 2" },
    { "<leader>b3", "<cmd>BufferLineGoToBuffer 3<cr>", desc = "Буфер 3" },
    { "<leader>b4", "<cmd>BufferLineGoToBuffer 4<cr>", desc = "Буфер 4" },
    { "<leader>b5", "<cmd>BufferLineGoToBuffer 5<cr>", desc = "Буфер 5" },
  },
}
