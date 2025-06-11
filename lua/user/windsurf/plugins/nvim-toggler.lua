return {
  "nguyenvukhang/nvim-toggler",
  event = { "BufReadPost", "BufNewFile" },
  config = function()
    require("nvim-toggler").setup {
      remove_default_keybinds = true,
      inverses = {
        ["true"] = "false",
        ["True"] = "False",
        ["TRUE"] = "FALSE",
        ["yes"] = "no",
        ["Yes"] = "No",
        ["YES"] = "NO",
        ["on"] = "off",
        ["On"] = "Off",
        ["ON"] = "OFF",
        ["вкл"] = "выкл",
        ["Вкл"] = "Выкл",
        ["ВКЛ"] = "ВЫКЛ",
        ["+"] = "-",
        ["=="] = "!=",
        ["<"] = ">",
        ["<="] = ">=",
        ["&&"] = "||",
        ["and"] = "or",
        ["AND"] = "OR",
        ["And"] = "Or",
      },
    }
    
    -- Set up keybindings
    vim.keymap.set({ "n", "v" }, "<Leader>i", function() 
      require("nvim-toggler").toggle() 
    end, { desc = "Toggle CursorWord" })
  end,
}