#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
OUTDIR="$WORKSPACE/memory"
STAMP="$(date +%Y-%m-%d-%H%M)"
OUTFILE="$OUTDIR/HANDOVER-$STAMP.md"

mkdir -p "$OUTDIR"

cat > "$OUTFILE" << EOF
# Session Handover - $STAMP

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
EOF

echo "Handover template created: $OUTFILE"
