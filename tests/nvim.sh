#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
options_file="$repo_dir/nvim/nvim/lua/config/options.lua"

env -i HOME="$HOME" PATH="$PATH" OPTIONS_FILE="$options_file" \
  nvim --headless -u NONE \
  '+lua local function check(value) if not value then vim.cmd("cquit 1") end end; dofile(vim.env.OPTIONS_FILE); check(vim.o.clipboard == "unnamedplus"); check(vim.g.clipboard == nil); vim.cmd("qa!")'

env -i HOME="$HOME" PATH="$PATH" OPTIONS_FILE="$options_file" \
  SSH_CONNECTION='127.0.0.1 22 127.0.0.1 22' \
  nvim --headless -u NONE \
  '+lua local function check(value) if not value then vim.cmd("cquit 1") end end; package.loaded["vim.ui.clipboard.osc52"] = { copy = function(register) return function(lines) vim.g.osc52_register = register; vim.g.osc52_contents = table.concat(lines, "\\n") end end }; dofile(vim.env.OPTIONS_FILE); check(vim.o.clipboard == ""); check(vim.g.clipboard == nil); vim.api.nvim_buf_set_lines(0, 0, -1, false, { "clipboard test" }); vim.cmd("normal! gg0yy"); check(vim.g.osc52_register == "+"); check(vim.g.osc52_contents == "clipboard test"); vim.cmd("normal! p"); check(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\\n") == "clipboard test\\nclipboard test"); vim.cmd("qa!")'

grep -Fqx '  or (vim.env.HERDR_PANE_ID ~= nil and vim.fn.has("macunix") == 0)' "$options_file"

printf '%s\n' 'nvim clipboard tests passed'
