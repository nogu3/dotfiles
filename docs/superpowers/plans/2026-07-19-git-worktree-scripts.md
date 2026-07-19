# gwa / gwr worktree ヘルパースクリプト Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** 同一リポジトリで複数機能を並行開発するための worktree 作成 (`gwa`) / 削除 (`gwr`) スクリプトを `.scripts/` に追加する。

**Architecture:** `.scripts/` 配下の bash 単体スクリプト2本。既存 `gh-prw` の色付きヘルパー様式を踏襲しつつ、進捗メッセージは stderr、成果 (worktree パス) は stdout に分離する。worktree の実体はメインリポジトリの兄弟ディレクトリ `${main}_worktree/<branch>/` に置く (`gh-prw` と同一規約)。移動 (`cd`) はしない。

**Tech Stack:** bash, git worktree, 手動 bash テストハーネス (専用フレームワークなし)

## Global Constraints

- 配置先: `.scripts/gwa`, `.scripts/gwr` (既に PATH 追加済み、dotter 追加不要)
- shebang: `#!/usr/bin/env bash` / `set -e`
- worktree パス規約: `BASE="${MAIN}_worktree"`, `WT="$BASE/<name>"` (`MAIN` = メイン worktree の絶対パス)
- メイン worktree 特定: `git worktree list --porcelain` の最初の `worktree ` 行
- 出力契約: 進捗 (info/success/warning/error) は **stderr**、worktree パスは **stdout に1行**
- 移動しない (`cd` を含めない)。ブランチの自動削除もしない
- コミットメッセージは Conventional Commits
- ファイルは実行権限付与 (`chmod +x`)

---

### Task 1: `gwa` — worktree を作成しパスを出力

**Files:**
- Create: `.scripts/gwa`
- Test: `scratchpad/test_gwa.sh` (使い捨て手動テスト。コミットしない)

**Interfaces:**
- Consumes: なし
- Produces: `gwa <name>` CLI。stdout に worktree 絶対パス1行。stderr に進捗。
  worktree 規約 `${MAIN}_worktree/<name>` と、メイン特定ロジック
  `git worktree list --porcelain | 先頭 worktree 行` を Task 2 が踏襲する。

- [ ] **Step 1: 失敗するテストを書く**

`scratchpad/test_gwa.sh` を作成:

```bash
#!/usr/bin/env bash
# gwa の手動テストハーネス。異常時は非0 exit。
set -u
GWA="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)/.scripts/gwa"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

# セットアップ: コミット1つの git リポジトリ
REPO="$TMP/repo"
mkdir -p "$REPO"
git -C "$REPO" init -q
git -C "$REPO" config user.email t@e.st
git -C "$REPO" config user.name test
git -C "$REPO" commit -q --allow-empty -m init

fail() { echo "FAIL: $1" >&2; exit 1; }

# 1. gwa foo -> ${repo}_worktree/foo が生成され stdout がそのパス1行
OUT="$(cd "$REPO" && "$GWA" foo 2>/dev/null)"
[ "$OUT" = "${REPO}_worktree/foo" ] || fail "stdout path: got '$OUT'"
[ -d "${REPO}_worktree/foo" ] || fail "worktree dir not created"
git -C "$REPO" show-ref --verify --quiet refs/heads/foo || fail "branch foo not created"

# 2. cd $(gwa bar) で移動できる (合成可能性)
DIR="$(cd "$REPO" && cd "$("$GWA" bar 2>/dev/null)" && pwd)"
[ "$DIR" = "${REPO}_worktree/bar" ] || fail "compose cd: got '$DIR'"

# 3. 既存ブランチ名なら -b なし経路で再利用
git -C "$REPO" branch baz
OUT="$(cd "$REPO" && "$GWA" baz 2>/dev/null)"
[ "$OUT" = "${REPO}_worktree/baz" ] || fail "existing branch reuse: got '$OUT'"

# 4. 同名再実行は冪等 (作らずパス出力, exit 0)
OUT="$(cd "$REPO" && "$GWA" foo 2>/dev/null)"; RC=$?
[ "$RC" -eq 0 ] && [ "$OUT" = "${REPO}_worktree/foo" ] || fail "idempotent: rc=$RC out='$OUT'"

# 5. 引数なしは exit 1
(cd "$REPO" && "$GWA" >/dev/null 2>&1) && fail "no-arg should exit 1"

# 6. git 外は exit 1
(cd "$TMP" && "$GWA" foo >/dev/null 2>&1) && fail "outside git should exit 1"

echo "gwa: ALL PASS"
```

- [ ] **Step 2: テストが失敗することを確認**

Run: `bash scratchpad/test_gwa.sh`
Expected: FAIL (`.scripts/gwa` が存在せず、最初のアサートで落ちる or "No such file")

- [ ] **Step 3: `gwa` を実装**

`.scripts/gwa` を作成:

