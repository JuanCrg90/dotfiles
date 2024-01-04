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
}
