#!/usr/bin/env bash

set -e

OPTIONAL_APPS=($(basename -s .sh install/apps/optional/*.sh))

selected=$(printf "%s\n" "${OPTIONAL_APPS[@]}" | gum choose --no-limit --height 15)

for app in $selected; do
  echo "📦 Installing $app..."
  bash "install/apps/optional/${app}.sh"
done