local function disbled_plugins(plugin_names)
  local result = {}
  for _, plugin_name in ipairs(plugin_names) do
    table.insert(result, { plugin_name, enabled = false })
  end
  return result
end

return disbled_plugins({
  "folke/tokyonight.nvim",
  "catppuccin/nvim ",
  "echasnovski/mini.pairs",
  "echasnovski/mini.ai",
})
