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

-- FIXME _G convert to M
_G.keymap = vim.keymap.set
_G.delmap = vim.keymap.del

function _G.keymap_silent(mode, lhs, rhs, desc)
  keymap(mode, lhs, rhs, keymap_options_silent(desc))
end

function _G.keymap_silent_expr(mode, lhs, rhs, desc)
  keymap(mode, lhs, rhs, keymap_options_silent_expr(desc))
end

function _G.list_extend_with_nil(target_list, append_list)
  target_list = target_list or {}
  vim.list_extend(target_list, append_list)
end

function M.list_append_with_nil(target_list, key, value)
  target_list = target_list or {}
  target_list[key] = value
  return target_list
end

return M
