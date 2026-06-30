-- ============================================================================
-- File: wakastat.nvim
-- Description: WakaTime статус для lualine
-- ============================================================================

return {
  "fiqryq/wakastat.nvim",
  event = "VeryLazy",
  opts = {
    binary = "C:/Users/bad4i/.wakatime/wakatime-cli.exe",
    args = { "--today" }, -- или "--week", "--month"
    format = "%s",        -- формат отображения
    update_interval = 120, -- обновление каждые 2 минуты
    enable_timer = true,
  },
}