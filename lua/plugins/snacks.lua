-- В picker: ,o добавляет выбранные файлы в вопрос OpenCode.
return {
  "folke/snacks.nvim",
  opts = {
    picker = {
      win = {
        input = {
          keys = {
            ["<LocalLeader>o"] = { "opencode_send", mode = { "n", "i" } },
          },
        },
      },
      actions = {
        opencode_send = function(picker)
          if not picker then return end

          local opencode = require "opencode"
          local files = {}
          for _, item in ipairs(picker:selected { fallback = true }) do
            if item.file then
              files[#files + 1] = opencode.format {
                path = require("snacks").picker.util.path(item),
                from = item.pos,
                to = item.end_pos,
              }
            end
          end

          if #files == 0 then return end
          picker:close()
          opencode.ask(table.concat(files, ", ") .. " ")
        end,
      },
    },
  },
}
