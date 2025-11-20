-- wezterm.lua

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

----------------------------------------------------------------------
-- 1. 基本設定 / パフォーマンス
----------------------------------------------------------------------

-- color scheme
config.color_scheme = "iceberg-dark"

-- opacity
config.window_background_opacity = 0.9

-- Leader Key (Prefix C-w)
config.leader = { key = "w", mods = "CTRL" }

-- クリップボード連携の安定化
config.enable_kitty_graphics = true

-- for wsl
config.default_domain = "WSL:Ubuntu"

----------------------------------------------------------------------
-- 2. キーバインド
----------------------------------------------------------------------
config.keys = {

	-- ペイン移動
	{ key = "j", mods = "ALT", action = act.ActivatePaneDirection("Left") },
	{ key = "k", mods = "ALT", action = act.ActivatePaneDirection("Down") },
	{ key = "i", mods = "ALT", action = act.ActivatePaneDirection("Up") },
	{ key = "l", mods = "ALT", action = act.ActivatePaneDirection("Right") },

	-- Tab移動
	{ key = "n", mods = "ALT", action = act.MoveTabRelative(1) },
	{ key = "p", mods = "ALT", action = act.MoveTabRelative(-1) },

	-- Tab作成
	{ key = "n", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },

	-- ペイン分割
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- ペイン/タブ強制終了
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "X", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },

	-- コピペ
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },

	-- 設定リロード
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
}

return config
