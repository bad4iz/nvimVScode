return {
  "karb94/neoscroll.nvim",
  config = function()
    require("neoscroll").setup {
      hide_cursor = true,
      stop_eof = true,
      respect_scrolloff = false,
      cursor_scrolls_alone = true,
      easing_function = "quadratic",
    }
  end,
}
