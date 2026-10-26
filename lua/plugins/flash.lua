return {
  "folke/flash.nvim",
  event = "VeryLazy",
  opts = {
    modes = {
      char = {
        enabled = false,
      },
      two_char = {
        search = {
          mode = "exact",
          max_length = 2,
          wrap = true,
          multi_window = false,
        },
        label = { min_pattern_length = 2 },
        jump = { autojump = false },
      },
    },
  },
  keys = {
    {
      "f",
      function() require("flash").jump { mode = "two_char", search = { forward = true } } end,
      mode = { "n", "x", "o" },
      desc = "Flash: два символа по всему окну",
    },
    {
      "t",
      function() require("flash").jump { mode = "two_char", jump = { offset = -1, inclusive = false } } end,
      mode = { "n", "x", "o" },
      desc = "Flash: перед совпадением по всему окну",
    },
  },
}
