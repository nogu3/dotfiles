-- Highlight on yank
Zenvim.set_auto_command("TextYankPost", "highlight_yank", function()
  vim.highlight.on_yank()
end)
