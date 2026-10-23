---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    mappings = {
      n = {
        ["<C-Space>"] = { "van", remap = true, desc = "Start syntax selection" },
      },
      x = {
        ["<C-Space>"] = { "an", remap = true, desc = "Expand syntax selection" },
        ["<BS>"] = { "in", remap = true, desc = "Shrink syntax selection" },
      },
    },
  },
}
