# mise-brew-backend

Homebrewをバックエンドとして使用し、`mise`経由でツールをインストールするためのカスタムプラグインです。
これにより、`mise`での管理を維持しながら、macOS上ではHomebrewのパッケージ管理機能を活用できます。

## 使い方

特定のツールに対して、デフォルトのインストール方法の代わりにこのプラグインを使用することができます。

### インストール

ツール（例：`jq`）でこのバックエンドを使用するには、そのツールのプラグインとしてこのディレクトリを登録する必要があります。

```bash
# 'jq' 用に brew-backend プラグインを登録する
mise plugin install jq /path/to/settings/mise/plugins/brew-backend

# ローカルで開発/リンクする場合
mise plugin link jq ./settings/mise/plugins/brew-backend
```

### ツールのインストール

登録が完了すると、`mise` を使用してツールをインストールできます。内部的に `brew install` が呼び出されます。

```bash
mise install jq@latest
```

これにより `brew install jq` が実行され、インストールされたバイナリが `mise` のディレクトリ構造にシンボリックリンクされます。

### 統一的な管理 (Mac vs Linux)

MacではBrewを使用し、Linuxでは標準のmiseプラグインを使用するという統一的な管理を実現するには、以下のようにします。

1.  通常通り `mise.toml` でツールを定義します。

    ```toml
    [tools]
    jq = "latest"
    ```

2.  macOS上では、セットアップスクリプト（`init.sh`など）を実行して、対象のツールに対してこのバックエンドプラグインをリンクします。

    ```bash
    # macOS用の init.sh 内で
    mise plugin link jq /path/to/settings/mise/plugins/brew-backend
    # brewで管理したい他のツールについても同様に行う
    ```

3.  Linux上では、`mise` に標準のレジストリプラグインを使用させます。

## 機能

*   **インストール**: `brew install <tool>` を実行します。`latest` または特定のバージョン（brewが `@version` として提供している場合）をサポートします。
*   **リスト表示**: `brew list --versions` を使用します。
*   **リンク**: インストールされたバイナリ（keg-onlyのものも含む）を自動的に見つけ、`mise` の shim パスにシンボリックリンクを作成します。
*   **アンインストール**: `brew uninstall <tool>` を実行してパッケージを削除します。
