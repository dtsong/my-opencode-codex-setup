#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STATE_PATH="$HOME/.config/opencode/profiles-enabled.json"

usage() {
  cat <<'EOF'
Usage: council-lite.sh <command> [args]

Commands:
  status
      Show whether council-lite profile is enabled.

  start <goal>
      Create a council-lite session scaffold for the goal.

Examples:
  ./scripts/council-lite.sh status
  ./scripts/council-lite.sh start "Design safe billing webhooks"
EOF
}

is_profile_enabled() {
  local profile_id="$1"
  python3 - "$STATE_PATH" "$profile_id" <<'PY'
import json
import os
import sys

state_path, profile_id = sys.argv[1], sys.argv[2]
if not os.path.exists(state_path):
    raise SystemExit(1)

try:
    data = json.load(open(state_path, "r", encoding="utf-8"))
except Exception:
    raise SystemExit(1)

enabled = data.get("enabled_profiles", [])
raise SystemExit(0 if profile_id in enabled else 1)
PY
}

require_profile_enabled() {
  if ! is_profile_enabled "council-lite"; then
    echo "council-lite profile is not enabled."
    echo "Enable it with: ./install.sh --enable-profile council-lite"
    exit 1
  fi
}

recommend_agents() {
  local goal="$1"
  python3 - "$goal" <<'PY'
import re
import sys

goal = sys.argv[1].lower()
agents = ["architect", "craftsman", "skeptic"]

rules = [
    (r"deploy|release|incident|ops|monitor|ci|cd", "operator"),
    (r"doc|handover|adr|decision|writeup", "chronicler"),
    (r"research|evaluate|choose|library|vendor|compare", "scout"),
]

for pattern, agent in rules:
    if re.search(pattern, goal) and agent not in agents:
        agents.append(agent)

print(", ".join(agents[:4]))
PY
}

cmd_status() {
  if is_profile_enabled "council-lite"; then
    echo "council-lite profile: enabled"
  else
    echo "council-lite profile: disabled"
    echo "Enable it with: ./install.sh --enable-profile council-lite"
  fi
}

cmd_start() {
  local goal="${1:-}"
  if [[ -z "$goal" ]]; then
    echo "Goal is required."
    usage
    exit 1
  fi

  require_profile_enabled

  local outdir="$WORKSPACE/memory"
  local stamp
  stamp="$(date +%Y-%m-%d-%H%M)"
  local outfile="$outdir/COUNCIL-LITE-$stamp.md"
  local agents
  agents="$(recommend_agents "$goal")"

  mkdir -p "$outdir"

  cat >"$outfile" <<EOF
# Council Lite Session - $stamp

## Goal
$goal

## Recommended Agents
$agents

## Deliberation Flow
1. Position round: each selected agent proposes a solution.
2. Challenge round: each agent reviews one counter-position.
3. Converge round: merge to one implementation plan.

## Expected Outputs
- decision with rationale
- risks and mitigations
- ordered implementation steps
- verification commands

## Suggested Execution Prompt
Use these agents in order: $agents.
Ask each to produce one concise section, then merge into one action plan.
EOF

  echo "Council-lite session created: $outfile"
}

main() {
  local command="${1:-}"
  case "$command" in
    "" | "-h" | "--help")
      usage
      ;;
    status)
      cmd_status
      ;;
    start)
      shift
      cmd_start "$@"
      ;;
    *)
      echo "Unknown command: $command"
      usage
      exit 1
      ;;
  esac
}

main "$@"
