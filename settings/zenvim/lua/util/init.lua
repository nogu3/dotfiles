local function silent(desc)
  return {
    silent = true,
    noremap = true,
    desc = desc,
  }
end

local function keymap_options_silent(desc)
  return {
    silent = true,
    noremap = true,
    desc = desc,
  }
end

local function keymap_options_silent_expr(desc)
  local silent_option = silent(desc)
  silent_option["expr"] = true
  return silent_option
end

local M = {}

M.keymap = vim.keymap.set
M.delmap = vim.keymap.del
-- FIXME load timing
-- M.async = require("plenary.async")

function M.keymap_silent(mode, lhs, rhs, desc)
  M.keymap(mode, lhs, rhs, keymap_options_silent(desc))
end

function M.keymap_silent_expr(mode, lhs, rhs, desc)
  M.keymap(mode, lhs, rhs, keymap_options_silent_expr(desc))
end

function M.list_extend_with_nil(target_list, append_list)
  target_list = target_list or {}
  vim.list_extend(target_list, append_list)
end

function M.list_append_with_nil(target_list, key, value)
  target_list = target_list or {}
  target_list[key] = value
  return target_list
end

function M.get_relative_path()
  return vim.fn.expand("%")
end

function M.get_line_number_on_cursol()
  return vim.api.nvim_win_get_cursor(0)[1]
end

function M.set_register_with_print_message(register, content, message)
  vim.fn.setreg(register, content)
  print(message)
end

function M.create_augroup(name)
  return vim.api.nvim_create_augroup("zenvim_" .. name, { clear = true })
end

function M.set_auto_command(event, group_name, callback)
  vim.api.nvim_create_autocmd(event, {
    group = M.create_augroup(group_name),
    callback = callback,
  })
end

function M.event_lazy_file()
  return {
    "BufReadPost",
    "BufNewFile",
    "BufWritePre",
  }
end

return M
