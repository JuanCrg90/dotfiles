-- Read the docs: https://www.lunarvim.org/docs/configuration
-- Video Tutorials: https://www.youtube.com/watch?v=sFA9kX-Ud_c&list=PLhoH5vyxr6QqGu0i7tt_XoVK9v-KvZ3m6
-- Forum: https://www.reddit.com/r/lunarvim/
-- Discord: https://discord.com/invite/Xb9B4Ny

lvim.log.level = "warn"
lvim.format_on_save = false
lvim.lint_on_save = true
lvim.colorscheme = "nightfox"

vim.opt["relativenumber"] = true
vim.opt.directory = "~/.tmp//"

vim.cmd [[
augroup StripTrailingWhitespace
autocmd!
autocmd BufWritePre * :%s/\s\+$//e
augroup END
]]

-- Keymappings
lvim.leader = ","
lvim.keys.normal_mode["<leader>ne"] = ":NvimTreeFindFile<CR>"
lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope git_files<CR>", "Find File" }
lvim.keys.normal_mode["<C-p>"] = ":Telescope git_files<CR>"

-- vim-test configuration
vim.g["test#strategy"] = "neovim"
lvim.keys.normal_mode["t<C-n>"] = ":TestNearest<CR>"
lvim.keys.normal_mode["t<C-f>"] = ":TestFile<CR>"
lvim.keys.normal_mode["t<C-s>"] = ":TestSuite<CR>"
lvim.keys.normal_mode["t<C-l>"] = ":TestLast<CR>"
lvim.keys.normal_mode["t<C-g>"] = ":TestVisit<CR>"


lvim.plugins = {
  { "EdenEast/nightfox.nvim" },
  { "janko/vim-test" },
  {
    "olimorris/codecompanion.nvim",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = function()
      local adapter = "openai" -- Default adapter

      -- Detect if the system supports Ollama (e.g., M1/M2 Mac)
      if vim.fn.has("macunix") == 1 and vim.loop.os_uname().machine == "arm64" then
        adapter = "ollama"
      end

      return {
        strategies = {
          chat = {
            adapter = adapter,
          },
          inline = {
            adapter = adapter,
          },
          cmd = {
            adapter = adapter,
          },
        },
        adapters = {
          openai = function()
            return require("codecompanion.adapters").extend("openai", {
              env = {
                api_key = vim.fn.getenv("OPENAI_API_KEY"),
              },
            })
          end,
        },
        log_level = "DEBUG",
      }
    end,
  },
}

