# git worktree ヘルパースクリプト (`gwa` / `gwr`) 設計

## 目的

同一リポジトリで複数の機能追加を同時並行で走らせるため、worktree の作成・削除を
`gh-prw` と同じ規約に乗せた薄いスクリプトで簡単にする。Claude Code の実装作業を
worktree 上でやりやすくすることが動機。

## スコープ

- **やる**: worktree を「作る」`gwa`、worktree を「片付ける」`gwr`
- **やらない (YAGNI)**:
  - ディレクトリ移動 (`cd`) — Unix 哲学に従い「作る/消す」だけに徹する。移動は
    利用者が `cd $(gwa foo)` のように自分で合成する
  - claude の自動起動 — 手動で立ち上げる
  - worktree 一覧 — `git worktree list` を直接使う
  - ブランチの自動削除 — PR 用に残す可能性があるため消さない

## どこで・なにを管理するか

| 対象 | 場所 | 理由 |
|---|---|---|
| worktree の実体 | `${main}_worktree/<branch>/` | 既存 `gh-prw` が同一規約を採用済み。メインリポジトリの兄弟ディレクトリで ghq ツリーを汚さない |
| コマンド定義 | `.scripts/gwa` / `.scripts/gwr` (bash) | `cd` しないので親シェルを触る必要がなく、単体スクリプトで成立。PATH 経由でシェル非依存 = fish/zsh を1本でカバー。`gh-prw` / `ghurl` / `ide` と同じ置き場・同じスタイル |

`.scripts/` は既に PATH 追加済み (CLAUDE.md 記載)。dotter 追加設定は不要。

## `gwa <name>` の仕様

worktree を新規作成し、そのパスを stdout に出力する。

### 振る舞い
1. 引数 `<name>` 必須。無ければ usage を stderr に出して exit 1
2. カレントが git リポジトリ内かを確認 (`git rev-parse --is-inside-work-tree`)。
   違えばエラー
3. メイン worktree のパスを特定する。`git worktree list --porcelain` の最初の
   `worktree ` 行が常にメイン worktree。これを `MAIN` とする
4. `BASE="${MAIN}_worktree"`, `WT="$BASE/<name>"`
5. `WT` が既に存在する場合は作成せず、そのパスを stdout に出して exit 0 (冪等)
6. ブランチ起点は **今いる HEAD**:
   - `<name>` という名のブランチが未存在 → `git worktree add -b <name> "$WT"`
     (HEAD からブランチ作成)
   - 既存 → `git worktree add "$WT" <name>` (既存ブランチを再利用)
7. 進捗メッセージ (info/success) はすべて **stderr**。**最後に `WT` のパスだけを
   stdout に1行出力**する
   - これにより `cd $(gwa foo)` が成立し、移動は利用者の任意合成に委ねられる

### 出力契約
- stdout: worktree の絶対パス (1行) のみ
- stderr: 色付き進捗メッセージ

## `gwr [<name>]` の仕様

worktree を削除してメインリポジトリを綺麗に保つ。cd はしない。

### 振る舞い
1. カレントが git リポジトリ内かを確認
2. メイン worktree `MAIN` を `gwa` と同じ方法で特定。`BASE="${MAIN}_worktree"`
3. `<name>` の解決:
   - 明示指定あり → `WT="$BASE/<name>"`
   - 省略時 → カレントが worktree 内 (`${MAIN}` 以外の worktree) なら、その
     worktree を対象に推測。メイン内で省略された場合は usage を出して exit 1
4. `WT` が存在しなければエラー
5. `git worktree remove "$WT"` を実行。作業ツリーが dirty なら git がエラーを返す
   = 安全側 (強制削除はしない)
6. 削除後、`BASE` が空なら `rmdir` で掃除
7. ブランチは削除しない。削除コマンド (`git branch -d <name>`) をヒントとして
   stderr に表示
8. cd はしない。もし対象 worktree 内に立ったまま実行された場合、git の remove は
   失敗するので、「`cd` で出てから再実行して」と案内する

## エラーハンドリング

`gh-prw` に倣い、先頭で色定義と `info` / `success` / `warning` / `error` ヘルパーを
定義。`set -e` を使う。異常系はすべて非0 exit + `error` メッセージ (stderr)。

## テスト方針

一時 git リポジトリを作って手動で検証する:
1. `gwa foo` → `${repo}_worktree/foo` が生成され、stdout がそのパス1行であること
2. `cd $(gwa bar)` で移動できること (合成可能性)
3. 既存ブランチ名で `gwa` → `-b` なし経路でブランチ再利用されること
4. 同名 `gwa` 再実行 → 冪等 (作らずパス出力)
5. `gwr foo` → worktree が消え、`_worktree` が空なら掃除されること
6. dirty worktree に `gwr` → git がエラーを返し worktree が残ること
7. worktree 内で `gwr` (name 省略) → 対象を推測して削除できること
