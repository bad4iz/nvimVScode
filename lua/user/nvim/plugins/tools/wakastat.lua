-- ============================================================================
-- File: wakastat.nvim
-- Description: WakaTime статус для lualine
-- ============================================================================

return {
  "fiqryq/wakastat.nvim",
  event = "VeryLazy",
  init = function()
    -- Добавляем ~/.local/bin в PATH для Neovim
    local local_bin = vim.fn.expand("~/.local/bin")
    if not vim.env.PATH:find(local_bin, 1, true) then
      vim.env.PATH = local_bin .. ":" .. vim.env.PATH
    end
  end,
  opts = {
    args = { "--today" }, -- или "--week", "--month"
    format = "%s",        -- формат отображения
    update_interval = 120, -- обновление каждые 2 минуты
    enable_timer = true,
  },
}
