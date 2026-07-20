# op ラッパー Service Account 統合 Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Claude Code (AI) からの `op` 呼び出しを 1Password Service Account トークン経路に自動で乗せ、signin もデスクトップ承認も不要にする。

**Architecture:** 既存の `settings/wsl/op` ラッパー（`~/.local/bin/op` に dotter symlink 済み）に認証経路の分岐を 2 つ前置する。① `OP_SERVICE_ACCOUNT_TOKEN` が既に env にあればそのまま native op、② `CLAUDECODE=1`（Claude Code の Bash が常に設定する env var）かつトークンファイルが存在すればトークンを注入して native op。それ以外は現状ロジック（SSH 越し → native op / PC の前 → op.exe）を変更しない。

**Tech Stack:** bash / 1Password CLI (`/usr/bin/op` v2, `op.exe`) / dotter

**Spec:** `docs/superpowers/specs/2026-07-20-op-service-account-design.md`

## Global Constraints

- コミットメッセージは Conventional Commits（このリポジトリは日本語件名）
- トークンファイルは `~/.config/op/service-account-token`（repo 外・dotter 管理外・mode 600）。**repo に一切コミットしない**
- 作業はメイン作業ツリーで行う（`~/.local/bin/op` の symlink がメインツリーを指しており実地検証に必要。1 ファイルの軽微なスクリプト変更のため worktree 例外を適用）
- `settings/wsl/op` の既存 3 分岐（agent.sock / op.exe / fallback）の挙動は変更しない
- secret の実値をコミット・ログ・plan に書かない

---

### Task 1: `settings/wsl/op` に Service Account 経路を追加し CLAUDE.md に使い方を記載

**Files:**
- Modify: `settings/wsl/op`
- Modify: `CLAUDE.md`（「Claude Code 連携」セクション）

**Interfaces:**
- Consumes: `~/.local/bin/op -> settings/wsl/op` の dotter symlink（配置済み・作業不要）
- Produces: `op` コマンドの新分岐 — `CLAUDECODE` env var が非空かつ `~/.config/op/service-account-token` が存在する場合、`OP_SERVICE_ACCOUNT_TOKEN` にファイル内容を入れて `/usr/bin/op` を exec する。Task 3 の検証はこの挙動に依存する

- [ ] **Step 1: ベースライン確認（失敗するテストに相当）**

まだトークンファイルが無いことを確認し、ダミートークンを置いた状態で現行ラッパーの挙動を記録する:

```bash
test ! -e ~/.config/op/service-account-token || { echo "STOP: 実トークンが既に存在。ダミーを書かないこと"; exit 1; }
mkdir -p ~/.config/op
echo "dummy-token-for-routing-test" > ~/.config/op/service-account-token
CLAUDECODE=1 op whoami
```

Expected: 現行ラッパーは `CLAUDECODE` を見ないため op.exe 経路に落ち、アカウント情報（Email: nogukids@gmail.com）が表示される。**これが「トークン経路がまだ存在しない」ことの確認**。

- [ ] **Step 2: ラッパーを書き換える**

`settings/wsl/op` 全体を以下に置き換える:

```bash
#!/bin/bash
# op の実行経路を切り替える (settings/wsl/ssh と同じ思想):
#   - AI (Claude Code) から: Service Account トークンで native op
#     (signin もデスクトップ承認も不要。ai vault read-only のみ)
#   - PC の前: op.exe → Windows 1Password とデスクトップ連携 (生体認証)
#   - SSH 越し (herdr ペイン含む): native /usr/bin/op を使う
# op CLI↔desktop 連携はローカル IPC 専用で SSH forwarding が無いため、接続元
# デスクトップの承認プロンプトは SSH 越しには出せない (接続元に ssh で戻る案は
# 接続元が sshd を動かしている前提が必要で構造的に破綻)。代わりに SSH 側では
# `eval $(op signin)` で取得したセッショントークン (承認/パスワード入力は手元の
# SSH 端末に出る) を使い、native op を実行する。
# ~/.ssh/agent.sock は SSH ログイン時に .zshrc が張る forwarded agent への symlink。
# herdr のペインは SSH_CONNECTION を継承しないため、socket の生存で経路を判定する。
# CLAUDECODE=1 は Claude Code の Bash セッションに常に設定される env var。
# トークンファイルが無いマシンでは AI も従来経路に落ちる (挙動不変)。
sa_token_file="$HOME/.config/op/service-account-token"

if [[ -n "$OP_SERVICE_ACCOUNT_TOKEN" ]]; then
  exec /usr/bin/op "$@"
elif [[ -n "$CLAUDECODE" && -f "$sa_token_file" ]]; then
  OP_SERVICE_ACCOUNT_TOKEN="$(<"$sa_token_file")" exec /usr/bin/op "$@"
elif [[ -S "$HOME/.ssh/agent.sock" ]]; then
  exec /usr/bin/op "$@"
elif [[ "$(uname -r)" == *microsoft* ]] && [[ -z "$SSH_CONNECTION" ]]; then
  exec op.exe "$@"
else
  exec /usr/bin/op "$@"
fi
```