```bash
#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
NC='\033[0m'

info()    { echo -e "${CYAN}==>${NC} $1" >&2; }
success() { echo -e "${GREEN}==>${NC} $1" >&2; }
error()   { echo -e "${RED}==>${NC} $1" >&2; }

NAME="$1"
if [ -z "${NAME:-}" ]; then
  error "Usage: gwa <name>"
  exit 1
fi

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  error "Not inside a git repository."
  exit 1
fi

# メイン worktree = git worktree list --porcelain の最初の worktree 行
MAIN="$(git worktree list --porcelain | awk '/^worktree /{print substr($0,10); exit}')"
BASE="${MAIN}_worktree"
WT="$BASE/$NAME"

# 冪等: 既存ならそのまま出力
if [ -d "$WT" ]; then
  info "Worktree already exists: $WT"
  echo "$WT"
  exit 0
fi

mkdir -p "$BASE"

if git show-ref --verify --quiet "refs/heads/$NAME"; then
  info "Branch '$NAME' exists. Reusing it."
  git worktree add "$WT" "$NAME" >&2
else
  info "Creating branch '$NAME' from HEAD."
  git worktree add -b "$NAME" "$WT" >&2
fi

success "Worktree ready: $WT"
echo "$WT"
```

- [ ] **Step 4: 実行権限を付与**

Run: `chmod +x .scripts/gwa`
Expected: エラーなし

- [ ] **Step 5: テストが通ることを確認**

Run: `bash scratchpad/test_gwa.sh`
Expected: `gwa: ALL PASS`

- [ ] **Step 6: コミット**

```bash
git add .scripts/gwa
git commit -m "feat(scripts): worktree を作成する gwa を追加"
```

---

### Task 2: `gwr` — worktree を削除

**Files:**
- Create: `.scripts/gwr`
- Test: `scratchpad/test_gwr.sh` (使い捨て手動テスト。コミットしない)

**Interfaces:**
- Consumes: Task 1 の worktree 規約 `${MAIN}_worktree/<name>` とメイン特定ロジック
  (`git worktree list --porcelain` 先頭 worktree 行)。
- Produces: `gwr [<name>]` CLI。worktree を削除し、`BASE` が空なら掃除。ブランチは残す。

- [ ] **Step 1: 失敗するテストを書く**

`scratchpad/test_gwr.sh` を作成:

```bash
#!/usr/bin/env bash
# gwr の手動テストハーネス。gwa を前提に使う。
set -u
ROOT="$(git -C "$(dirname "$0")/.." rev-parse --show-toplevel)"
GWA="$ROOT/.scripts/gwa"
GWR="$ROOT/.scripts/gwr"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

REPO="$TMP/repo"
mkdir -p "$REPO"
git -C "$REPO" init -q
git -C "$REPO" config user.email t@e.st
git -C "$REPO" config user.name test
git -C "$REPO" commit -q --allow-empty -m init

fail() { echo "FAIL: $1" >&2; exit 1; }

# 1. gwr <name> で worktree が消え、空になった _worktree も掃除される
(cd "$REPO" && "$GWA" foo >/dev/null 2>&1)
(cd "$REPO" && "$GWR" foo >/dev/null 2>&1) || fail "gwr foo exit nonzero"
[ ! -d "${REPO}_worktree/foo" ] || fail "worktree still exists"
[ ! -d "${REPO}_worktree" ] || fail "empty _worktree not cleaned"
# ブランチは残す
git -C "$REPO" show-ref --verify --quiet refs/heads/foo || fail "branch should remain"

# 2. 複数あるとき、対象だけ消えて _worktree は残る
(cd "$REPO" && "$GWA" a >/dev/null 2>&1)
(cd "$REPO" && "$GWA" b >/dev/null 2>&1)
(cd "$REPO" && "$GWR" a >/dev/null 2>&1) || fail "gwr a exit nonzero"
[ ! -d "${REPO}_worktree/a" ] || fail "a still exists"
[ -d "${REPO}_worktree/b" ]   || fail "b wrongly removed"

# 3. name 省略 + worktree 内 -> その worktree を対象に削除
WT="$(cd "$REPO" && "$GWA" c 2>/dev/null)"
(cd "$WT" && "$GWR" >/dev/null 2>&1) || fail "gwr (infer) exit nonzero"
[ ! -d "$WT" ] || fail "inferred worktree not removed"

# 4. name 省略 + メイン内 -> exit 1
(cd "$REPO" && "$GWR" >/dev/null 2>&1) && fail "no-arg in main should exit 1"

# 5. 存在しない name -> exit 1
(cd "$REPO" && "$GWR" nope >/dev/null 2>&1) && fail "missing worktree should exit 1"

echo "gwr: ALL PASS"
```

- [ ] **Step 2: テストが失敗することを確認**

Run: `bash scratchpad/test_gwr.sh`
Expected: FAIL (`.scripts/gwr` が存在しない)

- [ ] **Step 3: `gwr` を実装**

`.scripts/gwr` を作成:

