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

-- codecompanion key mappings
-- Normal and Visual mode mappings for CodeCompanionActions
lvim.keys.normal_mode["<leader>aa"] = "<cmd>CodeCompanionActions<CR>"
lvim.keys.visual_mode["<leader>aa"] = "<cmd>CodeCompanionActions<CR>"

-- Toggle the CodeCompanionChat in Normal and Visual mode
lvim.keys.normal_mode["<leader>a"] = "<cmd>CodeCompanionChat Toggle<CR>"
lvim.keys.visual_mode["<leader>a"] = "<cmd>CodeCompanionChat Toggle<CR>"

-- Add selection to CodeCompanionChat in Visual mode
lvim.keys.visual_mode["ga"] = "<cmd>CodeCompanionChat Add<CR>"

-- Expand 'cc' into 'CodeCompanion' in the command line
vim.cmd([[cab cc CodeCompanion]])

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
            roles = { llm = "Morpheus", user = "JuanCrg90"},
            slash_commands = {
              ["buffer"] = {
                callback = "strategies.chat.slash_commands.buffer",
                description = "Insert open buffers",
                opts = {
                  contains_code = true,
                  provider = "telescope",
                }
              },
              ["file"] = {
                callback = "strategies.chat.slash_commands.file",
                description = "Insert current file",
                opts = {
                  contains_code = true,
                  provider = "telescope",
                }
              }
            },
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
        display = {
          chat = {
            show_settings = true,
          },
          action_palette = {
            width = 95,
            height = 10,
            prompt = "Prompt ",
            provider = "telescope",
            opts = {
              show_default_actions = true,
              show_default_prompt_library = true,
            },
          },
        },
        log_level = "DEBUG",
      }
    end,
  },
}