- [ ] **Step 3: トークン経路への分岐を確認（テストが通ることに相当）**

```bash
CLAUDECODE=1 op whoami
```

Expected: **op.exe のアカウント表示ではなく**、`/usr/bin/op` がダミートークンを拒否する認証エラー（`[ERROR] ... token ...` / 401 系）が出る。これで ② の分岐が native op に到達している。

- [ ] **Step 4: ユーザー経路が不変なことを確認**

```bash
env -u CLAUDECODE op whoami
```

Expected: 従来通り op.exe 経路でアカウント情報が表示される（Windows 側で承認を求められたら承認する）。

さらに ① の分岐:

```bash
OP_SERVICE_ACCOUNT_TOKEN="explicit-dummy" op whoami
```

Expected: native op の認証エラー（明示 env が最優先で尊重される）。

- [ ] **Step 5: ダミートークンを削除**

```bash
rm ~/.config/op/service-account-token
CLAUDECODE=1 op whoami
```

Expected: トークンファイルが無いので従来経路に落ち、アカウント情報が表示される（挙動不変の確認）。

- [ ] **Step 6: CLAUDE.md に追記**

`CLAUDE.md` の「Claude Code 連携」セクション末尾に以下を追加:

```markdown
### AI からの 1Password (op) 利用

- Claude Code の Bash からの `op` は、`~/.config/op/service-account-token` が
  存在すれば自動で Service Account 経路 (`settings/wsl/op` の分岐) に乗る。
  signin・デスクトップ承認は不要
- secret の読み取りは `op read "op://ai/<item>/<field>"`。アクセスできるのは
  read-only 権限の `ai` vault のみで、それ以外の item はエラーになる (そこからは
  ユーザーに手動対応を依頼する)
- トークンファイルは各 PC 固有・dotter 管理外。repo にコミットしない
```

- [ ] **Step 7: コミット**

```bash
git add settings/wsl/op CLAUDE.md
git commit -m "feat(op): AI からの呼び出しを Service Account 経路に分岐

SSH 越しでは op signin を毎回手動実行しないと AI が op を使えず、
PC の前でも呼び出しごとに承認プロンプトが出ていた。CLAUDECODE=1
かつトークンファイル存在時のみトークンを注入し、ユーザーの手動
op は従来挙動を維持する。"
```

---

### Task 2: 1Password 側セットアップ（ユーザー手作業・エージェント作業なし）

**Files:** なし（repo 外の作業のみ）

**Interfaces:**
- Produces: `ai` vault（AI に読ませる secret 置き場）と、`~/.config/op/service-account-token`（mode 600）。Task 3 はこの 2 つに依存する

これはユーザーにしかできない作業。エージェントは以下の手順を提示して完了を待つ:

- [ ] **Step 1: vault 作成** — 1Password で新規 vault `ai` を作成し、テスト用 item を 1 つ入れる（例: item 名 `test-secret`、フィールド `password` に適当な値）
- [ ] **Step 2: Service Account 作成** — [my.1password.com](https://my.1password.com) → Developer → Service Accounts → 新規作成。vault アクセスは `ai` のみ・**read-only**。ここで Individual プランでの作成可否が判明する（作れない場合は実装済みラッパーは挙動不変のまま。方針再検討に戻る）
- [ ] **Step 3: トークン保存** — 発行されたトークン（`ops_...` で始まる文字列）を保存:

```bash
mkdir -p ~/.config/op
# トークンはエディタ等で貼り付けて保存（シェル履歴に残さない）
chmod 600 ~/.config/op/service-account-token
```

---

### Task 3: エンドツーエンド検証

**Files:** なし（検証のみ）

**Interfaces:**
- Consumes: Task 1 のラッパー分岐、Task 2 のトークンファイルと `ai` vault の `test-secret` item

- [ ] **Step 1: AI 経路で vault が見える**

```bash
op vault list
```

（Claude Code の Bash から実行。`CLAUDECODE=1` は自動で立っている）
Expected: `ai` vault **のみ**が表示される。プロンプトなし。

- [ ] **Step 2: secret が読める**

```bash
op read "op://ai/test-secret/password" >/dev/null && echo OK
```

Expected: `OK`（値そのものは表示・記録しない）。プロンプトなし。

- [ ] **Step 3: ai vault 外はエラーになる**

```bash
op vault get Private 2>&1 | head -2
```

Expected: 見つからない旨のエラー（Service Account の権限外であることの確認）。

- [ ] **Step 4: ユーザー経路の最終確認**

ユーザー自身のターミナル（Claude Code 外）で `op whoami` を実行してもらう。
Expected: 従来通り（op.exe / デスクトップ連携）。

検証結果を会話で報告して完了。コミットは不要。
