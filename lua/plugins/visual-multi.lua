-- Мультикурсор: Ctrl+n выбирает слово и добавляет следующие вхождения.
-- Space ma выбирает все вхождения слова / визуально выделенного текста в буфере.
-- Затем c — заменить выделения, ввод текста — одновременно во всех местах.
-- Esc завершает ввод, ещё один Esc выходит из режима мультикурсора.
-- Это текстовое редактирование; для переименования символа во всём проекте
-- используйте LSP rename, а не выделение совпадающих строк.
-- https://github.com/mg979/vim-visual-multi

---@type LazySpec
return {
  "mg979/vim-visual-multi",
  lazy = false,
  init = function()
    vim.g.VM_maps = vim.tbl_extend("force", vim.g.VM_maps or {}, {
      ["Select All"] = "<leader>ma",
      ["Visual All"] = "<leader>ma",
    })
    vim.g.VM_silent_exit = 1
  end,
}
