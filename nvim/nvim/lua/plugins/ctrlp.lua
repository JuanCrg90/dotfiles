return {
  "ibhagwan/fzf-lua",
  keys = {
    {
      "<C-p>",
      function()
        -- open the fuzzy file picker in your project root
        require("fzf-lua").files({
          cwd = require("lazyvim.util").root(), -- same root-detection LazyVim uses
        })
      end,
      desc = "Quick-open files (fzf-lua)",
    },
  },
}
