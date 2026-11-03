---@type LazySpec
return {
  "saghen/blink.cmp",
  config = function(_, opts)
    require("blink.cmp").setup(opts)
    require("completion-keymaps").setup()
  end,
  dependencies = {
    { "saghen/blink.compat", opts = {} },
    "supermaven-inc/supermaven-nvim",
    {
      "Exafunction/windsurf.nvim",
      dependencies = { "nvim-lua/plenary.nvim" },
      main = "codeium",
      opts = { enable_cmp_source = false, virtual_text = { enabled = false } },
    },
  },
  opts_extend = { "sources.default" },
  opts = {
    sources = {
      default = { "supermaven", "codeium" },
      providers = {
        lsp = { fallbacks = {} },
        codeium = { name = "Codeium", module = "codeium.blink", async = true },
        supermaven = {
          name = "Supermaven",
          module = "blink.compat.source",
          async = true,
          opts = { cmp_name = "supermaven" },
        },
      },
    },
    completion = {
      menu = {
        draw = {
          columns = { { "kind_icon" }, { "label", "label_description", gap = 1 }, { "source_name" } },
        },
      },
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },
    keymap = {
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<Tab>"] = { "select_next", "snippet_forward", "fallback" },
      ["<S-Tab>"] = { "select_prev", "snippet_backward", "fallback" },
      ["<CR>"] = { "select_and_accept", "fallback" },
    },
  },
}
