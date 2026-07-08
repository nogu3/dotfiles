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
-- ペイン/タブ管理は herdr に委譲 (settings/herdr/config.toml)。
-- WezTerm 内蔵のペイン/タブ管理に戻したいときは、この config と同じ
-- ディレクトリに use-builtin-mux ファイルを置く:
--   touch ~/.config/wezterm/use-builtin-mux   (herdr に戻すときは rm)
-- 反映されない場合は Ctrl+Shift+R (デフォルトの設定リロード) を押す。
local builtin_mux_flag = wezterm.config_dir .. "/use-builtin-mux"
wezterm.add_to_config_reload_watch_list(builtin_mux_flag)

local function builtin_mux_enabled()
	local f = io.open(builtin_mux_flag, "r")
	if f then
		f:close()
		return true
	end
	return false
end

config.keys = {

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

}

-- use-builtin-mux フラグがあるときだけ旧来のペイン/タブ管理を有効化
if builtin_mux_enabled() then
	config.leader = { key = "w", mods = "CTRL" }

	local mux_keys = {
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
	}

	for _, key in ipairs(mux_keys) do
		table.insert(config.keys, key)
	end
end

return config
