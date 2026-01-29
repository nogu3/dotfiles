# mise-brew-backend

A custom `mise` plugin that uses Homebrew as a backend for installing tools.
This allows you to manage tools via `mise` while leveraging Homebrew's package management on macOS.

## Usage

You can use this plugin to override the default installation method for specific tools.

### Installation

To use this backend for a tool (e.g., `jq`), you need to register this plugin directory as the plugin for that tool.

```bash
# Register the brew-backend plugin for 'jq'
mise plugin install jq /path/to/settings/mise/plugins/brew-backend

# Or if you are developing/linking locally
mise plugin link jq ./settings/mise/plugins/brew-backend
```

### Installing Tools

Once registered, you can install the tool using `mise`. It will internally call `brew install`.

```bash
mise install jq@latest
```

This will run `brew install jq` and symlink the installed binary into `mise`'s directory structure.

### Unified Management (Mac vs Linux)

To achieve unified management where Mac uses Brew and Linux uses standard mise plugins:

1.  Define your tools in `mise.toml` as usual:

    ```toml
    [tools]
    jq = "latest"
    ```

2.  On macOS, run a setup script (like your `init.sh`) to link this backend plugin for the desired tools.

    ```bash
    # In your init.sh for macOS
    mise plugin link jq /path/to/settings/mise/plugins/brew-backend
    # Repeat for other tools you want to manage via brew
    ```

3.  On Linux, just let `mise` use the default registry plugins.

## Features

-   **Install**: Runs `brew install <tool>`. Supports `latest` or specific versions (if available in brew as `@version`).
-   **List**: Uses `brew list --versions`.
-   **Link**: Automatically finds the installed binary (even keg-only ones) and symlinks it to `mise`'s shim path.
