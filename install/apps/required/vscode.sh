#!/usr/bin/env bash

set -e
echo "Configuring VSCode..."
bash config/vscode/config.sh
bash utils/fonts.sh