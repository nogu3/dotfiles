#!/usr/bin/env bash
set -e

if [ "$(id -u)" -ne 0 ]; then
    echo -e 'Script must be run as root.'
    exit 1
fi

apt_get_update() {
    if [ "$(find /var/lib/apt/lists/* | wc -l)" = "0" ]; then
        echo "Running apt-get update..."
        apt-get update -y
    fi
}

check_packages() {
    if ! dpkg -s "$@" > /dev/null 2>&1; then
        apt_get_update
        apt-get -y install --no-install-recommends "$@"
    fi
}

check_packages curl git tar xz-utils ca-certificates ripgrep fd-find

if ! type fd > /dev/null 2>&1; then
    if type fdfind > /dev/null 2>&1; then
        ln -s $(which fdfind) /usr/local/bin/fd
    fi
fi

ARCH=$(uname -m)
HELIX_ARCH="$ARCH"
LAZYGIT_ARCH="$ARCH"

if [ "$ARCH" = "aarch64" ]; then
    LAZYGIT_ARCH="arm64"
elif [ "$ARCH" = "x86_64" ]; then
    LAZYGIT_ARCH="x86_64"
fi

# Install Helix
echo "Installing Helix..."
HELIX_TAG=$(curl -s "https://api.github.com/repos/helix-editor/helix/releases/latest" | grep '"tag_name":' | sed -E 's/.*"([^"]+)".*/\1/')
if [ -z "$HELIX_TAG" ]; then
    HELIX_TAG="24.07" # Fallback
    echo "Could not fetch latest Helix version, using fallback: $HELIX_TAG"
fi

echo "Downloading Helix $HELIX_TAG for $HELIX_ARCH..."
curl -L "https://github.com/helix-editor/helix/releases/download/$HELIX_TAG/helix-$HELIX_TAG-$HELIX_ARCH-linux.tar.xz" -o /tmp/helix.tar.xz

mkdir -p /tmp/helix
tar -xf /tmp/helix.tar.xz -C /tmp/helix --strip-components=1
install -m 755 /tmp/helix/hx /usr/local/bin/
mkdir -p /usr/local/lib/helix
# Remove old runtime if exists
rm -rf /usr/local/lib/helix/runtime
cp -r /tmp/helix/runtime /usr/local/lib/helix/
rm -rf /tmp/helix /tmp/helix.tar.xz

# Install Lazygit
echo "Installing Lazygit..."
LAZYGIT_TAG=$(curl -s "https://api.github.com/repos/jesseduffield/lazygit/releases/latest" | grep '"tag_name":' | sed -E 's/.*"v([^"]+)".*/\1/')
if [ -z "$LAZYGIT_TAG" ]; then
    LAZYGIT_TAG="0.44.1" # Fallback
     echo "Could not fetch latest Lazygit version, using fallback: $LAZYGIT_TAG"
fi

echo "Downloading Lazygit $LAZYGIT_TAG for $LAZYGIT_ARCH..."
curl -Lo lazygit.tar.gz "https://github.com/jesseduffield/lazygit/releases/download/v${LAZYGIT_TAG}/lazygit_${LAZYGIT_TAG}_Linux_${LAZYGIT_ARCH}.tar.gz"
tar xf lazygit.tar.gz lazygit
install lazygit /usr/local/bin
rm lazygit.tar.gz lazygit

# Copy Config
echo "Copying configuration..."
FEATURE_DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"

if [ -z "$_REMOTE_USER" ]; then
    _REMOTE_USER="root"
fi
if [ -z "$_REMOTE_USER_HOME" ]; then
    if [ "$_REMOTE_USER" = "root" ]; then
        _REMOTE_USER_HOME="/root"
    else
        _REMOTE_USER_HOME="/home/$_REMOTE_USER"
    fi
fi

# Create directory
mkdir -p "$_REMOTE_USER_HOME/.config/helix"

# Copy files
if [ -d "$FEATURE_DIR/config" ]; then
    cp -r "$FEATURE_DIR/config/"* "$_REMOTE_USER_HOME/.config/helix/"

    # Set permissions
    if [ "$_REMOTE_USER" != "root" ]; then
        chown -R "$_REMOTE_USER" "$_REMOTE_USER_HOME/.config/helix"
    fi
else
    echo "Warning: No config directory found at $FEATURE_DIR/config"
fi

echo "Done!"
# Updated description
