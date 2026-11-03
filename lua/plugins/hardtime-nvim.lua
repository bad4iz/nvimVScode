-- :Hardtime disable — отключить до следующего запуска Neovim.
-- :Hardtime enable / toggle — включить обратно или переключить.
-- :HardtimePause [минуты] — пауза (по умолчанию 30 минут).
-- :HardtimeResume — отменить паузу и включить сразу.
-- :HardtimeOff — отменить таймер и отключить до перезапуска.
return {
  "m4xshen/hardtime.nvim",
  lazy = false,
  dependencies = { "MunifTanjim/nui.nvim" },
  keys = {
    { "<leader>H", desc = "Hardtime" },
    { "<leader>Hp", "<cmd>HardtimePause<cr>", desc = "Hardtime: пауза на 30 минут" },
    { "<leader>Hr", "<cmd>HardtimeResume<cr>", desc = "Hardtime: включить, отменить паузу" },
    { "<leader>Hd", "<cmd>HardtimeOff<cr>", desc = "Hardtime: выключить до перезапуска" },
    { "<leader>Hs", "<cmd>Hardtime report<cr>", desc = "Hardtime: отчёт" },
  },
  config = function(_, opts)
    local hardtime = require "hardtime"
    hardtime.setup(opts)

    local pause_timer
    local function cancel_pause()
      if pause_timer then
        pause_timer:stop()
        if not pause_timer:is_closing() then pause_timer:close() end
        pause_timer = nil
      end
    end

    vim.api.nvim_create_user_command("HardtimePause", function(args)
      local minutes = args.args == "" and 30 or tonumber(args.args)
      if not minutes or minutes <= 0 or minutes >= math.huge then
        vim.notify("Укажи положительное число минут: :HardtimePause 30", vim.log.levels.ERROR)
        return
      end
      cancel_pause()
      hardtime.disable()
      pause_timer = vim.defer_fn(function()
        pause_timer = nil
        hardtime.enable()
        vim.notify("Hardtime снова включён", vim.log.levels.INFO)
      end, math.ceil(minutes * 60 * 1000))
      vim.notify("Hardtime: пауза на " .. minutes .. " мин.", vim.log.levels.INFO)
    end, { nargs = "?", desc = "Приостановить Hardtime на указанное число минут (30 по умолчанию)" })

    vim.api.nvim_create_user_command("HardtimeResume", function()
      cancel_pause()
      hardtime.enable()
      vim.notify("Hardtime включён, таймер паузы отменён", vim.log.levels.INFO)
    end, { desc = "Отменить паузу и включить Hardtime" })

    vim.api.nvim_create_user_command("HardtimeOff", function()
      cancel_pause()
      hardtime.disable()
      vim.notify("Hardtime выключен до перезапуска Neovim", vim.log.levels.INFO)
    end, { desc = "Отменить таймер паузы и выключить Hardtime до перезапуска" })

    vim.api.nvim_create_autocmd("VimLeavePre", {
      group = vim.api.nvim_create_augroup("HardtimePauseTimer", { clear = true }),
      callback = cancel_pause,
      desc = "Освободить таймер паузы Hardtime",
    })
  end,
  opts = {
    enabled = true,
    restriction_mode = "block",
    max_count = 3,
    max_time = 1000,
    disable_mouse = false,
    -- Стрелки свободны в insert, в normal/visual ограничены как hjkl.
    disabled_keys = {
      ["<Up>"] = false,
      ["<Down>"] = false,
      ["<Left>"] = false,
      ["<Right>"] = false,
    },
    restricted_keys = {
      ["<Up>"] = { "n", "x" },
      ["<Down>"] = { "n", "x" },
      ["<Left>"] = { "n", "x" },
      ["<Right>"] = { "n", "x" },
    },
  },
}
