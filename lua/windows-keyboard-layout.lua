local M = {}
local api, uv = vim.api, vim.uv
local state
local powershell = "/mnt/c/Windows/System32/WindowsPowerShell/v1.0/powershell.exe"
local russian_blue = "#0039A6"
local flag_width, flag_height = 2, 2
local flag_opacity = 1
-- Terminal coordinates use whole cells: about 10 px per column and 25 px per row with the current font.
local badge_offset = { columns = 0, rows = 2 }

local function hide_badge()
  if not state.image_row then return end
  state.image_row, state.image_col = nil, nil
  -- Raster pixels are outside Nvim's cell cache. Repaint instead of erasing
  -- a guessed cell, which can overwrite newly drawn text or diagnostics.
  api.nvim_ui_send "\27[?2026h"
  local ok, err = pcall(vim.cmd.mode)
  if state.active and state.terminal and state.russian and state.colored then
    api.nvim_ui_send("\27]12;" .. russian_blue .. "\7")
  end
  api.nvim_ui_send "\27[?2026l"
  if not ok then error(err) end
end

local function restore_color()
  if not state.colored then return end
  api.nvim_ui_send(state.original_color and ("\27]12;" .. state.original_color .. "\7") or "\27]112\7")
  state.colored = false
end

local function usable()
  local uis, mode = api.nvim_list_uis(), api.nvim_get_mode()
  return #uis == 1
    and uis[1].stdout_tty
    and not mode.blocking
    and (mode.mode == "n" or mode.mode == "i" or mode.mode == "R")
    and vim.bo.buftype ~= "terminal"
end

local function render()
  if not state.active or not state.terminal or not state.russian or not usable() then
    hide_badge()
    restore_color()
    return
  end
  -- Mode changes and Terminal settings reloads can overwrite an OSC cursor color.
  api.nvim_ui_send("\27]12;" .. russian_blue .. "\7")
  state.colored = true
  if vim.fn.pumvisible() ~= 0 or api.nvim_win_get_config(0).relative ~= "" then
    hide_badge()
    return
  end
  vim.cmd.redraw()
  local position = vim.fn.screenpos(0, vim.fn.line ".", vim.fn.col ".")
  if position.row == 0 then
    hide_badge()
    return
  end
  local row = math.max(0, math.min(vim.o.lines - flag_height - vim.o.cmdheight, position.row - 2 - badge_offset.rows))
  local preferred_col = math.max(0, math.min(vim.o.columns - flag_width, position.curscol + 1 + badge_offset.columns))
  local function available(candidate)
    if candidate < 0 or candidate + flag_width > vim.o.columns then return false end
    -- The larger raster touches two rows; neither may contain text or diagnostics.
    for y = row, row + flag_height - 1 do
      for x = candidate, candidate + flag_width - 1 do
        if vim.fn.screenstring(y + 1, x + 1) ~= " " then return false end
      end
    end
    return true
  end
  local col
  -- Keep looking along the row if the nearest spaces cannot fit the larger flag.
  for distance = 0, vim.o.columns - flag_width do
    for _, candidate in ipairs { preferred_col + distance, preferred_col - distance } do
      if available(candidate) then
        col = candidate
        break
      end
    end
    if col then break end
  end
  if not col then
    hide_badge()
    return
  end
  if state.image_row ~= row or state.image_col ~= col then hide_badge() end
  api.nvim_ui_send("\27]12;" .. russian_blue .. "\7")
  -- A full repaint may reveal diagnostics that were pending during the first check.
  if not available(col) then return end
  api.nvim_ui_send(string.format("\0277\27[%d;%dH%s\0278", row + 1, col + 1, state.flag_sixel))
  state.image_row, state.image_col = row, col
end

local function pause()
  state.active, state.pending = false, false
  state.generation = state.generation + 1
  state.timer:stop()
  hide_badge()
  restore_color()
end

local function start()
  pause()
  state.active = true
  local instance = state
  state.timer:start(0, 350, function()
    local generation = state.generation
    vim.schedule(function()
      if state ~= instance or not state.active or generation ~= state.generation or state.job <= 0 then return end
      if state.pending and uv.now() - state.pending.time < 2000 then return end
      state.sequence = state.sequence + 1
      state.pending = { id = state.sequence, generation = generation, time = uv.now() }
      vim.fn.chansend(state.job, state.sequence .. "\n")
    end)
  end)
end

function M.status()
  if not state then return { enabled = false } end
  return {
    enabled = true,
    language = state.language,
    terminal = state.terminal,
    russian = state.russian,
    active = state.active,
    colored = state.colored,
    badge = state.image_row ~= nil,
    image = state.image_row ~= nil,
    helper_running = state.job > 0,
    error = state.error,
  }
end

function M.stop()
  if not state then return end
  pause()
  state.timer:close()
  if state.job > 0 then
    -- EOF lets PowerShell exit cleanly, including when Neovim is reconfigured.
    pcall(vim.fn.chanclose, state.job, "stdin")
  end
  api.nvim_del_augroup_by_id(state.group)
  state = nil
end

