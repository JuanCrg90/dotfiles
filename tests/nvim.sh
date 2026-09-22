#!/bin/sh

set -eu

repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
options_file="$repo_dir/nvim/nvim/lua/config/options.lua"

assert_clipboard() {
  expected_clipboard=$1
  shift

  env -i HOME="$HOME" PATH="$PATH" OPTIONS_FILE="$options_file" EXPECTED_CLIPBOARD="$expected_clipboard" "$@" \
    nvim --headless -u NONE \
    '+lua dofile(vim.env.OPTIONS_FILE); local expected = vim.env.EXPECTED_CLIPBOARD == "" and nil or vim.env.EXPECTED_CLIPBOARD; assert(vim.o.clipboard == "unnamedplus"); assert(vim.g.clipboard == expected)' \
    +qa
}

assert_clipboard ''
assert_clipboard 'osc52' SSH_CONNECTION='127.0.0.1 22 127.0.0.1 22'

grep -Fqx '  or (vim.env.HERDR_PANE_ID ~= nil and vim.fn.has("macunix") == 0)' "$options_file"

printf '%s\n' 'nvim clipboard tests passed'
