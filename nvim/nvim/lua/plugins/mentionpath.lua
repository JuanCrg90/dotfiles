return {
  {
    "JuanCrg90/mentionpath.nvim",
    -- For local plugin development, uncomment the next line.
    -- dir = "~/Projects/mentionpath.nvim",
    ft = "markdown",
    dependencies = { "saghen/blink.cmp" },
    opts = {
      ui = {
        backend = "blink",
      },
      debug = {
        enabled = true,
      },
    },
  },
  {
    "saghen/blink.cmp",
    opts = function(_, opts)
      opts.sources = opts.sources or {}
      opts.sources.default = opts.sources.default or { "lsp", "path", "snippets", "buffer" }
      table.insert(opts.sources.default, 1, "mentionpath")

      opts.sources.providers = opts.sources.providers or {}
      opts.sources.providers.mentionpath = require("mentionpath").blink_provider()
    end,
  },
}
