#!/usr/bin/env sh
set -eu

SCRIPT_DIR="$(CDPATH= cd -- "$(dirname -- "$0")" && pwd)"
BIN_DIR="$SCRIPT_DIR/bin"
CONFIG_FILE="${1:-$SCRIPT_DIR/configs/config.local.yaml}"
MODE="${MODE:-local}"

if [ ! -f "$CONFIG_FILE" ]; then
  echo "Config file not found: $CONFIG_FILE"
  exit 1
fi

OS="$(uname -s | tr '[:upper:]' '[:lower:]')"
ARCH="$(uname -m)"

case "$ARCH" in
  x86_64|amd64)
    ARCH="amd64"
    ;;
  arm64|aarch64)
    ARCH="arm64"
    ;;
  *)
    echo "Unsupported architecture: $ARCH"
    exit 1
    ;;
esac

case "$OS" in
  darwin*)
    BIN="$BIN_DIR/forerouter-darwin-$ARCH"
    ;;
  linux*)
    BIN="$BIN_DIR/forerouter-linux-$ARCH"
    ;;
  *)
    echo "Unsupported OS for this script: $OS"
    echo "On Windows, use start-local.bat"
    exit 1
    ;;
esac

if [ ! -f "$BIN" ]; then
  echo "Binary not found: $BIN"
  echo "Please ensure the corresponding release binary exists in $BIN_DIR"
  exit 1
fi

if [ ! -x "$BIN" ]; then
  chmod +x "$BIN" 2>/dev/null || true
fi

echo "Starting Forerouter in $MODE mode"
echo "Binary : $BIN"
echo "Config : $CONFIG_FILE"

exec "$BIN" --mode="$MODE" --config "$CONFIG_FILE"
