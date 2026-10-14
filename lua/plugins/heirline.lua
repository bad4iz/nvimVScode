-- Индикатор Codi относится к буферу, для которого рисуется статусная строка.
return {
  "rebelot/heirline.nvim",
  optional = true,
  opts = function(_, opts)
    table.insert(opts.statusline, 4, {
      condition = function() return vim.b.codi_enabled == true end,
      provider = " Codi ON ",
      hl = { fg = "green", bold = true },
    })
  end,
}