```bash
#!/usr/bin/env bash
set -e

RED='\033[0;31m'
GREEN='\033[0;32m'
CYAN='\033[0;36m'
YELLOW='\033[1;33m'
NC='\033[0m'

info()    { echo -e "${CYAN}==>${NC} $1" >&2; }
success() { echo -e "${GREEN}==>${NC} $1" >&2; }
warning() { echo -e "${YELLOW}==>${NC} $1" >&2; }
error()   { echo -e "${RED}==>${NC} $1" >&2; }

if ! git rev-parse --is-inside-work-tree >/dev/null 2>&1; then
  error "Not inside a git repository."
  exit 1
fi

MAIN="$(git worktree list --porcelain | awk '/^worktree /{print substr($0,10); exit}')"
BASE="${MAIN}_worktree"

NAME="${1:-}"
if [ -z "$NAME" ]; then
  # name 省略: 今いる worktree を推測 (メインでなく BASE 配下にいるとき)
  CUR="$(git rev-parse --show-toplevel)"
  case "$CUR" in
    "$BASE"/*) NAME="$(basename "$CUR")" ;;
    *)
      error "Usage: gwr <name>  (run inside a worktree to omit <name>)"
      exit 1
      ;;
  esac
fi

WT="$BASE/$NAME"
if [ ! -d "$WT" ]; then
  error "Worktree not found: $WT"
  exit 1
fi

# 対象 worktree 内に立っていると git remove が失敗する
CUR="$(git rev-parse --show-toplevel)"
case "$CUR" in
  "$WT"|"$WT"/*)
    error "You are inside '$WT'. cd out first, then rerun."
    exit 1
    ;;
esac

info "Removing worktree: $WT"
git worktree remove "$WT" >&2

# BASE が空なら掃除
rmdir "$BASE" 2>/dev/null || true

success "Removed worktree '$NAME'. Branch kept."
warning "Delete the branch with: git branch -d $NAME"
```

- [ ] **Step 4: 実行権限を付与**

Run: `chmod +x .scripts/gwr`
Expected: エラーなし

- [ ] **Step 5: テストが通ることを確認**

Run: `bash scratchpad/test_gwr.sh`
Expected: `gwr: ALL PASS`

- [ ] **Step 6: 回帰確認 (gwa テストも再実行)**

Run: `bash scratchpad/test_gwa.sh`
Expected: `gwa: ALL PASS`

- [ ] **Step 7: コミット**

```bash
git add .scripts/gwr
git commit -m "feat(scripts): worktree を削除する gwr を追加"
```

---

### Task 3: ドキュメント追記

**Files:**
- Modify: `CLAUDE.md` (`.scripts/` の説明行に gwa/gwr を追記)

**Interfaces:**
- Consumes: Task 1/2 で確定した `gwa` / `gwr` の名前と役割。
- Produces: なし (ドキュメントのみ)。

- [ ] **Step 1: CLAUDE.md の `.scripts/` 行を更新**

`CLAUDE.md` のルート表の `.scripts/` 行、既存の列挙に `gwa`, `gwr` を追加する。
現在:

```
| `.scripts/` | PATH に追加するユーティリティスクリプト (`gh-prw`, `ghurl`, `ide`, `ruby-dev-tool`, `setup-xremap`, `setup-fingerprint`) |
```

を次に変更:

```
| `.scripts/` | PATH に追加するユーティリティスクリプト (`gh-prw`, `ghurl`, `gwa`/`gwr` (worktree 作成/削除), `ide`, `ruby-dev-tool`, `setup-xremap`, `setup-fingerprint`) |
```

- [ ] **Step 2: コミット**

```bash
git add CLAUDE.md
git commit -m "docs: gwa/gwr を .scripts の一覧に追記"
```

---

## Self-Review

**Spec coverage:**
- worktree の実体を `${main}_worktree/<branch>` に置く → Task 1 Step 3 (`BASE`/`WT`) ✓
- `.scripts/` の bash 単体スクリプト → Task 1/2 ✓
- gwa: git チェック / メイン特定 / HEAD からブランチ / 既存再利用 / 冪等 / 進捗 stderr・パス stdout → Task 1 Step 3 + テスト ✓
- gwr: name 推測 / remove / dirty は git 任せ / 空 BASE 掃除 / ブランチ残す + ヒント / 立っているツリーは案内 → Task 2 Step 3 + テスト ✓
- 移動しない → 両スクリプトに cd なし ✓
- テスト方針の7項目 → gwa テスト6項目 + gwr テスト5項目でカバー ✓

**Placeholder scan:** TBD/TODO/曖昧な "適切なエラー処理" なし。全コード実体あり ✓

**Type consistency:** `MAIN` / `BASE` / `WT` の算出方法が Task 1/2 で一致。メイン特定 awk が両者同一 ✓

注記: dirty worktree の `git worktree remove` 失敗は git の挙動に委ねるため専用テストは置かない (spec のテスト方針6は手動確認事項)。
