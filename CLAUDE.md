# CLAUDE.md

このリポジトリで作業するときのガイド。

## 概要

個人の dotfiles リポジトリ。macOS / Linux (WSL2 含む) 両対応。設定ファイルは `settings/` 配下に集約し、[dotter](https://github.com/SuperCuber/dotter) でホームにシンボリックリンク配置する。ツール導入は [mise](https://mise.jdx.dev/) に一元化。

## セットアップフロー

エントリポイントは `init.sh`。3 ターゲットを持つモジュール式。

- `--mise`: `settings/mise` を `~/.config/mise` にリンク → `mise install`
- `--dotter`: `mise exec -- dotter deploy` で全設定をリンク
- `--claude-skills`: Claude Code の `genshijin` プラグインを marketplace 追加 + インストール
- 引数なし: 3 つ全実行
- `-n / --dry-run`: 実行せずコマンド表示

シェルは fish → zsh → sh の順で自動フォールバック (`execute_in_user_shell`)。

Docker 経由で使う場合は `Taskfile.yml` の `task build` / `task exec` で Alpine ベースのサンドボックスを起動。`docker-compose.yml` がホストの `.gitconfig` / `gh` をマウント。

## ディレクトリ構成と意図

### ルート

| パス | 意図 |
|---|---|
| `init.sh` | セットアップ統合スクリプト。mise / dotter / Claude skills を管理 |
| `Taskfile.yml` | Docker サンドボックス操作 (`build` / `exec` / `reset/nvim`) |
| `Dockerfile`, `docker-compose.yml` | 開発用コンテナ定義 (Alpine + zsh + nvim + Ruby) |
| `.dotter/global.toml` | dotter のリンク定義 (全 OS 共通 + `linux` パッケージ) |
| `.dotter/local.toml` | ホスト毎の有効パッケージ指定 (`default`, `linux` など) |
| `.scripts/` | PATH に追加するユーティリティスクリプト (`gh-prw`, `ghurl`, `ide`, `ruby-dev-tool`, `setup-xremap`) |
| `.claude/settings.local.json` | このリポジトリ専用の Claude Code 設定 |

### settings/ 配下

dotter のリンク対象。`global.toml` の `[default.files]` / `[linux.files]` を真実のソースとする。

| ディレクトリ | リンク先 | 用途 |
|---|---|---|
| `settings/zsh/` | `~/` 配下展開 | `.zshrc` (zinit + pure + mise + fzf + ghq), `.zshrc_local` は各 PC 固有設定用 (env var / PATH / 1Password agent パス等) |
| `settings/fish/` | `~/.config/fish/` | `config.fish` 本体 + `config_local.fish` は各 PC 固有設定用 |
| `settings/mise/config.toml` | `~/.config/mise/` (init.sh がリンク) | 全言語・CLI のバージョン管理 (claude / helix / fzf / zoxide / delta / dotter / ghq / yazi / gws / gcloud / lazygit / rust / xremap / jules)。Linux 限定ツールは `os = ["linux"]` |
| `settings/claude/settings.json` | `~/.claude/settings.json` | Claude Code の hooks (SessionStart で genshijin 自動起動) / statusLine / 有効プラグイン |
| `settings/wezterm/wezterm.lua` | `~/.config/wezterm/` | WezTerm 設定。macOS フォントサイズ等 OS 分岐あり |
| `settings/helix/` | `~/.config/helix/` | Helix エディタ設定 + テーマ |
| `settings/zenvim/` | `~/.config/nvim/` | Neovim (lazy.nvim) 設定。`init.lua` + `lua/` 分割構成 |
| `settings/lazygit/config.yml` | `~/.config/lazygit/` | lazygit 設定 |
| `settings/xremap/config.yml` | `~/.config/xremap/` (linux のみ) | Linux のキーバインド remap |
| `settings/systemd/user/` | `~/.config/systemd/user/` (linux のみ) | xremap を systemd user service として自動起動 |
| `settings/fcitx5/config` | 未 dotter 管理 (手動配置想定) | Linux 日本語入力設定 |
| `settings/docker/ruby-dev-tool/` | なし | `.scripts/ruby-dev-tool` が使う Dockerfile |

### OS 分岐

- `default` パッケージ: 全 OS 共通
- `linux` パッケージ: xremap / systemd user service
- mise 側でも `os = ["linux"]` 指定で Linux 限定ツールを制御
- `.dotter/local.toml` の `packages` で適用範囲を決定

## 変更ルール

- 新しい設定ファイルを追加するときは `settings/<tool>/` に配置し、`.dotter/global.toml` にエントリを追加する
- Linux 限定なら `[linux.files]` に書く
- ツール導入は原則 `settings/mise/config.toml` に追記する。ただし後述の「パッケージマネージャ使い分け」に該当するシステム統合ツールは OS 標準 PM (pacman / apt / dnf / brew) を使う
- 各 PC 固有の設定 (ホスト名依存の PATH / env var / 秘匿値など) は `settings/zsh/.zshrc_local` または `settings/fish/config_local.fish` に書く。リポジトリ共通設定 (`.zshrc` / `config.fish`) には書かない
- コミットメッセージは Conventional Commits (`feat:` / `fix:` / `refactor:` など) を使用

## パッケージマネージャ使い分け

### OS 標準 PM (pacman / apt / dnf / brew) を使う

システム統合が必要なツール:

- OS の権限モデル連携 (setgid / setuid / capabilities / 専用グループ)
- デスクトップアプリとの統合 (例: 1Password CLI ↔ 1Password desktop)
- systemd サービス / デーモン
- PAM / 認証系
- カーネルモジュール
- 署名検証が必要なバイナリ

### userland PM (mise / flox / nix / asdf / homebrew-linux) を使う

- 言語ランタイム (node / python / ruby / go)
- 開発ツール (fzf / ripgrep / lazygit / delta)
- プロジェクト単位バージョン固定
- システム統合不要な CLI ユーティリティ

### 判断基準

「バイナリに特殊な所有権 / 権限ビット / 専用グループが必要か？」

- Yes → OS 標準 PM
- No → userland PM (mise 優先)

### 実例

- `1password-cli`: OS 標準 PM 必須。`/usr/bin/op` に `root:onepassword-cli` mode `2755` (setgid) 必要。desktop 統合がグループ所有権で検証するため userland PM 不可
- `docker`: OS 標準 PM 推奨。`docker` グループ + systemd 統合
- `node` / `fzf` / `lazygit` 等: mise 可

## Claude Code 連携

- セッション開始時に hook で genshijin スキル起動指示が入る
- `init.sh --claude-skills` で marketplace `InterfaceX-co-jp/genshijin` を user scope に追加
- `settings/claude/settings.json` で `enabledPlugins` と `extraKnownMarketplaces` を宣言管理
