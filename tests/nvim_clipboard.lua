local options_file = assert(vim.env.OPTIONS_FILE)
local scenario = assert(vim.env.CLIPBOARD_SCENARIO)
local copies, reads = {}, 0
if scenario == "ssh_connection" or scenario == "ssh_tty" or scenario == "ssh_herdr" then
  package.loaded["vim.ui.clipboard.osc52"] = {
    copy = function(register)
      return function(lines) copies[#copies + 1] = register .. ":" .. table.concat(lines, "\n") end
    end,
  }
end

vim.g.clipboard = {
  name = "test-provider",
  copy = {
    ["+"] = function(lines) copies[#copies + 1] = table.concat(lines, "\n") end,
    ["*"] = function() end,
  },
  paste = {
    ["+"] = function() reads = reads + 1; return { "external clipboard" }, "V" end,
    ["*"] = function() return {}, "v" end,
  },
  cache_enabled = 0,
}

dofile(options_file)
local remote = scenario == "ssh_connection" or scenario == "ssh_tty" or scenario == "ssh_herdr"
assert((vim.o.clipboard == "") == remote, scenario .. ": clipboard option=" .. vim.o.clipboard)

vim.api.nvim_buf_set_lines(0, 0, -1, false, { "seed" })
vim.api.nvim_win_set_cursor(0, { 1, 0 })
vim.cmd("normal! yy")
if remote then
  assert(copies[#copies] == "+:seed", scenario .. ": remote yank not forwarded")
  for _, command in ipairs({ "p", "P" }) do
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "seed" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    local before = reads
    vim.cmd("normal! " .. command)
    assert(reads == before, scenario .. ": remote " .. command .. " queried provider")
    assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n") == "seed\nseed")
  end
else
  assert(#copies > 0, scenario .. ": local yank did not use clipboard provider")
  for _, command in ipairs({ "p", "P" }) do
    reads = 0
    vim.api.nvim_buf_set_lines(0, 0, -1, false, { "seed" })
    vim.api.nvim_win_set_cursor(0, { 1, 0 })
    vim.cmd("normal! " .. command)
    assert(reads > 0, scenario .. ": " .. command .. " did not read external clipboard")
    assert(table.concat(vim.api.nvim_buf_get_lines(0, 0, -1, false), "\n"):find("external clipboard", 1, true))
  end
end
