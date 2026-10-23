return {
  "smoka7/hop.nvim",
  branch = "v2",
  opts = {},
  keys = {
    { "s", function() require("hop").hint_words() end, mode = "n", desc = "Hop: прыжок к слову" },
    { "S", function() require("hop").hint_lines() end, mode = "n", desc = "Hop: прыжок к строке" },
  },
}
