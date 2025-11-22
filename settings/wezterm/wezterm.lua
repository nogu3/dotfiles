-- wezterm.lua

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

----------------------------------------------------------------------
-- OS判定
----------------------------------------------------------------------
local function is_windows()
	return wezterm.target_os == "Windows"
end

local function is_linux()
	return wezterm.target_os == "Linux"
end

local function is_mac()
	return wezterm.target_os == "macOS"
end

----------------------------------------------------------------------
-- 1. 基本設定 / パフォーマンス
----------------------------------------------------------------------

-- color scheme
config.color_scheme = "iceberg-dark"

-- font size
if is_mac() then
	config.font_size = 14
else
	config.font_size = 12
end

-- opacity
config.window_background_opacity = 0.9

-- Leader Key (Prefix C-w)
config.leader = { key = "w", mods = "CTRL" }

-- クリップボード連携の安定化
config.enable_kitty_graphics = true

-- for wsl
if is_windows() then
	config.default_domain = "WSL:Ubuntu"
end

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
	{ key = "n", mods = "ALT", action = act.ActivateTabRelative(1) },
	{ key = "p", mods = "ALT", action = act.ActivateTabRelative(-1) },

	-- Tab作成
	{ key = "n", mods = "LEADER", action = act.SpawnTab("DefaultDomain") },

	-- ペイン分割
	{ key = "\\", mods = "LEADER", action = act.SplitHorizontal({ domain = "CurrentPaneDomain" }) },
	{ key = "-", mods = "LEADER", action = act.SplitVertical({ domain = "CurrentPaneDomain" }) },

	-- ペイン/タブ強制終了
	{ key = "x", mods = "LEADER", action = act.CloseCurrentPane({ confirm = false }) },
	{ key = "X", mods = "LEADER", action = act.CloseCurrentTab({ confirm = false }) },

	-- ペインズーム
	{ key = "z", mods = "LEADER", action = act.TogglePaneZoomState },

	-- コピペ
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },

	-- スクロール
	{ key = "PageUp", mods = "NONE", action = act.ScrollByPage(-1) },
	{ key = "PageDown", mods = "NONE", action = act.ScrollByPage(1) },
	{ key = "PageUp", mods = "SHIFT", action = act.ScrollByLine(-1) },
	{ key = "PageDown", mods = "SHIFT", action = act.ScrollByLine(1) },

	-- 中断
	{ key = ".", mods = "CTRL", action = act.SendString("\x03") },

	-- フォントサイズ変更
	{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },

	-- 設定リロード
	{ key = "r", mods = "LEADER", action = act.ReloadConfiguration },
}

return config
