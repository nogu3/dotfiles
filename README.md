# dotfiles

my dotfiles

## パッケージマネージャ使い分け

### OS標準PM（pacman/apt/dnf/brew）

システム統合必須なツール:

- OS権限モデル連携（setgid/setuid/capabilities/専用グループ）
- デスクトップアプリ統合（例: 1Password CLI ↔ desktop）
- systemdサービス/デーモン
- PAM/認証系
- カーネルモジュール

### userland PM（mise/flox/nix/asdf）

- 言語ランタイム（node/python/ruby/go）
- 開発ツール（fzf/ripgrep/lazygit/delta）
- プロジェクト単位バージョン固定

### 判断基準

「バイナリに特殊な所有権/権限ビット/グループが必要か？」
- Yes → OS標準PM
- No → userland PM

### 例

| ツール | PM | 理由 |
|---|---|---|
| 1password-cli | pacman等 | `root:onepassword-cli` mode `2755` setgid必須。desktop統合がグループ検証 |
| docker | pacman等 | `docker`グループ + systemd統合 |
| node/fzf/lazygit | mise | 権限要件なし |
