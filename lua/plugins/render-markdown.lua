return {
  "MeanderingProgrammer/render-markdown.nvim",
  ft = "markdown",
  cmd = "RenderMarkdown",
  dependencies = { "nvim-treesitter/nvim-treesitter", "nvim-mini/mini.icons" },
  opts = {
    render_modes = { "n", "c", "i" },
    heading = { border = true },
    checkbox = {
      custom = {
        todo = { raw = "[-]", rendered = "󰥔 ", highlight = "RenderMarkdownTodo" },
      },
    },
  },
  keys = {
    {
      "<leader>mr",
      function() require("render-markdown").toggle() end,
      ft = "markdown",
      desc = "Markdown: переключить рендеринг",
    },
  },
}
