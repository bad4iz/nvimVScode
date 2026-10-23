-- Выдели русское имя или фразу: <leader>tc → camelCase, <leader>ts → snake_case.
-- Выделенный текст отправляется в Google Translate.
local function identifier_words(lines)
  local text = table.concat(lines, " ")
  text = text:gsub("(%l)(%u)", "%1 %2"):gsub("(%u)(%u%l)", "%1 %2")
  local words = {}
  for word in text:gmatch "[A-Za-z0-9]+" do
    words[#words + 1] = word:lower()
  end
  if #words == 0 then error "Translation did not produce an English identifier" end
  if words[1]:match "^%d" then words[1] = "_" .. words[1] end
  return words
end

return {
  "uga-rosa/translate.nvim",
  cmd = "Translate",
  keys = {
    {
      "<leader>tc",
      "<Cmd>Translate EN -source=RU -parse_before=trim,concat -parse_after=camel_case -output=replace<CR>",
      mode = "x",
      desc = "Перевести → camelCase",
    },
    {
      "<leader>ts",
      "<Cmd>Translate EN -source=RU -parse_before=trim,concat -parse_after=snake_case -output=replace<CR>",
      mode = "x",
      desc = "Перевести → snake_case",
    },
  },
  opts = {
    parse_after = {
      camel_case = {
        cmd = function(lines)
          local words = identifier_words(lines)
          for index = 2, #words do
            words[index] = words[index]:gsub("^%l", string.upper)
          end
          return { table.concat(words) }
        end,
      },
      snake_case = {
        cmd = function(lines) return { table.concat(identifier_words(lines), "_") } end,
      },
    },
  },
}
