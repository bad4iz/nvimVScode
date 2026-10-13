-- Codewars: решать ката из Neovim. Начало работы: :CW cookie, затем :CW list.
-- Space k открывает группу команд (leader = Space):
--   m — меню, l — список ката, f — подбор задания, c — решённые ката.
--   t — примерные тесты, a — полный набор тестов, s — отправить решение.
--   d — описание, o — вывод тестов, h — справка, i — диагностика.
-- Язык по умолчанию: JavaScript; смена: :CW lang default typescript.
-- Тестирование и отправка передают код на Codewars. Cookies вводите только
-- через :CW cookie; они хранятся вне репозитория в stdpath("cache")/codewars.

---@type LazySpec
return {
  "prosk-sudo/codewars.nvim",
  version = "*",
  lazy = false, -- Поддерживает также запуск: nvim codewars.nvim.
  dependencies = {
    "nvim-lua/plenary.nvim",
    "MunifTanjim/nui.nvim",
    "nvim-telescope/telescope.nvim",
  },
  opts = { lang = "javascript" },
  keys = {
    { "<leader>k", desc = "Codewars" },
    { "<leader>km", "<cmd>CW menu<cr>", desc = "Codewars: меню" },
    { "<leader>kl", "<cmd>CW list<cr>", desc = "Codewars: список ката" },
    { "<leader>kf", "<cmd>CW focus<cr>", desc = "Codewars: подобрать задание" },
    { "<leader>kc", "<cmd>CW completed<cr>", desc = "Codewars: решённые ката" },
    { "<leader>kt", "<cmd>CW test<cr>", desc = "Codewars: примерные тесты" },
    { "<leader>ka", "<cmd>CW attempt<cr>", desc = "Codewars: все тесты" },
    { "<leader>ks", "<cmd>CW submit<cr>", desc = "Codewars: отправить решение" },
    { "<leader>kd", "<cmd>CW desc<cr>", desc = "Codewars: описание" },
    { "<leader>ko", "<cmd>CW console<cr>", desc = "Codewars: вывод тестов" },
    { "<leader>kh", "<cmd>CW help<cr>", desc = "Codewars: справка" },
    { "<leader>ki", "<cmd>CW doctor<cr>", desc = "Codewars: диагностика" },
  },
}
