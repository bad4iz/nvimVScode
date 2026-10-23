---@type LazySpec
return {
  "saghen/blink.cmp",
  opts = {
    completion = {
      list = {
        selection = { preselect = false, auto_insert = false },
      },
    },
    keymap = {
      ["<Up>"] = { "select_prev", "fallback" },
      ["<Down>"] = { "select_next", "fallback" },
      ["<CR>"] = { "accept", "fallback" },
    },
  },
}
