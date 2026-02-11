#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

usage() {
  cat << 'EOF'
Usage: git-porcelain.sh <command> [args]

Commands:
  status
      Show branch, staged/unstaged summary, and recent commits.

  save <commit-message>
      Stage all tracked and untracked files, then commit.

  branch <branch-name>
      Create and switch to a new branch.

  sync [base-branch]
      Fetch origin and rebase current branch on origin/<base-branch>.
      Default base-branch: main

  pr-draft [base-branch] [title]
      Create a draft PR using gh CLI from current branch.
      Default base-branch: main

Examples:
  git-porcelain.sh status
  git-porcelain.sh save "feat: add workflow checks"
  git-porcelain.sh branch feat/ops-check
  git-porcelain.sh sync main
  git-porcelain.sh pr-draft main "feat: add ops-check workflow"
EOF
}

is_sensitive_path() {
  local path="$1"
  case "$path" in
    *.pem|*.key|*.p12|*.pfx|*.kube/config|*.env|*.env.*|*credentials*.json|*secrets*.json)
      return 0
      ;;
    *)
      return 1
      ;;
  esac
}

cmd_status() {
  git -C "$WORKSPACE" status --short --branch
  echo
  echo "# Staged diff"
  git -C "$WORKSPACE" diff --staged || true
  echo
  echo "# Unstaged diff"
  git -C "$WORKSPACE" diff || true
  echo
  echo "# Recent commits"
  git -C "$WORKSPACE" log --oneline -n 8
}

cmd_save() {
  local message="${1:-}"
  if [[ -z "$message" ]]; then
    echo "Error: commit message is required"
    usage
    exit 1
  fi

  git -C "$WORKSPACE" add -A

  if git -C "$WORKSPACE" diff --cached --quiet; then
    echo "No staged changes to commit."
    exit 0
  fi

  mapfile -t staged_paths < <(git -C "$WORKSPACE" diff --cached --name-only)
  for p in "${staged_paths[@]}"; do
    if is_sensitive_path "$p"; then
      echo "Refusing to commit possible secret file: $p"
      echo "Unstage it manually and retry."
      exit 1
    fi
  done

  git -C "$WORKSPACE" commit -m "$message"
}

cmd_branch() {
  local name="${1:-}"
  if [[ -z "$name" ]]; then
    echo "Error: branch name is required"
    usage
    exit 1
  fi
  git -C "$WORKSPACE" checkout -b "$name"
}

cmd_sync() {
  local base="${1:-main}"
  git -C "$WORKSPACE" fetch origin
  git -C "$WORKSPACE" rebase "origin/$base"
}

cmd_pr_draft() {
  local base="${1:-main}"
  local title="${2:-}"

  if ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI is required for pr-draft"
    exit 1
  fi

  gh auth status >/dev/null

  local branch
  branch="$(git -C "$WORKSPACE" branch --show-current)"

  if [[ -z "$title" ]]; then
    title="$(git -C "$WORKSPACE" log -1 --pretty=%s)"
  fi

  git -C "$WORKSPACE" push -u origin "$branch"

  gh pr create \
    --base "$base" \
    --head "$branch" \
    --draft \
    --title "$title" \
    --body "$(cat <<'EOF'
## Summary
- Describe the intent and context.

## Testing
- [ ] Add the validation commands you ran.
EOF
)"
}

main() {
  local command="${1:-}"
  case "$command" in
    ""|"-h"|"--help")
      usage
      ;;
    status)
      cmd_status
      ;;
    save)
      shift
      cmd_save "$@"
      ;;
    branch)
      shift
      cmd_branch "$@"
      ;;
    sync)
      shift
      cmd_sync "$@"
      ;;
    pr-draft)
      shift
      cmd_pr_draft "$@"
      ;;
    *)
      echo "Unknown command: $command"
      usage
      exit 1
      ;;
  esac
}

main "$@"
