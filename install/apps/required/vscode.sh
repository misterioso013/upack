#!/usr/bin/env bash

set -e
echo "Configuring VSCode..."
bash "$UPACK_DIR/config/vscode/config.sh"
bash "$UPACK_DIR/utils/fonts.sh"