#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
COUNCIL_DIR="$WORKSPACE/memory/council-lite"
INDEX_PATH="$COUNCIL_DIR/index.json"

usage() {
  cat <<'EOF'
Usage: validate-council-lite.sh [--latest | <session-id> | <session-path>]

Examples:
  ./scripts/validate-council-lite.sh --latest
  ./scripts/validate-council-lite.sh 20260211-150000-design-safe-billing-webhooks
  ./scripts/validate-council-lite.sh memory/council-lite/20260211-150000-design-safe-billing-webhooks
EOF
}

resolve_session_path() {
  local input="${1:-}"
  python3 - "$INDEX_PATH" "$COUNCIL_DIR" "$input" <<'PY'
import json
import os
import sys
from pathlib import Path

index_path = Path(sys.argv[1])
council_dir = Path(sys.argv[2])
input_value = sys.argv[3].strip()

if not index_path.exists():
    raise SystemExit("No council-lite index found. Run council-lite first.")

data = json.loads(index_path.read_text(encoding="utf-8"))
sessions = data.get("sessions", [])
if not sessions:
    raise SystemExit("No council-lite sessions found in index.")

if input_value in ("", "--latest"):
    print(sessions[-1]["path"])
    raise SystemExit(0)

input_path = Path(input_value)
if input_path.exists() and input_path.is_dir():
    print(str(input_path.resolve()))
    raise SystemExit(0)

for session in sessions:
    if session.get("id") == input_value:
        print(session.get("path", ""))
        raise SystemExit(0)

candidate = council_dir / input_value
if candidate.exists() and candidate.is_dir():
    print(str(candidate.resolve()))
    raise SystemExit(0)

raise SystemExit(f"Session not found: {input_value}")
PY
}

main() {
  case "${1:-}" in
    -h | --help)
      usage
      exit 0
      ;;
  esac

  local selector="${1:---latest}"
  local session_path
  session_path="$(resolve_session_path "$selector")"

  python3 - "$session_path" <<'PY'
import sys
from pathlib import Path

session_path = Path(sys.argv[1])
required_files = [
    "session.md",
    "intake.md",
    "assembly.md",
    "deliberation/round1-position.md",
    "deliberation/round2-challenge.md",
    "deliberation/round3-converge.md",
    "plan.md",
]

missing = [f for f in required_files if not (session_path / f).is_file()]
if missing:
    print("Validation failed: missing required files")
    for item in missing:
        print(f"- {item}")
    raise SystemExit(1)

checks = {
    "session.md": ["# Council Lite Session", "Session ID:", "Goal:"],
    "intake.md": ["# Intake", "## Goal", "## Success Criteria"],
    "assembly.md": ["# Assembly", "## Recommended Agents", "## Selection Rationale"],
    "deliberation/round1-position.md": ["# Round 1 - Position"],
    "deliberation/round2-challenge.md": ["# Round 2 - Challenge"],
    "deliberation/round3-converge.md": ["# Round 3 - Converge"],
    "plan.md": ["# Execution Plan", "## Ordered Steps", "## Verification"],
}

errors = []
for rel_path, required_tokens in checks.items():
    text = (session_path / rel_path).read_text(encoding="utf-8")
    for token in required_tokens:
        if token not in text:
            errors.append(f"{rel_path}: missing token '{token}'")

if errors:
    print("Validation failed: content checks did not pass")
    for err in errors:
        print(f"- {err}")
    raise SystemExit(1)

print(f"Council-lite artifact validation passed: {session_path}")
PY
}

main "$@"
