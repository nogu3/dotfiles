-- wezterm.lua

local wezterm = require("wezterm")
local act = wezterm.action
local config = wezterm.config_builder()

----------------------------------------------------------------------
-- OS判定
----------------------------------------------------------------------
local function is_windows()
	return wezterm.target_triple:find("windows")
end

local function is_mac()
	return wezterm.target_triple:find("darwin")
end

local function is_linux()
	return wezterm.target_triple:find("linux")
end

----------------------------------------------------------------------
-- 1. 基本設定 / パフォーマンス
----------------------------------------------------------------------

-- color scheme
config.color_scheme = "iceberg-dark"

-- font size
if is_mac() then
	config.font_size = 15
else
	config.font_size = 12
end

-- rendering engine
if is_mac() then
	config.front_end = "WebGpu"
end

-- opacity
config.window_background_opacity = 0.9

-- クリップボード連携の安定化
config.enable_kitty_graphics = true

-- for wsl
if is_windows() then
	config.default_domain = "WSL:Ubuntu"
end

-- IME (fcitx5)
if is_linux() then
	config.use_ime = true
end

----------------------------------------------------------------------
-- 2. キーバインド
----------------------------------------------------------------------
-- ペイン/タブ管理は herdr に委譲 (settings/herdr/config.toml)
config.keys = {

	-- コピペ
	{ key = "c", mods = "CTRL", action = act.CopyTo("Clipboard") },
	{ key = "v", mods = "CTRL", action = act.PasteFrom("Clipboard") },

	-- スクロールは herdr のスクロールバックビュー (PageUp/PageDown) に委譲。
	-- WezTerm 組み込みデフォルトの SHIFT+PageUp/Down (ScrollByPage) がキーを
	-- 食うため明示的に無効化して herdr に素通しする
	{ key = "PageUp", mods = "SHIFT", action = act.DisableDefaultAssignment },
	{ key = "PageDown", mods = "SHIFT", action = act.DisableDefaultAssignment },

	-- 中断
	{ key = ".", mods = "CTRL", action = act.SendString("\x03") },

	-- フォントサイズ変更
	{ key = "+", mods = "CTRL", action = act.IncreaseFontSize },
	{ key = "-", mods = "CTRL", action = act.DecreaseFontSize },

}

return config
