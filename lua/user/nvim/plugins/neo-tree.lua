--[[
=====================================================================
                          NEO-TREE
=====================================================================
Современный файловый менеджер для Neovim.

Горячие клавиши:
  <leader>e   - открыть/закрыть Neo-tree (файлы)
  <leader>E   - фокус на Neo-tree
  <leader>be  - буферы в Neo-tree
  <leader>ge  - Git статус в Neo-tree

Навигация в Neo-tree:
  j/k         - вверх/вниз
  h           - закрыть папку / перейти к родителю
  l           - открыть папку / файл
  <CR>        - открыть файл
  <Tab>       - превью файла
  a           - создать файл/папку
  d           - удалить
  r           - переименовать
  c           - копировать
  m           - переместить
  y           - копировать имя
  Y           - копировать путь
  ?           - справка

GitHub: https://github.com/nvim-neo-tree/neo-tree.nvim
=====================================================================
--]]

return {
  "nvim-neo-tree/neo-tree.nvim",
  branch = "v3.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    "nvim-tree/nvim-web-devicons",
    "MunifTanjim/nui.nvim",
  },
  
  cmd = "Neotree",
  
  -- Автоматическое открытие при запуске с директорией
  init = function()
    -- Если neovim открыт с директорией - открываем neo-tree
    vim.api.nvim_create_autocmd("BufEnter", {
      group = vim.api.nvim_create_augroup("NeoTreeInit", { clear = true }),
      callback = function()
        local f = vim.fn.expand("%:p")
        if vim.fn.isdirectory(f) ~= 0 then
          vim.cmd("Neotree current dir=" .. f)
          vim.api.nvim_clear_autocmds({ group = "NeoTreeInit" })
        end
      end,
    })
  end,
  
  opts = {
    -- Закрывать neo-tree при открытии файла
    close_if_last_window = true,
    
    -- Отключить устаревшие команды
    enable_git_status = true,
    enable_diagnostics = true,
    
    -- Отступы
    indent = {
      indent_size = 2,
      padding = 1,
    },
    
    -- Иконки
    default_component_configs = {
      indent = {
        with_expanders = true,
        expander_collapsed = "",
        expander_expanded = "",
        expander_highlight = "NeoTreeExpander",
      },
      icon = {
        folder_closed = "",
        folder_open = "",
        folder_empty = "",
        default = "",
      },
      modified = {
        symbol = "●",
        highlight = "NeoTreeModified",
      },
      name = {
        trailing_slash = false,
        use_git_status_colors = true,
        highlight = "NeoTreeFileName",
      },
      git_status = {
        symbols = {
          added     = "",
          modified  = "",
          deleted   = "",
          renamed   = "➜",
          untracked = "★",
          ignored   = "◌",
          unstaged  = "✗",
          staged    = "✓",
          conflict  = "",
        },
      },
    },
    
    -- Настройки окна
    window = {
      position = "left",
      width = 35,
      mapping_options = {
        noremap = true,
        nowait = true,
      },
      mappings = {
        ["<space>"] = false, -- Отключаем пробел (наш лидер)
        ["<2-LeftMouse>"] = "open",
        ["<cr>"] = "open",
        ["<esc>"] = "cancel",
        ["P"] = { "toggle_preview", config = { use_float = true, use_image_nvim = true } },
        ["l"] = "open",
        ["h"] = "close_node",
        ["<Tab>"] = "toggle_preview",
        ["S"] = "open_split",
        ["s"] = "open_vsplit",
        ["t"] = "open_tabnew",
        ["w"] = "open_with_window_picker",
        ["C"] = "close_node",
        ["z"] = "close_all_nodes",
        ["Z"] = "expand_all_nodes",
        ["a"] = {
          "add",
          config = {
            show_path = "relative", -- "none", "relative", "absolute"
          },
        },
        ["A"] = "add_directory",
        ["d"] = "delete",
        ["r"] = "rename",
        ["y"] = "copy_to_clipboard",
        ["x"] = "cut_to_clipboard",
        ["p"] = "paste_from_clipboard",
        ["c"] = "copy",
        ["m"] = "move",
        ["q"] = "close_window",
        ["R"] = "refresh",
        ["?"] = "show_help",
        ["<"] = "prev_source",
        [">"] = "next_source",
        ["i"] = "show_file_details",
      },
    },
    
    -- Файловая система
    filesystem = {
      filtered_items = {
        visible = false,
        hide_dotfiles = false,
        hide_gitignored = false,
        hide_by_name = {
          ".git",
          "node_modules",
        },
        always_show = {
          ".gitignored",
          ".env",
        },
        never_show = {
          ".DS_Store",
          "thumbs.db",
        },
      },
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      group_empty_dirs = true,
      hijack_netrw_behavior = "open_default",
      use_libuv_file_watcher = true,
      window = {
        mappings = {
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["H"] = "toggle_hidden",
          ["/"] = "fuzzy_finder",
          ["D"] = "fuzzy_finder_directory",
          ["#"] = "fuzzy_sorter",
          ["f"] = "filter_on_submit",
          ["<c-x>"] = "clear_filter",
          ["[g"] = "prev_git_modified",
          ["]g"] = "next_git_modified",
          ["o"] = { "show_help", nowait = false, config = { title = "Сортировка", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["og"] = { "order_by_git_status", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
    
    -- Буферы
    buffers = {
      follow_current_file = {
        enabled = true,
        leave_dirs_open = true,
      },
      group_empty_dirs = true,
      show_unloaded = true,
      window = {
        mappings = {
          ["bd"] = "buffer_delete",
          ["<bs>"] = "navigate_up",
          ["."] = "set_root",
          ["o"] = { "show_help", nowait = false, config = { title = "Сортировка", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
    
    -- Git статус
    git_status = {
      window = {
        position = "float",
        mappings = {
          ["A"]  = "git_add_all",
          ["gu"] = "git_unstage_file",
          ["ga"] = "git_add_file",
          ["gr"] = "git_revert_file",
          ["gc"] = "git_commit",
          ["gp"] = "git_push",
          ["gg"] = "git_commit_and_push",
          ["o"] = { "show_help", nowait = false, config = { title = "Сортировка", prefix_key = "o" } },
          ["oc"] = { "order_by_created", nowait = false },
          ["od"] = { "order_by_diagnostics", nowait = false },
          ["om"] = { "order_by_modified", nowait = false },
          ["on"] = { "order_by_name", nowait = false },
          ["os"] = { "order_by_size", nowait = false },
          ["ot"] = { "order_by_type", nowait = false },
        },
      },
    },
    
    -- Плавающее окно для источников
    source_selector = {
      winbar = true,
      statusline = false,
      sources = {
        { source = "filesystem", display_name = " 󰉓 Файлы " },
        { source = "buffers", display_name = " 󰈙 Буферы " },
        { source = "git_status", display_name = " 󰊢 Git " },
      },
    },
    
    -- Всплывающие границы
    popup_border_style = "rounded",
  },
  
  -- Горячие клавиши
  keys = {
    { "<leader>e", "<cmd>Neotree toggle<cr>", desc = "Файловый менеджер (toggle)" },
    { "<leader>E", "<cmd>Neotree focus<cr>", desc = "Фокус на Neo-tree" },
    { "<leader>be", "<cmd>Neotree toggle show buffers right<cr>", desc = "Буферы в Neo-tree" },
    { "<leader>ge", "<cmd>Neotree float git_status<cr>", desc = "Git статус в Neo-tree" },
  },
}
