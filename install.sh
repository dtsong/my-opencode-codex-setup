#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.config/opencode"

if [[ "${1:-}" == "--uninstall" ]]; then
  echo "Removing managed symlinks from $TARGET_DIR..."
  for item in agents skills commands scripts workspaces docs config; do
    link="$TARGET_DIR/$item"
    if [[ -L "$link" ]]; then
      rm "$link"
      echo "  removed $link"
    fi
  done
  echo "Done."
  exit 0
fi

mkdir -p "$TARGET_DIR"

items=(
  "agents"
  "skills"
  "commands"
  "scripts"
  "workspaces"
  "docs"
  "config"
)

echo "Linking $REPO_DIR -> $TARGET_DIR"
for item in "${items[@]}"; do
  ln -sfn "$REPO_DIR/$item" "$TARGET_DIR/$item"
  echo "  $TARGET_DIR/$item -> $REPO_DIR/$item"
done

echo "Done."
