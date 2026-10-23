-- :ApidocsInstall скачивает справку для офлайн-поиска; нужен системный elinks.
---@type LazySpec
return {
  {
    "emmanueltouzery/apidocs.nvim",
    dependencies = { "folke/snacks.nvim", "nvim-treesitter/nvim-treesitter" },
    cmd = { "ApidocsInstall", "ApidocsOpen", "ApidocsSearch", "ApidocsUninstall" },
    opts = { picker = "snacks" },
    keys = {
      { "<Leader>fd", "<cmd>ApidocsOpen<cr>", desc = "Документация: поиск API" },
      { "<Leader>fD", "<cmd>ApidocsSearch<cr>", desc = "Документация: поиск по тексту" },
    },
  },
  {
    "AstroNvim/astrocore",
    opts = { treesitter = { ensure_installed = { "html", "markdown_inline" } } },
  },
}
