#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
STATE_PATH="$HOME/.config/opencode/profiles-enabled.json"
COUNCIL_DIR="$WORKSPACE/memory/council-lite"
INDEX_PATH="$COUNCIL_DIR/index.json"

usage() {
  cat <<'EOF'
Usage: council-lite.sh <command> [args]

Commands:
  status
      Show profile status and council-lite session stats.

  list
      List council-lite sessions in this workspace.

  run <goal>
      Run council-lite session initialization and generate structured artifacts.

  resume <session-id>
      Show artifact path and next steps for an existing session.

  start <goal>
      Alias for run.

Examples:
  ./scripts/council-lite.sh status
  ./scripts/council-lite.sh list
  ./scripts/council-lite.sh run "Design safe billing webhooks"
  ./scripts/council-lite.sh resume 20260211-150000-design-safe-billing-webhooks
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

ensure_index() {
  mkdir -p "$COUNCIL_DIR"
  if [[ ! -f "$INDEX_PATH" ]]; then
    cat >"$INDEX_PATH" <<'EOF'
{
  "version": 1,
  "sessions": []
}
EOF
  fi
}

slugify() {
  local text="$1"
  python3 - "$text" <<'PY'
import re
import sys

text = sys.argv[1].strip().lower()
slug = re.sub(r"[^a-z0-9]+", "-", text).strip("-")
slug = slug[:40].strip("-")
if not slug:
    slug = "session"
print(slug)
PY
}

session_id_for_goal() {
  local goal="$1"
  local stamp
  stamp="$(date +%Y%m%d-%H%M%S)"
  local slug
  slug="$(slugify "$goal")"
  echo "${stamp}-${slug}"
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

append_session_index() {
  local session_id="$1"
  local goal="$2"
  local session_dir="$3"
  local agents_csv="$4"
  ensure_index
  python3 - "$INDEX_PATH" "$session_id" "$goal" "$session_dir" "$agents_csv" <<'PY'
import json
import sys
from datetime import datetime, timezone

index_path, session_id, goal, session_dir, agents_csv = sys.argv[1:6]
data = json.load(open(index_path, "r", encoding="utf-8"))
sessions = data.setdefault("sessions", [])

record = {
    "id": session_id,
    "goal": goal,
    "created_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
    "path": session_dir,
    "agents": [a.strip() for a in agents_csv.split(",") if a.strip()],
    "state": "initialized",
}
sessions.append(record)

with open(index_path, "w", encoding="utf-8") as f:
    json.dump(data, f, indent=2)
    f.write("\n")
PY
}

list_sessions_plain() {
  ensure_index
  python3 - "$INDEX_PATH" <<'PY'
import json
import sys

index_path = sys.argv[1]
data = json.load(open(index_path, "r", encoding="utf-8"))
sessions = data.get("sessions", [])

if not sessions:
    print("No council-lite sessions found.")
    raise SystemExit(0)

print("Council-lite sessions")
for s in reversed(sessions):
    print(f"- {s['id']} | {s.get('state', 'unknown')} | {s['goal']}")
PY
}

session_count() {
  ensure_index
  python3 - "$INDEX_PATH" <<'PY'
import json
import sys

index_path = sys.argv[1]
data = json.load(open(index_path, "r", encoding="utf-8"))
print(len(data.get("sessions", [])))
PY
}

find_session_path() {
  local session_id="$1"
  ensure_index
  python3 - "$INDEX_PATH" "$session_id" <<'PY'
import json
import sys

index_path, session_id = sys.argv[1], sys.argv[2]
data = json.load(open(index_path, "r", encoding="utf-8"))
for s in data.get("sessions", []):
    if s.get("id") == session_id:
        print(s.get("path", ""))
        raise SystemExit(0)
raise SystemExit(1)
PY
}

cmd_status() {
  local profile_state
  if is_profile_enabled "council-lite"; then
    profile_state="enabled"
  else
    profile_state="disabled"
  fi

  echo "council-lite profile: $profile_state"
  echo "workspace: $WORKSPACE"
  echo "session index: $INDEX_PATH"
  echo "session count: $(session_count)"

  if [[ "$profile_state" == "disabled" ]]; then
    echo "Enable it with: ./install.sh --enable-profile council-lite"
  fi
}

cmd_list() {
  list_sessions_plain
}

cmd_run() {
  local goal="${1:-}"
  if [[ -z "$goal" ]]; then
    echo "Goal is required."
    usage
    exit 1
  fi

  require_profile_enabled

  ensure_index

  local session_id
  session_id="$(session_id_for_goal "$goal")"
  local outdir="$COUNCIL_DIR/$session_id"
  local deliberation_dir="$outdir/deliberation"
  local stamp
  stamp="$(date '+%Y-%m-%d %H:%M:%S %Z')"
  local agents
  agents="$(recommend_agents "$goal")"
  local agents_bullets
  agents_bullets="$(printf '%s' "$agents" | sed 's/, /\n- /g')"
  agents_bullets="- $agents_bullets"

  mkdir -p "$deliberation_dir"

  cat >"$outdir/session.md" <<EOF
# Council Lite Session

- Session ID: $session_id
- Created: $stamp
- Goal: $goal
- Agents: $agents

## Artifact Map

- intake.md
- assembly.md
- deliberation/round1-position.md
- deliberation/round2-challenge.md
- deliberation/round3-converge.md
- plan.md
EOF

  cat >"$outdir/intake.md" <<EOF
# Intake

## Goal
$goal

## Constraints
- Add technical and organizational constraints here.

## Success Criteria
- Define 3-5 measurable outcomes.
EOF

  cat >"$outdir/assembly.md" <<EOF
# Assembly

## Recommended Agents
$agents_bullets

## Selection Rationale
- architect: system structure and integration points
- craftsman: implementation quality and testing approach
- skeptic: risk and failure-mode pressure testing

Add/remove agents based on domain needs before execution.
EOF

  cat >"$deliberation_dir/round1-position.md" <<EOF
# Round 1 - Position

Have each selected agent independently propose:
- core recommendation
- key argument
- top risks if ignored
- dependencies on other domains
EOF

  cat >"$deliberation_dir/round2-challenge.md" <<EOF
# Round 2 - Challenge

Pair tensions and force explicit responses:
- Maintain
- Modify
- Defer

Document what changed and why.
EOF

  cat >"$deliberation_dir/round3-converge.md" <<EOF
# Round 3 - Converge

Produce final merged position:
- final recommendation
- concessions
- non-negotiables
- implementation notes
EOF

  cat >"$outdir/plan.md" <<EOF
# Execution Plan

## Ordered Steps
1. Translate converged recommendation into implementation tasks.
2. Define verification commands and quality gates.
3. Capture rollout notes and rollback plan.

## Verification
- Add concrete commands for lint, test, build, and deploy checks.
EOF

  append_session_index "$session_id" "$goal" "$outdir" "$agents"

  echo "Council-lite session initialized: $outdir"
  echo "Start from: $outdir/intake.md"
  echo "When ready, run: ./scripts/council-lite.sh resume $session_id"
}

cmd_resume() {
  local session_id="${1:-}"
  if [[ -z "$session_id" ]]; then
    echo "Session ID is required."
    usage
    exit 1
  fi

  local session_path
  if ! session_path="$(find_session_path "$session_id")"; then
    echo "Session not found: $session_id"
    echo "Use ./scripts/council-lite.sh list to see available session IDs."
    exit 1
  fi

  echo "Session: $session_id"
  echo "Path: $session_path"
  echo "Next files to review:"
  echo "- $session_path/intake.md"
  echo "- $session_path/assembly.md"
  echo "- $session_path/deliberation/round1-position.md"
  echo "- $session_path/plan.md"
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
    list)
      cmd_list
      ;;
    run)
      shift
      cmd_run "$@"
      ;;
    resume)
      shift
      cmd_resume "$@"
      ;;
    start)
      shift
      cmd_run "$@"
      ;;
    *)
      echo "Unknown command: $command"
      usage
      exit 1
      ;;
  esac
}

main "$@"
