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
  ]h           - следующий hunk (изменение)
  [h           - предыдущий hunk
  <leader>ghs  - проиндексировать hunk
  <leader>ghr  - сбросить hunk
  <leader>ghS  - проиндексировать весь буфер
  <leader>ghR  - сбросить весь буфер
  <leader>ghu  - отменить индексацию hunk
  <leader>ghp  - просмотр hunk
  <leader>ghb  - blame строки
  <leader>ghB  - blame буфера
  <leader>ghd  - diff текущего файла
  <leader>ghD  - diff против HEAD
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
      
      -- Действия с hunk'ами (AstroNvim style: <leader>gh)
      map("n", "<leader>ghs", gs.stage_hunk, { desc = "Проиндексировать hunk" })
      map("n", "<leader>ghr", gs.reset_hunk, { desc = "Сбросить hunk" })

      map("v", "<leader>ghs", function()
        gs.stage_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Проиндексировать выделенный hunk" })

      map("v", "<leader>ghr", function()
        gs.reset_hunk({ vim.fn.line("."), vim.fn.line("v") })
      end, { desc = "Сбросить выделенный hunk" })

      map("n", "<leader>ghS", gs.stage_buffer, { desc = "Проиндексировать буфер" })
      map("n", "<leader>ghR", gs.reset_buffer, { desc = "Сбросить буфер" })
      map("n", "<leader>ghu", gs.undo_stage_hunk, { desc = "Отменить индексацию hunk" })
      map("n", "<leader>ghp", gs.preview_hunk, { desc = "Просмотр hunk" })

      -- Blame
      map("n", "<leader>ghb", function()
        gs.blame_line({ full = true })
      end, { desc = "Blame для строки" })

      map("n", "<leader>ghB", function()
        gs.blame()
      end, { desc = "Blame для буфера" })

      -- Diff
      map("n", "<leader>ghd", gs.diffthis, { desc = "Diff" })
      map("n", "<leader>ghD", function()
        gs.diffthis("~")
      end, { desc = "Diff против HEAD" })

      -- Переключатели
      map("n", "<leader>ug", gs.toggle_current_line_blame, { desc = "Переключить Git blame" })
      map("n", "<leader>uG", gs.toggle_deleted, { desc = "Переключить показ удалённых строк Git" })
      
      -- Текстовый объект для hunk
      map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", { desc = "Внутри hunk" })
    end,
  },
}
