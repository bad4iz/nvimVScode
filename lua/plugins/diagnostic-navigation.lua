---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        ["ge"] = {
          function() vim.diagnostic.jump { count = vim.v.count1, severity = vim.diagnostic.severity.ERROR } end,
          desc = "Next error",
        },
        ["gE"] = {
          function() vim.diagnostic.jump { count = -vim.v.count1, severity = vim.diagnostic.severity.ERROR } end,
          desc = "Previous error",
        },
      },
    },
  },
}
