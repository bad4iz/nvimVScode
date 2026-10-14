-- Codi — локальный интерактивный черновик с результатами рядом с кодом.
-- Space j: j — JavaScript, p — Python, s — выбрать язык, t — переключить
-- текущий буфер, u — пересчитать, e — развернуть результат, q — выключить.
-- Требования: node для JavaScript, python3 для Python; TypeScript требует tsun.
-- Запускается только вручную. После включения повторно выполняет код при
-- редактировании: не используйте для секретов, удаления файлов и других
-- опасных побочных эффектов. Это REPL, не запуск React/Vue-приложения.

local function clear_codi_output()
  local bufnr = vim.api.nvim_get_current_buf()
  -- Upstream сохраняет старые extmarks при смещении строк. Удаляем только
  -- подписи Codi: его namespace в текущей версии может пересекаться с чужим.
  for _, mark in ipairs(vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, { details = true })) do
    for _, text in ipairs(mark[4].virt_text or {}) do
      if text[2] == "CodiVirtualText" then
        vim.api.nvim_buf_del_extmark(bufnr, mark[4].ns_id, mark[1])
        break
      end
    end
  end
end

local function stop_codi()
  if vim.b.codi_enabled and vim.g["codi#virtual_text"] == 1 then
    for _, script in ipairs(vim.fn.getscriptinfo()) do
      if script.name:gsub("\\", "/"):match "/autoload/codi%.vim$" then
        -- В inline-режиме upstream не сохраняет output-буфер, из-за чего
        -- Codi! пропускает очистку. Временный скрытый буфер включает её,
        -- не затрагивая исходник. Используем внутренние функции только
        -- для этого обхода; файлы установленного плагина не меняем.
        local prefix = "<SNR>" .. script.sid .. "_"
        vim.fn[prefix .. "stop_job_for_buf"](vim.api.nvim_get_current_buf())
        local cleanup_buffer = vim.api.nvim_create_buf(false, true)
        vim.fn[prefix .. "let_codi"]("bufnr", cleanup_buffer)
        break
      end
    end
  end
  vim.cmd "Codi!"
end

local function toggle_codi()
  if vim.b.codi_enabled then
    stop_codi()
  else
    vim.cmd "Codi"
  end
end

---@type LazySpec
return {
  "metakirby5/codi.vim",
  cmd = { "Codi", "CodiNew", "CodiSelect", "CodiExpand", "CodiUpdate" },
  init = function()
    vim.g["codi#interpreters"] = vim.tbl_deep_extend("force", vim.g["codi#interpreters"] or {}, {
      python = { bin = { "python3", "-q" } },
      -- Node.js 24 использует "| " для продолжения многострочного ввода;
      -- старые версии — "... ". Без обоих вариантов Codi не завершает вывод.
      javascript = { prompt = [[^\(>\|\.\.\.\+\|[|]\) ]] },
    })
  end,
  config = function()
    local target_window
    local group = vim.api.nvim_create_augroup("CodiKeepTargetWindow", { clear = true })

    -- Codi executes `wincmd p` even when virtual text creates no output split.
    -- Restore the source window before its first update reads buffer-local state.
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodiEnterPre",
      callback = function()
        if vim.g["codi#virtual_text"] == 1 then target_window = vim.api.nvim_get_current_win() end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodiUpdatePre",
      callback = function()
        local window = target_window
        target_window = nil
        if window and vim.api.nvim_win_is_valid(window) then vim.api.nvim_set_current_win(window) end
        if vim.g["codi#virtual_text"] == 1 then clear_codi_output() end
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodiEnterPost",
      callback = function()
        vim.b.codi_enabled = true
        vim.cmd "redrawstatus"
      end,
    })
    vim.api.nvim_create_autocmd("User", {
      group = group,
      pattern = "CodiLeavePost",
      callback = function()
        vim.b.codi_enabled = false
        vim.cmd "redrawstatus"
      end,
    })
  end,
  keys = {
    { "<leader>j", desc = "Codi: черновик" },
    { "<leader>jj", "<cmd>CodiNew javascript<cr>", desc = "Codi: черновик JavaScript" },
    { "<leader>jp", "<cmd>CodiNew python<cr>", desc = "Codi: черновик Python" },
    { "<leader>js", "<cmd>CodiSelect<cr>", desc = "Codi: выбрать язык" },
    { "<leader>jt", toggle_codi, desc = "Codi: включить / выключить буфер" },
    { "<leader>ju", "<cmd>CodiUpdate<cr>", desc = "Codi: пересчитать" },
    { "<leader>je", "<cmd>CodiExpand<cr>", desc = "Codi: развернуть результат" },
    { "<leader>jq", stop_codi, desc = "Codi: выключить" },
    { "<leader>jh", "<cmd>help codi<cr>", desc = "Codi: справка" },
  },
}
