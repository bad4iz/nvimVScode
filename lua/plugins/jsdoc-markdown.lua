---@type LazySpec
return {
  "AstroNvim/astrocore",
  opts = {
    autocmds = {
      jsdoc_markdown_setup = {
        { event = "VimEnter", callback = function() require("jsdoc-markdown").setup() end },
      },
    },
  },
}
