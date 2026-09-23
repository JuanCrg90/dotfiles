-- Options are automatically loaded before lazy.nvim startup
-- Default options that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/options.lua
-- Add any additional options here

-- Send remote yanks to the local terminal clipboard with Neovim's native
-- OSC 52 copy callback. Do not configure the provider for paste: Herdr's
-- remote bridge may not answer OSC 52 read queries.
-- Source: https://neovim.io/doc/user/provider.html#clipboard-osc52
local remote_session = vim.fn.has("macunix") == 0
  and (vim.env.SSH_CONNECTION ~= nil or vim.env.SSH_TTY ~= nil or vim.env.HERDR_PANE_ID ~= nil)

if remote_session then
  local osc52_copy = require("vim.ui.clipboard.osc52").copy("+")

  vim.opt.clipboard = ""
  vim.api.nvim_create_autocmd("TextYankPost", {
    callback = function()
      if vim.v.event.operator == "y" then
        osc52_copy(vim.v.event.regcontents)
      end
    end,
  })
else
  vim.opt.clipboard = "unnamedplus"
end
