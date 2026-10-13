-- ============================================================================
-- File: wakastat.nvim
-- Description: WakaTime статистика для статусной строки
-- ============================================================================

return {
  "fiqryq/wakastat.nvim",
  event = "VeryLazy",
  dependencies = { "wakatime/vim-wakatime" },
  opts = function()
    local binary = vim.fn.exepath "wakatime-cli"
    if binary == "" then
      local home = vim.env.WAKATIME_HOME or vim.fn.expand "~"
      local suffix = vim.fn.has "win32" == 1 and ".exe" or ""
      binary = vim.fs.joinpath(home, ".wakatime", "wakatime-cli" .. suffix)
    end
    return {
      binary = binary,
      args = { "--today" },
      format = "%s",
      update_interval = 120,
      enable_timer = true,
    }
  end,
  config = function(_, opts)
    if vim.fn.executable(opts.binary) ~= 1 then
      vim.notify(
        "WakaStat: WakaTime CLI пока не установлен. После установки перезапустите Neovim.",
        vim.log.levels.WARN
      )
      return
    end
    require("wakastat").setup(opts)
  end,
}