function M.setup()
  if state or not vim.env.WT_SESSION or not api.nvim_ui_send or vim.env.TMUX then return end
  if vim.fn.executable(powershell) ~= 1 or #api.nvim_list_uis() ~= 1 then return end
  local helper = vim.fn.stdpath "config" .. "/scripts/keyboard-layout.ps1"
  if vim.fn.filereadable(helper) ~= 1 then return end
  local script = table.concat(vim.fn.readfile(helper), "\n")
  state = {
    active = false,
    terminal = false,
    russian = false,
    colored = false,
    generation = 0,
    sequence = 0,
    pending = false,
    job = 0,
    output = "",
    error = "",
    group = api.nvim_create_augroup("WindowsKeyboardLayout", { clear = true }),
    timer = assert(uv.new_timer()),
  }
  local instance = state
  local function highlights()
    local background = api.nvim_get_hl(0, { name = "Normal", link = false }).bg or 0x1A1B26
    -- winblend fades glyphs and backgrounds differently, splitting the middle stripe.
    -- Preblend both against the editor background with the same opacity instead.
    local function faded(color)
      local result = 0
      for _, shift in ipairs { 16, 8, 0 } do
        local base = 2 ^ shift
        local foreground_channel = math.floor(color / base) % 256
        local background_channel = math.floor(background / base) % 256
        local channel = math.floor(foreground_channel * flag_opacity + background_channel * (1 - flag_opacity) + 0.5)
        result = result + channel * base
      end
      return result
    end
    local white, blue, red = faded(0xFFFFFF), faded(0x0039A6), faded(0xD52B1E)
    state.background = background
    local function palette(index, color)
      local channels = {}
      for _, shift in ipairs { 16, 8, 0 } do
        channels[#channels + 1] = math.floor((math.floor(color / 2 ^ shift) % 256) * 100 / 255 + 0.5)
      end
      return string.format("#%d;2;%d;%d;%d", index, channels[1], channels[2], channels[3])
    end
    -- WT uses a 10 x 20 virtual-pixel cell. The visible flag is 20 x 16;
    -- ten transparent rows preserve its half-cell vertical offset.
    state.flag_sixel = '\27P0;1q"1;1;20;26'
      .. palette(0, white)
      .. palette(1, blue)
      .. palette(2, red)
      .. "-#0!20o-#0!20N$#1!20o-#1!20N$#2!20o-#2!20B\27\\"
  end
  highlights()
  api.nvim_create_autocmd("TermResponse", {
    group = state.group,
    callback = function(event)
      local response = event.data and event.data.sequence or vim.v.termresponse
      local color = response and response:match "^\27%]12;(rgb:[%x]+/[%x]+/[%x]+)"
      if color and not state.original_color then state.original_color = color end
    end,
  })
  api.nvim_ui_send "\27]12;?\7"
  state.job = vim.fn.jobstart({
    powershell,
    "-NoLogo",
    "-NoProfile",
    "-NonInteractive",
    "-WindowStyle",
    "Hidden",
    "-Command",
    script,
  }, {
    on_stdout = function(_, data)
      if state ~= instance then return end
      state.output = state.output .. table.concat(data, "\n")
      while true do
        local boundary = state.output:find("\n", 1, true)
        if not boundary then break end
        local line = state.output:sub(1, boundary - 1):gsub("\r$", "")
        state.output = state.output:sub(boundary + 1)
        local sequence, language, terminal = line:match "^(%d+)|(%x%x%x%x)|([01])$"
        if sequence and state.pending and tonumber(sequence) == state.pending.id then
          local request = state.pending
          state.pending = false
          if state.active and request.generation == state.generation and uv.now() - request.time < 2000 then
            state.language = language:lower()
            state.terminal = terminal == "1"
            state.russian = state.language == "0419"
            render()
          end
        end
      end
    end,
    on_stderr = function(_, data)
      if state == instance then state.error = (state.error .. table.concat(data, "\n")):sub(-1000) end
    end,
    on_exit = function(_, code)
      if state ~= instance then return end
      state.job = 0
      pause()
      if code ~= 0 then vim.notify("Keyboard layout indicator: helper exited (" .. code .. ")", vim.log.levels.WARN) end
    end,
  })
  if state.job <= 0 then
    M.stop()
    return
  end
  api.nvim_create_autocmd({ "FocusGained", "VimResume" }, { group = state.group, callback = start })
  api.nvim_create_autocmd({ "FocusLost", "VimSuspend" }, { group = state.group, callback = pause })
  api.nvim_create_autocmd({ "CursorMoved", "CursorMovedI", "WinScrolled", "VimResized", "ModeChanged", "BufEnter" }, {
    group = state.group,
    callback = function(event)
      state.full_repaint = state.full_repaint or event.event == "WinScrolled" or event.event == "VimResized"
      if state.render_scheduled then return end
      state.render_scheduled = true
      vim.schedule(function()
        if state ~= instance then return end
        state.render_scheduled = false
        if state.full_repaint then hide_badge() end
        state.full_repaint = false
        render()
      end)
    end,
  })
  api.nvim_create_autocmd("ColorScheme", { group = state.group, callback = highlights })
  api.nvim_create_autocmd("VimLeavePre", { group = state.group, callback = M.stop })
  start()
end

return M
