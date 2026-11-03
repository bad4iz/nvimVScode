return {
  "folke/trouble.nvim",
  cmd = "Trouble",
  opts = {
    focus = false,
    auto_preview = true,
  },
  keys = {
    { "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Диагностика (Trouble)" },
    { "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Диагностика буфера (Trouble)" },
    { "<leader>xs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Символы (Trouble)" },
    { "<leader>xS", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP ссылки (Trouble)" },
    { "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location List (Trouble)" },
    { "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix (Trouble)" },
  },
}
