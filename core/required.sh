#!/usr/bin/env bash

set -e

echo "🔧 Installing required apps..."

for file in install/apps/required/*.sh; do
  echo "🚀 Running $(basename "$file")"
  bash "$file"
done
