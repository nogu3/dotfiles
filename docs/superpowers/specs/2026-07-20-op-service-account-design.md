# op ラッパーへの 1Password Service Account 統合

日付: 2026-07-20
ステータス: 承認済み

## 背景 / 課題

`settings/wsl/op` ラッパーは実行経路を 2 つ持つ:

- PC の前: `op.exe` → Windows 1Password とデスクトップ連携（生体認証）
- SSH 越し: native `/usr/bin/op` → `eval $(op signin)` のセッショントークンが必要

このため AI (Claude Code) から op を使わせようとすると:

1. SSH 越しセッションでは、ユーザーが `op signin` を手で叩かない限り動かない。
   セッショントークンはユーザーのシェル env にあり Claude Code の Bash には届かず、
   30 分アイドルで失効する
2. PC の前でも、AI の op 呼び出しごとに Windows 側で承認プロンプトが出る

結果として、secret が必要な場面ではユーザーが毎回手動で op を叩いて値を渡している。

## 解決方針

1Password **Service Account** を導入する。`OP_SERVICE_ACCOUNT_TOKEN` が env にあれば
op は signin 不要・デスクトップ承認不要・SSH かどうかも無関係に動作する。

- AI に読ませたい secret だけを専用 vault `ai` に置く
- Service Account には `ai` vault の **read-only** 権限のみ付与
- 既存の `op` ラッパーに統合し、**AI からの呼び出しだけ**が自動でトークン経路に乗る

### 検討した代替案

- **別コマンド `ops` を追加**: 境界は明確だが、ユーザーがコマンド一本 (`op`) で済む
  統合案を選択
- **op signin の自動化・延命**: マスターパスワード入力が結局毎回必要で、30 分失効も
  解決しないため却下
- **1Password Connect Server**: 個人用途にはインフラ過剰。大量・高頻度配布が必要に
  なったら再検討

## 設計

### 認証経路の優先順位（`settings/wsl/op` 改修）

```
① OP_SERVICE_ACCOUNT_TOKEN が既に env にある
     → そのまま /usr/bin/op（明示指定を尊重）
② CLAUDECODE=1 かつ ~/.config/op/service-account-token が存在
     → トークンを export して /usr/bin/op
③ それ以外は現状ロジックのまま
     - ~/.ssh/agent.sock あり (SSH 越し) → /usr/bin/op
     - WSL かつ SSH_CONNECTION なし (PC の前) → op.exe
     - else → /usr/bin/op
```

- `CLAUDECODE=1` は Claude Code の Bash セッションに常に設定される env var
  （実機確認済み）。これで呼び出し元が AI かどうかを判別する
- ユーザーが手で叩く `op` は従来挙動（op.exe / op signin / Private vault）を維持する
- AI が `ai` vault にない item を要求した場合は op がエラーを返す。暗黙のフォール
  バックはしない（どの権限で動いたか曖昧になるため）。そこが手動対応との境界線

### 1Password 側の準備（ユーザーの手作業・一度だけ）

1. vault `ai` を作成し、AI に読ませたい secret を入れる
2. my.1password.com → Developer → Service Account を作成し、`ai` vault に
   read-only 権限のみ付与（Individual プランでの作成可否はここで確認）
3. トークンを `~/.config/op/service-account-token` に保存し `chmod 600`
   （repo 外・dotter 管理外。各 PC 固有ファイルの扱い）

### ドキュメント

dotfiles の CLAUDE.md に追記:

- AI の secret 読み取りは `op read "op://ai/<item>/<field>"` で承認なしに通る
- `ai` vault 外の item は AI からアクセス不可（Service Account の権限外）

### 検証

- `CLAUDECODE=1 op vault list` → `ai` vault のみ見える（トークン経路の確認）
- ユーザーのシェルで素の `op whoami` → 従来挙動のまま
- Claude Code セッションから `op read "op://ai/<test-item>/..."` →
  プロンプトなしで値が返る

## セキュリティ上のトレードオフ

トークンはマシン上の常設クレデンシャル。トークンファイルを読めるローカルプロセスは
承認なしで `ai` vault を読める。緩和策:

- 専用 vault + read-only でブラスト半径を限定
- Private vault には Service Account は構造的にアクセス不可
- トークンファイルは mode 600・repo 外

## スコープ外（フェーズ 2 候補）

自宅ホスト（jarvis / NAS 等）向け SSH 専用鍵を `ai` vault に置き、
`op read ... | ssh-add -` でプロンプトレス SSH にする件。本改修が安定してから別途。
1Password desktop の SSH agent プロンプト頻度は、desktop 設定
（鍵の承認を記憶する / 自動ロック時間）で別途緩和する。
