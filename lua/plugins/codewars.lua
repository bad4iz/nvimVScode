-- Codewars: решать ката из Neovim. Начало работы: :CW cookie, затем :CW list.
-- Space k открывает группу команд (leader = Space):
--   m — меню, l — список ката, f — подбор задания, c — решённые ката.
--   r — разминка: 8–7 kyu в случайном порядке (также :CWPractice).
--   R — продолжить последнюю кату (:CWResume). Перед выходом сохрани код через :w.
--   t — примерные тесты, a — полный набор тестов, s — отправить решение.
--   d — описание, o — вывод тестов, h — справка, i — диагностика.
--   b — открыть текущую кату в браузере (:CW open).
-- Язык по умолчанию: JavaScript; смена: :CW lang default typescript.
-- Тестирование и отправка передают код на Codewars. Cookies вводите только
-- через :CW cookie; они хранятся вне репозитория в stdpath("cache")/codewars.

local function open_practice() vim.cmd "CW list difficulty=8,7 order=shuffle" end

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
  config = function(_, opts)
    local resume = require "codewars-resume"
    opts.hooks = opts.hooks or {}
    opts.hooks.kata_enter = opts.hooks.kata_enter or {}
    table.insert(opts.hooks.kata_enter, resume.remember)
    require("codewars").setup(opts)
    vim.api.nvim_create_user_command("CWPractice", open_practice, {
      desc = "Codewars: разминка 8–7 kyu в случайном порядке",
    })
    vim.api.nvim_create_user_command("CWResume", resume.resume, {
      desc = "Codewars: продолжить последнюю кату",
    })

    -- The plugin exposes no custom menu entries option; extend each new menu
    -- before mounting so its own rendering and keymaps handle the extra button.
    local Menu = require "codewars-ui.renderer.menu"
    local original_init = Menu.init
    function Menu:init()
      local menu = original_init(self)
      table.insert(menu.pages.katas, 3, {
        icon = require("codewars.icons").get().focus,
        label = "Warm-up 8/7 kyu (shuffle)",
        sc = "r",
        fn = open_practice,
      })
      table.insert(menu.pages.katas, 1, {
        icon = require("codewars.icons").get().katas,
        label = "Resume last kata",
        sc = "p",
        fn = resume.resume,
      })
      return menu
    end
  end,
  keys = {
    { "<leader>k", desc = "Codewars" },
    { "<leader>km", "<cmd>CW<cr>", desc = "Codewars: меню" },
    { "<leader>kl", "<cmd>CW list<cr>", desc = "Codewars: список ката" },
    { "<leader>kr", open_practice, desc = "Codewars: разминка 8–7 kyu (shuffle)" },
    { "<leader>kR", "<cmd>CWResume<cr>", desc = "Codewars: продолжить последнюю кату" },
    { "<leader>kf", "<cmd>CW focus<cr>", desc = "Codewars: подобрать задание" },
    { "<leader>kc", "<cmd>CW completed<cr>", desc = "Codewars: решённые ката" },
    { "<leader>kt", "<cmd>CW test<cr>", desc = "Codewars: примерные тесты" },
    { "<leader>ka", "<cmd>CW attempt<cr>", desc = "Codewars: все тесты" },
    { "<leader>ks", "<cmd>CW submit<cr>", desc = "Codewars: отправить решение" },
    { "<leader>kd", "<cmd>CW desc<cr>", desc = "Codewars: описание" },
    { "<leader>ko", "<cmd>CW console<cr>", desc = "Codewars: вывод тестов" },
    { "<leader>kb", "<cmd>CW open<cr>", desc = "Codewars: открыть кату в браузере" },
    { "<leader>kh", "<cmd>CW help<cr>", desc = "Codewars: справка" },
    { "<leader>ki", "<cmd>CW doctor<cr>", desc = "Codewars: диагностика" },
  },
}
