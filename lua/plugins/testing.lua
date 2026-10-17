---@type LazySpec
return {
  {
    "nvim-neotest/neotest",
    dependencies = { "marilari88/neotest-vitest" },
    opts = function(_, opts)
      opts.adapters = opts.adapters or {}
      table.insert(opts.adapters, require "neotest-vitest")
    end,
  },
  {
    "AstroNvim/astrocore",
    opts = {
      mappings = {
        n = {
          ["<Leader>TCr"] = {
            function()
              require("neotest").run.run {
                vim.fn.getcwd(),
                extra_args = {
                  "--coverage.enabled",
                  "--coverage.reporter=lcov",
                  "--coverage.reportOnFailure",
                },
              }
            end,
            desc = "Run tests with coverage",
          },
          ["<Leader>Ts"] = {
            function() require("neotest").run.stop(vim.fn.expand "%:p") end,
            desc = "Stop tests in file",
          },
        },
      },
    },
  },
}
