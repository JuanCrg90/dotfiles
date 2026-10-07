#!/bin/sh
set -eu
repo_dir=$(CDPATH= cd "$(dirname "$0")/.." && pwd)
options_file="$repo_dir/nvim/nvim/lua/config/options.lua"
test_file="$repo_dir/tests/nvim_clipboard.lua"
run_test() {
  scenario=$1
  shift
  env -i HOME="$HOME" PATH="$PATH" OPTIONS_FILE="$options_file" CLIPBOARD_SCENARIO="$scenario" "$@" nvim --headless -u NONE -l "$test_file"
}
run_test local
run_test herdr HERDR_PANE_ID=test-pane
run_test ssh_connection SSH_CONNECTION='127.0.0.1 22 127.0.0.1 22'
run_test ssh_tty SSH_TTY=/dev/pts/1
run_test ssh_herdr SSH_CONNECTION='127.0.0.1 22 127.0.0.1 22' HERDR_PANE_ID=test-pane
printf '%s\n' 'nvim clipboard tests passed'
