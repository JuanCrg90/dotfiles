-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Neovim's native OSC 52 provider bridges yanks from remote Linux panes to
-- the terminal's local clipboard. Keep native clipboard providers on macOS.
-- Source: https://neovim.io/doc/user/provider.html#clipboard-osc52
local remote_session = vim.env.SSH_CONNECTION ~= nil
  or vim.env.SSH_TTY ~= nil
  or (vim.env.HERDR_PANE_ID ~= nil and vim.fn.has("macunix") == 0)

if remote_session then
  vim.g.clipboard = "osc52"
end

vim.opt.clipboard = "unnamedplus"
