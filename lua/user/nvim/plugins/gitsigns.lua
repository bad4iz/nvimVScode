--[[
=====================================================================
                          GITSIGNS
=====================================================================
Git интеграция: знаки изменений, blame, hunk операции.

Показывает в колонке знаков:
  │  - добавленные строки (зелёный)
  │  - изменённые строки (жёлтый)
  _  - удалённые строки (красный)

Горячие клавиши:
  ]h          - следующий hunk (изменение)
  [h          - предыдущий hunk
  <leader>hs  - stage hunk (добавить в индекс)
  <leader>hr  - reset hunk (отменить изменения)
  <leader>hS  - stage весь буфер
  <leader>hR  - reset весь буфер
  <leader>hu  - undo stage hunk
  <leader>hp  - preview hunk
  <leader>hb  - blame строки
  <leader>hB  - blame буфера
  <leader>hd  - diff текущего файла
  <leader>hD  - diff против HEAD

GitHub: https://github.com/lewis6991/gitsigns.nvim
=====================================================================
--]]

return {
  "lewis6991/gitsigns.nvim",
  event = { "BufReadPost", "BufNewFile", "BufWritePre" },
  
  opts = {
    -- ═══════════════════════════════════════════════════════════════
    -- ЗНАКИ В КОЛОНКЕ
    -- ═══════════════════════════════════════════════════════════════
    signs = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
      untracked = { text = "┆" },
    },
    
    -- Знаки для staged изменений
    signs_staged = {
      add = { text = "│" },
      change = { text = "│" },
      delete = { text = "_" },
      topdelete = { text = "‾" },
      changedelete = { text = "~" },
    },
    
    -- Знаки в колонке номеров строк
    signs_staged_enable = true,
    signcolumn = true,
    numhl = false,
    linehl = false,
    word_diff = false,
    
    -- ═══════════════════════════════════════════════════════════════
    -- АВТООБНОВЛЕНИЕ
    -- ═══════════════════════════════════════════════════════════════
    watch_gitdir = {
      follow_files = true,
    },
    auto_attach = true,
    attach_to_untracked = true,
    
    -- ═══════════════════════════════════════════════════════════════
    -- BLAME
    -- ═══════════════════════════════════════════════════════════════
    current_line_blame = false, -- Включить через <leader>tb
    current_line_blame_opts = {
      virt_text = true,
      virt_text_pos = "eol",
      delay = 500,
      ignore_whitespace = true,
    },
    current_line_blame_formatter = "<author>, <author_time:%d.%m.%Y> - <summary>",
    
    -- ═══════════════════════════════════════════════════════════════
    -- ПРЕВЬЮ
    -- ═══════════════════════════════════════════════════════════════
    preview_config = {
      border = "rounded",
      style = "minimal",
      relative = "cursor",
      row = 0,
      col = 1,
    },
    
    -- ═══════════════════════════════════════════════════════════════
    -- ГОРЯЧИЕ КЛАВИШИ
    -- ═══════════════════════════════════════════════════════════════
    on_attach = function(bufnr)
      local gs = package.loaded.gitsigns
      
      local function map(mode, l, r, opts)
        opts = opts or {}
        opts.buffer = bufnr
        vim.keymap.set(mode, l, r, opts)
      end
      
      -- Навигация по hunk'ам
      map("n", "]h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { desc = "Следующий hunk" })
      
      map("n", "[h", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, { desc = "Предыдущий hunk" })
      
      -- Действия с hunk'ами
      map("n", "<leader>hs", gs.stage_hunk, { desc = "Stage hunk" })
      map("n", "<leader>hr", gs.reset_hunk, { desc = "Reset hunk" })
      
      map("v", "<leader>hs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage hunk" })
      
      map("v", "<leader>hr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset hunk" })
      
      map("n", "<leader>hS", gs.stage_buffer, { desc = "Stage буфер" })
      map("n", "<leader>hR", gs.reset_buffer, { desc = "Reset буфер" })
      map("n", "<leader>hu", gs.undo_stage_hunk, { desc = "Undo stage hunk" })
      map("n", "<leader>hp", gs.preview_hunk, { desc = "Preview hunk" })
      
      -- Blame
      map("n", "<leader>hb", function()
        gs.blame_line({ full = true })
      end, { desc = "Blame строки" })
      
      map("n", "<leader>hB", function()
        gs.blame()
      end, { desc = "Blame буфера" })
      
      -- Diff
      map("n", "<leader>hd", gs.diffthis, { desc = "Diff" })
      map("n", "<leader>hD", function()
        gs.diffthis("~")
      end, { desc = "Diff против HEAD" })
      
      -- Toggles
      map("n", "<leader>tb", gs.toggle_current_line_blame, { desc = "Toggle blame строки" })
      map("n", "<leader>td", gs.toggle_deleted, { desc = "Toggle удалённые строки" })
      
      -- Текстовый объект для hunk
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Hunk (inner)" })
    end,
  },
}
