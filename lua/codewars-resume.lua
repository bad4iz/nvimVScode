local M = {}

local function state_path() return vim.fn.stdpath "cache" .. "/codewars/last-kata.json" end

local function valid_state(state)
  return type(state) == "table"
    and type(state.slug) == "string"
    and state.slug:match "^[%w%-]+$"
    and type(state.lang) == "string"
    and state.lang:match "^[%w_%-]+$"
end

function M.remember(kata)
  if type(kata) ~= "table" then return end
  local state = { slug = kata.slug, lang = kata.lang }
  if not valid_state(state) then return end

  local ok, result = pcall(function()
    local path = state_path()
    vim.fn.mkdir(vim.fn.fnamemodify(path, ":h"), "p")
    return vim.fn.writefile({ vim.json.encode(state) }, path)
  end)
  if not ok or result ~= 0 then
    vim.notify("Codewars: не удалось запомнить последнюю кату", vim.log.levels.WARN)
  end
end

function M.resume()
  local path = state_path()
  if vim.fn.filereadable(path) == 0 then
    vim.notify(
      "Codewars: пока нет последней каты. Открой задачу из списка.",
      vim.log.levels.INFO
    )
    return
  end

  local ok, state = pcall(function() return vim.json.decode(table.concat(vim.fn.readfile(path), "\n")) end)
  if not ok or not valid_state(state) then
    vim.notify(
      "Codewars: запись последней каты повреждена. Открой задачу из списка.",
      vim.log.levels.WARN
    )
    return
  end

  require("codewars.command").train { _positional = { state.slug, state.lang } }
end

return M
