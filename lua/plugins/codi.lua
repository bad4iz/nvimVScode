-- Codi — локальный интерактивный черновик с результатами рядом с кодом.
-- Space j: j — JavaScript, p — Python, s — выбрать язык, t — переключить
-- текущий буфер, u — пересчитать, e — развернуть результат, q — выключить.
-- Требования: node для JavaScript, python3 для Python; TypeScript требует tsun.
-- Запускается только вручную. После включения повторно выполняет код при
-- редактировании: не используйте для секретов, удаления файлов и других
-- опасных побочных эффектов. Это REPL, не запуск React/Vue-приложения.

---@type LazySpec
return {
  "metakirby5/codi.vim",
  cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand", "CodiUpdate" },
  init = function()
    vim.g["codi#interpreters"] = vim.tbl_deep_extend("force", vim.g["codi#interpreters"] or {}, {
      python = { bin = { "python3", "-q" } },
    })
  end,
  keys = {
    { "<leader>j", desc = "Codi: черновик" },
    { "<leader>jj", "<cmd>CodiNew javascript<cr>", desc = "Codi: черновик JavaScript" },
    { "<leader>jp", "<cmd>CodiNew python<cr>", desc = "Codi: черновик Python" },
    { "<leader>js", "<cmd>CodiSelect<cr>", desc = "Codi: выбрать язык" },
    { "<leader>jt", "<cmd>Codi!!<cr>", desc = "Codi: включить / выключить буфер" },
    { "<leader>ju", "<cmd>CodiUpdate<cr>", desc = "Codi: пересчитать" },
    { "<leader>je", "<cmd>CodiExpand<cr>", desc = "Codi: развернуть результат" },
    { "<leader>jq", "<cmd>Codi!<cr>", desc = "Codi: выключить" },
    { "<leader>jh", "<cmd>help codi<cr>", desc = "Codi: справка" },
  },
}
