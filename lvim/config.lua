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

-- keymappings [view all the defaults by pressing <leader>Lk]
lvim.leader = ","

-- NvimTree setup
lvim.keys.normal_mode["<leader>ne"] = ":NvimTreeFindFile<CR>"

-- Telescope setup
lvim.builtin.which_key.mappings["f"] = { "<cmd>Telescope git_files<CR>", "Find File" }
-- Map Ctrl + P to open Telescope find files
lvim.keys.normal_mode["<C-p>"] = ":Telescope git_files<CR>"

-- Neotest key mappings
lvim.keys.normal_mode["t<C-n>"] = ":lua require('neotest').run.run()<CR>"
lvim.keys.normal_mode["t<C-f>"] = ":lua require('neotest').run.run(vim.fn.expand('%'))<CR>"
lvim.keys.normal_mode["t<C-s>"] = ":lua require('neotest').run.run({suite = true})<CR>"
lvim.keys.normal_mode["t<C-l>"] = ":lua require('neotest').run.run_last()<CR>"
lvim.keys.normal_mode["t<C-g>"] = ":lua require('neotest').run.run_last({strategy = 'neotest-strategy'})<CR>"
lvim.keys.normal_mode["<leader>ts"] = ":lua require('neotest').summary.toggle()<CR>"
lvim.keys.normal_mode["<leader>to"] = ":lua require('neotest').output.open()<CR>"

lvim.plugins = {
  { "EdenEast/nightfox.nvim" },
  {
    "nvim-neotest/neotest",
    dependencies = {
      "zidhuss/neotest-minitest",
      "olimorris/neotest-rspec",
      'nvim-neotest/neotest-jest',
    },
    config = function()
      require("neotest").setup({
        adapters = {
          require("neotest-rspec"),
          require("neotest-minitest"),
          require('neotest-jest')({
            jestCommand = "npm test --",
            jestConfigFile = "jest.config.js",
            env = { CI = true },
            cwd = function(path)
              return vim.fn.getcwd()
            end,
          })
        },
      })
    end
  },
 {
    "zbirenbaum/copilot.lua",
    event = { "VimEnter" },
    config = function()
      vim.defer_fn(function()
        require("copilot").setup {
          plugin_manager_path = os.getenv "LUNARVIM_RUNTIME_DIR" .. "/site/pack/packer",
        }
      end, 100)
    end,
    },
    {
      "zbirenbaum/copilot-cmp",
      after = { "copilot.lua" },
      config = function()
        require("copilot_cmp").setup()
      end,
    },
}
