---@type LazySpec
return {
  "folke/snacks.nvim",
  opts = function(_, opts)
    table.insert(opts.dashboard.preset.keys, {
      key = "k",
      action = ":CW",
      icon = " ",
      desc = "Codewars  ",
    })
  end,
}
