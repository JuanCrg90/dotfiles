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
    opts = {
      strategies = {
        -- Change the default chat adapter
        chat = {
          adapter = "ollama",
          slash_commands = {
            ["file"] = {
              callback = "strategies.chat.slash_commands.file",
              description = "Select a file using Telescope",
              opts = {
                provider = "telescope", -- Other options include 'default', 'mini_pick', 'fzf_lua'
                contains_code = true,
              },
            },
          },
        },
        inline = {
          adapter = "ollama",
        },
        cmd = {
          adapter = "ollama"
        }
      },
      opts = {
        -- Set debug logging
        log_level = "DEBUG",
      },
    },
  },
}
