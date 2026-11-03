local M = {}
local api = vim.api
local required_keys = { "<Up>", "<Down>", "<CR>" }

local function is_completion_mapping(mapping) return mapping.desc and vim.startswith(mapping.desc, "blink.cmp:") end

function M.ensure()
  if not package.loaded["blink.cmp"] or not require("blink.cmp.config").enabled() then return end
  local missing = false
  for _, key in ipairs(required_keys) do
    if not is_completion_mapping(vim.fn.maparg(key, "i", false, true)) then
      missing = true
      break
    end
  end
  if not missing then return end

  -- Blink skips the entire buffer if even one of its mappings survives.
  -- Remove only Blink-owned mappings so its native installer can rebuild them.
  for _, mapping in ipairs(api.nvim_buf_get_keymap(0, "i")) do
    if is_completion_mapping(mapping) then api.nvim_buf_del_keymap(0, "i", mapping.lhs) end
  end
  local keymap = require "blink.cmp.keymap"
  local mappings = keymap.get_mappings(require("blink.cmp.config").keymap, "default")
  require("blink.cmp.keymap.apply").keymap_to_current_buffer(mappings)
end

function M.setup()
  api.nvim_create_autocmd({ "InsertEnter", "BufEnter", "FocusGained" }, {
    group = api.nvim_create_augroup("CompletionKeymaps", { clear = true }),
    desc = "Restore missing completion mappings after other plugins",
    callback = function()
      local buffer = api.nvim_get_current_buf()
      vim.schedule(function()
        if api.nvim_get_current_buf() == buffer and api.nvim_get_mode().mode == "i" then M.ensure() end
      end)
    end,
  })
  M.ensure()
end

return M
