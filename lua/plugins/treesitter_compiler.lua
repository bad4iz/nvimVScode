---@type LazySpec
return {
  {
    "nvim-treesitter/nvim-treesitter",
    init = function()
      local mingw_bin = vim.fn.expand "~/scoop/apps/mingw/current/bin"
      local gcc = mingw_bin .. "/gcc.exe"
      local gxx = mingw_bin .. "/g++.exe"

      if vim.fn.executable(gcc) == 1 then
        vim.env.PATH = mingw_bin .. ";" .. vim.env.PATH
        vim.env.CC = gcc
        vim.env.CXX = gxx
      elseif vim.fn.executable "gcc" == 1 then
        vim.env.CC = "gcc"
        vim.env.CXX = "g++"
      end
    end,
    opts = function()
      local ok, install = pcall(require, "nvim-treesitter.install")
      if ok then
        local gcc = vim.fn.expand "~/scoop/apps/mingw/current/bin/gcc.exe"
        install.compilers = { gcc, "gcc", "clang", "cl" }
      end
    end,
  },
}
