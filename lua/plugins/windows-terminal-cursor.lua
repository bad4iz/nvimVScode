-- Windows Terminal can reset the TUI cursor when the keyboard layout changes.
-- https://github.com/microsoft/terminal/issues/11522
return {
  "AstroNvim/astrocore",
  opts = function()
    if not vim.env.WT_SESSION or not vim.api.nvim_ui_send or vim.env.TMUX then return end
    if vim.fn.exists "#WindowsTerminalCursor" == 1 then return end
    local uis = vim.api.nvim_list_uis()
    if #uis ~= 1 or not uis[1].stdout_tty then return end

    local api, uv = vim.api, vim.uv
    local default_cursor = api.nvim_get_option_info2("guicursor", {}).default
    local group = api.nvim_create_augroup("WindowsTerminalCursor", { clear = true })
    local timer = assert(uv.new_timer())
    local active, closed, generation, pending = false, false, 0, nil

    local function eligible()
      local mode = api.nvim_get_mode()
      local attached = api.nvim_list_uis()
      return #attached == 1
        and attached[1].stdout_tty
        and not mode.blocking
        and mode.mode == "i"
        and vim.o.guicursor == default_cursor
        and vim.fn.pumvisible() == 0
    end

    local function pause()
      active, pending = false, nil
      generation = generation + 1
      if not closed then timer:stop() end
    end

    local function start()
      pause()
      local start_generation = generation
      -- InsertEnter fires before Insert mode is fully active.
      vim.schedule(function()
        if closed or start_generation ~= generation or not eligible() then return end
        active = true
        timer:start(0, 400, function()
          local current_generation = generation
          vim.schedule(function()
            if closed or not active or current_generation ~= generation or not eligible() then return end
            local now = uv.now()
            if pending and now - pending.time < 1000 then return end
            pending = { time = now, generation = generation, cursor = vim.o.guicursor }
            api.nvim_ui_send "\27P$q q\27\\"
          end)
        end)
      end)
    end

    api.nvim_create_autocmd("TermResponse", {
      group = group,
      callback = function(event)
        local response = event.data and event.data.sequence or vim.v.termresponse
        local style = response and response:match "^\27P1%$r([0-6]) q"
        if not style or not pending then return end
        local request = pending
        pending = nil
        if
          closed
          or not active
          or request.generation ~= generation
          or uv.now() - request.time >= 1000
          or vim.o.guicursor ~= request.cursor
          or not eligible()
        then
          return
        end
        -- Reapply only a lost default Insert cursor; preserve custom guicursor settings.
        if tonumber(style) ~= 6 then api.nvim_ui_send "\27[6 q" end
      end,
    })
    api.nvim_create_autocmd({ "InsertEnter", "FocusGained", "VimResume" }, { group = group, callback = start })
    api.nvim_create_autocmd({ "InsertLeave", "FocusLost", "VimSuspend" }, { group = group, callback = pause })
    api.nvim_create_autocmd("VimLeavePre", {
      group = group,
      callback = function()
        if closed then return end
        pause()
        closed = true
        timer:close()
      end,
    })
    start()
  end,
}
