#!/usr/bin/env bash
# ==============================================================================
#  OMNI CLI — Universal Installer
# ==============================================================================

set -e

INSTALL_DIR="${XDG_DATA_HOME:-$HOME/.local/share}/omni"
BIN_DIR="${HOME}/.local/bin"

if [ -n "${TERMUX_VERSION:-}" ] || [ -d "/data/data/com.termux" ]; then
  BIN_DIR="${HOME}/bin"
fi

mkdir -p "$BIN_DIR"

echo "==> Installing OMNI CLI..."

if [ -d "$INSTALL_DIR/.git" ]; then
  cd "$INSTALL_DIR" && git pull --rebase origin main
else
  rm -rf "$INSTALL_DIR"
  git clone https://github.com/dragpk247/omni-cli.git "$INSTALL_DIR"
fi

# Link binaries
chmod +x "$INSTALL_DIR"/bin/*
for f in "$INSTALL_DIR"/bin/*; do
  bname=$(basename "$f")
  ln -sf "$f" "$BIN_DIR/$bname"
done

echo ""
echo "==> OMNI CLI successfully installed to $BIN_DIR/omni!"
echo "==> Run 'omni setup' to configure your multi-device mesh."
