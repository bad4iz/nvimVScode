-- Плагин Telescope Undo
-- Просмотр истории изменений (undo/redo) через интерфейс Telescope
-- Позволяет визуально просматривать и восстанавливать предыдущие состояния файла
--
-- Горячие клавиши:
--   <Leader>fu - Открыть историю изменений в Telescope
--
-- Полезно для:
--   - Просмотра всех изменений файла
--   - Восстановления конкретного состояния из истории
--   - Навигации по истории undo/redo с превью
return {
  "debugloop/telescope-undo.nvim",
  lazy = true,
  specs = {
    {
      "nvim-telescope/telescope.nvim",
      dependencies = {
        "debugloop/telescope-undo.nvim",
        {
          "AstroNvim/astrocore",
          opts = {
            mappings = {
              n = {
                ["<Leader>fu"] = { "<Cmd>Telescope undo<CR>", desc = "Find undos" },
              },
            },
          },
        },
      },
      opts = function() require("telescope").load_extension "undo" end,
    },
  },
}
