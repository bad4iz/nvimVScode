return {
  "folke/noice.nvim",
  opts = {
    presets = {
      lsp_doc_border = true,
    },
    views = {
      hover = {
        border = { style = "rounded" },
        size = {
          max_width = 90,
          max_height = 20,
        },
      },
    },
  },
  keys = {
    {
      "<C-f>",
      function()
        if not require("noice.lsp").scroll(4) then return "<C-f>" end
      end,
      mode = { "n", "i", "s" },
      expr = true,
      silent = true,
      desc = "Прокрутить документацию вниз",
    },
    {
      "<C-b>",
      function()
        if not require("noice.lsp").scroll(-4) then return "<C-b>" end
      end,
      mode = { "n", "i", "s" },
      expr = true,
      silent = true,
      desc = "Прокрутить документацию вверх",
    },
  },
}
