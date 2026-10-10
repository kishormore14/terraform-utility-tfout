#!/usr/bin/env bash
# Automatic cross-platform binary resolver for tfout Terraform module
set -euo pipefail

VERSION="${1:-v0.1.0}"
PREFIX="${2:-https://github.com/tfout/tfout/releases/download}"

# Check if tfout is on PATH
if command -v tfout &>/dev/null; then
  echo "{\"binary_path\": \"$(command -v tfout)\"}"
  exit 0
fi

# Target directory for local binary download
BIN_DIR="${PATH_DIR:-.tfout/bin}"
mkdir -p "${BIN_DIR}"

OS=$(uname -s | tr '[:upper:]' '[:lower:]')
ARCH=$(uname -m)

case "${ARCH}" in
  x86_64|amd64) ARCH="amd64" ;;
  aarch64|arm64) ARCH="arm64" ;;
  *) echo "Unsupported architecture: ${ARCH}" >&2; exit 1 ;;
esac

BINARY_NAME="tfout_${VERSION}_${OS}_${ARCH}"
TARGET_PATH="${BIN_DIR}/tfout_${VERSION}"

if [ ! -f "${TARGET_PATH}" ]; then
  URL="${PREFIX}/${VERSION}/${BINARY_NAME}"
  if command -v curl &>/dev/null; then
    curl -sSL "${URL}" -o "${TARGET_PATH}" || true
  elif command -v wget &>/dev/null; then
    wget -qO "${TARGET_PATH}" "${URL}" || true
  fi

  if [ -f "${TARGET_PATH}" ]; then
    chmod +x "${TARGET_PATH}"
  fi
fi

if [ -f "${TARGET_PATH}" ]; then
  echo "{\"binary_path\": \"${TARGET_PATH}\"}"
else
  # Fallback to tfout if present
  echo "{\"binary_path\": \"tfout\"}"
fi
