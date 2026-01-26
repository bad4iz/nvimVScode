if true then
  return {}
end -- WARN: УДАЛИТЕ ЭТУ СТРОКУ ДЛЯ АКТИВАЦИИ TELESCOPE

--[[
Горячие клавиши для Claude Code (Leader = Space)

📂 Главное меню:
  <leader>a - Показать группу "AI/Claude Code" в which-key

🚀 Основные действия:
  <leader>ac - Открыть/закрыть терминал Claude
  <leader>af - Переключить фокус на терминал Claude
  <leader>ar - Возобновить последний разговор (флаг --resume)
  <leader>aC - Продолжить текущий разговор (флаг --continue)
  <leader>am - Выбрать модель Claude (Opus/Sonnet/Haiku)

📝 Управление контекстом:
  <leader>ab - Добавить текущий буфер в контекст Claude
  <leader>as - Отправить выделенное в Claude (visual mode)
  <leader>as - Добавить файл из дерева (в NvimTree/neo-tree/oil/minifiles/netrw)

✅ Управление изменениями:
  <leader>aa - Принять изменения от Claude
  <leader>ad - Отклонить изменения от Claude

💡 Типичный workflow:
  1. <leader>ac - открыть Claude
  2. <leader>ab - добавить текущий файл в контекст
  3. Задать вопрос Claude
  4. Когда Claude предложит изменения:
     - <leader>aa - принять
     - <leader>ad - отклонить

  Или:
  1. Выделить код в visual mode
  2. <leader>as - отправить Claude
  3. Обсудить этот фрагмент
--]]

return {
  "coder/claudecode.nvim",
  dependencies = { "folke/snacks.nvim" },
  opts = {
    terminal = {
      snacks_win_opts = {
        position = "bottom",
        height = 0.3,
        width = 1.0,
        border = "single",
      },
    },
  },
  keys = {
    -- Main menu
    { "<leader>a", nil, desc = "AI/Claude Code" },

    -- Core actions
    { "<leader>ac", "<cmd>ClaudeCode<cr>", desc = "Toggle Claude terminal" },
    { "<leader>af", "<cmd>ClaudeCodeFocus<cr>", desc = "Focus Claude terminal" },
    { "<leader>ar", "<cmd>ClaudeCode --resume<cr>", desc = "Resume last conversation" },
    { "<leader>aC", "<cmd>ClaudeCode --continue<cr>", desc = "Continue in current conversation" },
    { "<leader>am", "<cmd>ClaudeCodeSelectModel<cr>", desc = "Select Claude model" },

    -- Context management
    { "<leader>ab", "<cmd>ClaudeCodeAdd %<cr>", desc = "Add current buffer to context" },
    { "<leader>as", "<cmd>ClaudeCodeSend<cr>", mode = "v", desc = "Send selection to Claude" },
    {
      "<leader>as",
      "<cmd>ClaudeCodeTreeAdd<cr>",
      desc = "Add file from tree",
      ft = { "NvimTree", "neo-tree", "oil", "minifiles", "netrw" },
    },

    -- Diff management
    { "<leader>aa", "<cmd>ClaudeCodeDiffAccept<cr>", desc = "Accept Claude's changes" },
    { "<leader>ad", "<cmd>ClaudeCodeDiffDeny<cr>", desc = "Reject Claude's changes" },
  },
}
