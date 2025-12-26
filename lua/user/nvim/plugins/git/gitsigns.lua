--[[
=====================================================================
                          GITSIGNS
=====================================================================
Git интеграция: знаки изменений, blame, hunk операции.

Показывает в колонке знаков:
  │  - добавленные строки (зелёный)
  │  - изменённые строки (жёлтый)
  _  - удалённые строки (красный)

Горячие клавиши (AstroNvim style):
  <leader>gj   - следующий hunk (изменение)
  <leader>gk   - предыдущий hunk
  <leader>gs   - проиндексировать hunk (Stage)
  <leader>gr   - сбросить hunk (Reset)
  <leader>gS   - проиндексировать весь буфер (Stage Buffer)
  <leader>gR   - сбросить весь буфер (Reset Buffer)
  <leader>gu   - отменить индексацию hunk (Undo stage)
  <leader>gp   - просмотр hunk (Preview)
  <leader>gl   - blame строки (bLame)
  <leader>gd   - diff текущего файла (Diff)
  <leader>gD   - diff против кэша (Diff cached)
  <leader>ug   - переключить git blame
  <leader>uG   - переключить показ удалённых строк

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
      
      -- Навигация по hunk'ам (AstroNvim style: <leader>gj/gk)
      map("n", "<leader>gj", function()
        if vim.wo.diff then
          vim.cmd.normal({ "]c", bang = true })
        else
          gs.nav_hunk("next")
        end
      end, { desc = "Next Hunk" })

      map("n", "<leader>gk", function()
        if vim.wo.diff then
          vim.cmd.normal({ "[c", bang = true })
        else
          gs.nav_hunk("prev")
        end
      end, { desc = "Previous Hunk" })

      -- Действия с hunk'ами (AstroNvim style: <leader>g*)
      map("n", "<leader>gs", gs.stage_hunk, { desc = "Stage Hunk" })
      map("n", "<leader>gr", gs.reset_hunk, { desc = "Reset Hunk" })

      map("v", "<leader>gs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Stage Hunk (visual)" })

      map("v", "<leader>gr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Reset Hunk (visual)" })

      map("n", "<leader>gS", gs.stage_buffer, { desc = "Stage Buffer" })
      map("n", "<leader>gR", gs.reset_buffer, { desc = "Reset Buffer" })
      map("n", "<leader>gu", gs.undo_stage_hunk, { desc = "Undo Stage Hunk" })
      map("n", "<leader>gp", gs.preview_hunk, { desc = "Preview Hunk" })

      -- Blame (AstroNvim style: <leader>gl)
      map("n", "<leader>gl", function()
        gs.blame_line({ full = true })
      end, { desc = "Git Blame Line" })

      -- Diff (AstroNvim style: <leader>gd)
      map("n", "<leader>gd", gs.diffthis, { desc = "Git Diff" })
      map("n", "<leader>gD", function()
        gs.diffthis("~")
      end, { desc = "Git Diff (cached)" })

      -- Переключатели
      map("n", "<leader>ug", gs.toggle_current_line_blame, { desc = "Переключить Git blame" })
      map("n", "<leader>uG", gs.toggle_deleted, { desc = "Переключить показ удалённых строк Git" })
      
      -- Текстовый объект для hunk
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Внутри hunk" })
    end,
  },
}
