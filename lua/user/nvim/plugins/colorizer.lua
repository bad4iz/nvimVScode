-- nvim-highlight-colors - подсветка hex/rgb/hsl цветов
-- Примеры:
--   #d787ff  - hex
--   rgb(215, 135, 255) - rgb
--   hsl(280, 100%, 76%) - hsl

return {
  "brenoprata10/nvim-highlight-colors",
  event = { "BufReadPost", "BufNewFile" }, -- lazy load при открытии файлов
  opts = {
    -- Режим рендеринга
    -- 'background' - фон символов
    -- 'foreground' - цвет текста
    -- 'virtual' - виртуальный текст
    render = "background",

    -- Включить именованные цвета (red, blue, green и т.д.)
    enable_named_colors = true,

    -- Какие цветовые форматы распознавать
    -- 'hex', 'rgb', 'hsl', 'css_rgb', 'css_hsl', 'css_fn'
    -- Пример: '#d787ff', 'rgb(215,135,255)', 'hsl(280,100%,76%)'

    -- Форматы для разных типов файлов
    -- По умолчанию все включены
    exclude_filetypes = {
      "lazy", -- не подсвечивать в Lazy UI
      "mason", -- не подсвечивать в Mason UI
      "help",
    },
    exclude_buftypes = {
      "terminal",
      "nofile",
    },
  },
  config = function(_, opts)
    require("nvim-highlight-colors").setup(opts)

    -- Горячие клавиши (AstroNvim style)
    local map = vim.keymap.set

    -- <leader>uc - toggle colorizer (u = ui, c = colorizer)
    map("n", "<leader>uc", ":HighlightColors Toggle<CR>", {
      desc = "Toggle colorizer",
      silent = true
    })
  end,
}
