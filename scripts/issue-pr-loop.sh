#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"

usage() {
  cat << 'EOF'
Usage: issue-pr-loop.sh <command> [args]

Commands:
  start <issue-number> [base-branch]
      Create a feature branch from base branch using issue metadata.

  pr <issue-number> [base-branch]
      Push current branch and create a draft PR that closes the issue.

Examples:
  issue-pr-loop.sh start 42 main
  issue-pr-loop.sh pr 42 main
EOF
}

require_gh() {
  if ! command -v gh >/dev/null 2>&1; then
    echo "gh CLI is required"
    exit 1
  fi
  gh auth status >/dev/null
}

slugify() {
  python3 - << 'PY'
import re
import sys
text = sys.stdin.read().strip().lower()
text = re.sub(r"[^a-z0-9]+", "-", text)
text = re.sub(r"-+", "-", text).strip("-")
print(text[:40] if text else "issue")
PY
}

cmd_start() {
  local issue="$1"
  local base="${2:-main}"
  require_gh

  local title
  title="$(gh issue view "$issue" --json title --jq '.title')"
  local slug
  slug="$(printf '%s' "$title" | slugify)"
  local branch="feat/issue-${issue}-${slug}"

  git -C "$WORKSPACE" fetch origin
  git -C "$WORKSPACE" checkout "$base"
  git -C "$WORKSPACE" pull --ff-only origin "$base"
  git -C "$WORKSPACE" checkout -b "$branch"

  echo "Created branch: $branch"
  echo "Issue: #$issue - $title"
}

cmd_pr() {
  local issue="$1"
  local base="${2:-main}"
  require_gh

  local branch
  branch="$(git -C "$WORKSPACE" branch --show-current)"
  local issue_title
  issue_title="$(gh issue view "$issue" --json title --jq '.title')"

  git -C "$WORKSPACE" push -u origin "$branch"

  gh pr create \
    --base "$base" \
    --head "$branch" \
    --draft \
    --title "${issue_title}" \
    --body "$(cat <<EOF
Closes #$issue

## Summary
- Implement issue #$issue.

## Testing
- [ ] Add commands run locally
EOF
)"
}

main() {
  local command="${1:-}"
  case "$command" in
    ""|"-h"|"--help")
      usage
      ;;
    start)
      if [[ -z "${2:-}" ]]; then
        echo "Issue number required"
        usage
        exit 1
      fi
      cmd_start "$2" "${3:-main}"
      ;;
    pr)
      if [[ -z "${2:-}" ]]; then
        echo "Issue number required"
        usage
        exit 1
      fi
      cmd_pr "$2" "${3:-main}"
      ;;
    *)
      echo "Unknown command: $command"
      usage
      exit 1
      ;;
  esac
}

main "$@"
