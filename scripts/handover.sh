#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
OUTDIR="$WORKSPACE/memory"
STAMP="$(date +%Y-%m-%d-%H%M)"
OUTFILE="$OUTDIR/HANDOVER-$STAMP.md"

if [[ "${1:-}" == "--help" ]]; then
  cat <<'EOF'
Usage: handover.sh [--print]

Creates a handover markdown file in memory/ with a repository snapshot.

Options:
  --print    Print the generated file path and file contents
EOF
  exit 0
fi

mkdir -p "$OUTDIR"

BRANCH="$(git -C "$WORKSPACE" branch --show-current 2>/dev/null || echo "n/a")"
STATUS="$(git -C "$WORKSPACE" status --short 2>/dev/null || true)"
COMMITS="$(git -C "$WORKSPACE" log --oneline -n 5 2>/dev/null || true)"

if [[ -z "$STATUS" ]]; then
  STATUS="(clean working tree)"
fi

if [[ -z "$COMMITS" ]]; then
  COMMITS="(no commits yet)"
fi

cat >"$OUTFILE" <<EOF
# Session Handover - $STAMP

## Workspace Snapshot
- Path: $WORKSPACE
- Branch: $BRANCH

## Session Summary
TBD

## What Was Done
- TBD

## Key Decisions
- TBD

## Open Questions
- None

## Next Steps
1. TBD

## Git Snapshot

### Recent Commits

\`\`\`text
$COMMITS
\`\`\`

### Working Tree

\`\`\`text
$STATUS
\`\`\`
EOF

echo "Handover template created: $OUTFILE"

if [[ "${1:-}" == "--print" ]]; then
  echo
  cat "$OUTFILE"
fi
