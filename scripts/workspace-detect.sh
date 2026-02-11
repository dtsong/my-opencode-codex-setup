#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
REMOTE="$(git -C "$WORKSPACE" remote get-url origin 2>/dev/null || true)"

if [[ -n "$REMOTE" ]]; then
  REPO_NAME="$(basename "$REMOTE")"
  REPO_NAME="${REPO_NAME%.git}"
else
  REPO_NAME="$(basename "$WORKSPACE")"
fi

echo "workspace=$WORKSPACE"
echo "repo_name=$REPO_NAME"
