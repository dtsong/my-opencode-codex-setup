#!/bin/bash
set -euo pipefail

REPO_DIR="$(cd "$(dirname "$0")" && pwd)"
TARGET_DIR="$HOME/.config/opencode"
PROFILES_DIR="$REPO_DIR/profiles"
REGISTRY_PATH="$PROFILES_DIR/registry.json"
STATE_PATH="$TARGET_DIR/profiles-enabled.json"
CONFLICT_POLICY="fail"

MANAGED_ITEMS=(
  "agents"
  "skills"
  "commands"
  "scripts"
  "workspaces"
  "docs"
  "config"
)

usage() {
  cat <<EOF
Usage: install.sh [option]

Default:
  ./install.sh
      Install using current profile state. If no state exists, install core.

Profile management:
  --list-profiles                 List available profiles.
  --status                        Show enabled profiles and state location.
  --profiles <csv>                Set enabled profiles (dependencies auto-added).
  --enable-profile <id>           Enable one profile.
  --disable-profile <id>          Disable one profile (core cannot be disabled).
  --conflict-policy <fail|skip>   Behavior when target path already exists.

Other:
  --uninstall                     Remove managed symlinks and profile state.
  -h, --help                      Show this help.
EOF
}

collect_conflicts() {
  mkdir -p "$TARGET_DIR"
  local conflicts=()
  local item
  for item in "${MANAGED_ITEMS[@]}"; do
    local target_path="$TARGET_DIR/$item"
    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
      conflicts+=("$target_path")
    fi
  done

  if [[ "${#conflicts[@]}" -eq 0 ]]; then
    return 0
  fi

  echo "Detected install path conflicts:"
  for path in "${conflicts[@]}"; do
    echo "- $path"
  done
  echo ""
  echo "Conflicts happen when files/directories already exist and are not symlinks."
  echo "Recommended: move or remove conflicting paths, then rerun ./install.sh"

  if [[ "$CONFLICT_POLICY" == "fail" ]]; then
    echo ""
    echo "Aborting install due to conflict policy: fail"
    echo "To proceed without replacing conflicting paths, rerun with:"
    echo "  ./install.sh --conflict-policy skip"
    return 1
  fi

  echo ""
  echo "Continuing with conflict policy: skip"
  echo "Only non-conflicting paths will be linked."
  return 0
}

require_registry() {
  if [[ ! -f "$REGISTRY_PATH" ]]; then
    echo "Profile registry missing: $REGISTRY_PATH"
    exit 1
  fi
}

assert_profile_exists() {
  local profile_id="$1"
  require_registry
  if ! python3 - "$REGISTRY_PATH" "$profile_id" <<'PY'; then
import json
import sys

registry_path, profile_id = sys.argv[1], sys.argv[2]
registry = json.load(open(registry_path, "r", encoding="utf-8"))
ids = {p["id"] for p in registry.get("profiles", [])}
raise SystemExit(0 if profile_id in ids else 1)
PY
    echo "Unknown profile: $profile_id"
    echo "Use --list-profiles to view valid profile IDs."
    exit 1
  fi
}

list_profiles() {
  require_registry
  python3 - "$REGISTRY_PATH" <<'PY'
import json
import sys

registry_path = sys.argv[1]
data = json.load(open(registry_path, "r", encoding="utf-8"))
profiles = data.get("profiles", [])

print("Available profiles")
for p in profiles:
    print(f"- {p['id']} ({p['stability']}): {p.get('description', '')}")
PY
}

load_enabled_profiles() {
  require_registry
  python3 - "$REGISTRY_PATH" "$STATE_PATH" <<'PY'
import json
import os
import sys

registry_path, state_path = sys.argv[1], sys.argv[2]
registry = json.load(open(registry_path, "r", encoding="utf-8"))
valid_ids = {p["id"] for p in registry.get("profiles", [])}

if os.path.exists(state_path):
    state = json.load(open(state_path, "r", encoding="utf-8"))
    enabled = state.get("enabled_profiles", [])
else:
    enabled = ["core"]

enabled = [p for p in enabled if p in valid_ids]
if not enabled:
    enabled = ["core"]

print(",".join(enabled))
PY
}

resolve_profiles_csv() {
  local csv="$1"
  require_registry
  python3 - "$REGISTRY_PATH" "$csv" <<'PY'
import json
import sys

registry_path, csv = sys.argv[1], sys.argv[2]
registry = json.load(open(registry_path, "r", encoding="utf-8"))
profiles = registry.get("profiles", [])
profile_map = {p["id"]: p for p in profiles}
order = [p["id"] for p in profiles]

requested = [s.strip() for s in csv.split(",") if s.strip()]
if not requested:
    requested = ["core"]

for p in requested:
    if p not in profile_map:
        print(f"Unknown profile: {p}", file=sys.stderr)
        sys.exit(2)

resolved = []
seen = set()

def add_with_deps(pid):
    if pid in seen:
        return
    for dep in profile_map[pid].get("depends_on", []):
        if dep not in profile_map:
            print(f"Invalid dependency in registry: {pid} -> {dep}", file=sys.stderr)
            sys.exit(3)
        add_with_deps(dep)
    seen.add(pid)
    resolved.append(pid)

for pid in requested:
    add_with_deps(pid)

resolved_sorted = [pid for pid in order if pid in resolved]
print(",".join(resolved_sorted))
PY
}

save_state_csv() {
  local csv="$1"
  mkdir -p "$TARGET_DIR"
  python3 - "$STATE_PATH" "$csv" <<'PY'
import json
import sys
from datetime import datetime, timezone

state_path, csv = sys.argv[1], sys.argv[2]
enabled = [s.strip() for s in csv.split(",") if s.strip()]

state = {
    "version": 1,
    "enabled_profiles": enabled,
    "updated_at": datetime.now(timezone.utc).isoformat().replace("+00:00", "Z"),
}

with open(state_path, "w", encoding="utf-8") as f:
    json.dump(state, f, indent=2)
    f.write("\n")
PY
}

print_status() {
  require_registry
  local enabled_csv
  enabled_csv="$(load_enabled_profiles)"
  python3 - "$REGISTRY_PATH" "$enabled_csv" "$STATE_PATH" <<'PY'
import json
import os
import sys

registry_path, enabled_csv, state_path = sys.argv[1], sys.argv[2], sys.argv[3]
registry = json.load(open(registry_path, "r", encoding="utf-8"))
enabled = {s.strip() for s in enabled_csv.split(",") if s.strip()}

print("Profile status")
for p in registry.get("profiles", []):
    status = "enabled" if p["id"] in enabled else "disabled"
    print(f"- {p['id']} ({p['stability']}): {status}")

print("")
print(f"Profile state file: {state_path}")
if not os.path.exists(state_path):
    print("State file is not created yet. It will be written on install.")

if "council-research" in enabled:
    print("")
    print("Warning: council-research is EXPERIMENTAL / EARLY AVAILABILITY.")
    print("- Behavior and interfaces may change without notice.")
    print("- Battle testing is in progress.")
    print("- Not recommended as your only daily-driver profile.")
PY
}

link_managed_items() {
  mkdir -p "$TARGET_DIR"
  local had_conflict=0
  echo "Linking $REPO_DIR -> $TARGET_DIR"
  for item in "${MANAGED_ITEMS[@]}"; do
    local target_path="$TARGET_DIR/$item"
    if [[ -e "$target_path" && ! -L "$target_path" ]]; then
      echo "  conflict: $target_path exists and is not a symlink"
      echo "  skipped linking $item (move/remove conflicting path, then re-run install)"
      had_conflict=1
      continue
    fi
    ln -sfn "$REPO_DIR/$item" "$target_path"
    echo "  $target_path -> $REPO_DIR/$item"
  done

  if [[ "$had_conflict" -eq 1 ]]; then
    echo ""
    echo "Install completed with conflicts."
    echo "Resolve conflicting non-symlink paths and re-run ./install.sh"
  fi
}

install_with_csv() {
  local requested_csv="$1"
  local resolved_csv
  resolved_csv="$(resolve_profiles_csv "$requested_csv")" || {
    echo "Use --list-profiles to view valid profile IDs."
    exit 1
  }

  collect_conflicts || exit 1

  save_state_csv "$resolved_csv"
  link_managed_items

  echo "Enabled profiles: $resolved_csv"
  if [[ "$resolved_csv" == *"council-research"* ]]; then
    echo ""
    echo "Warning: council-research is EXPERIMENTAL / EARLY AVAILABILITY."
    echo "- Behavior and interfaces may change without notice."
    echo "- Battle testing is in progress."
    echo "- Not recommended as your only daily-driver profile."
  fi

  echo ""
  echo "Profile state saved: $STATE_PATH"
}

enable_profile() {
  local profile_id="$1"
  assert_profile_exists "$profile_id"
  local current_csv
  current_csv="$(load_enabled_profiles)"
  local merged_csv="$current_csv"
  if [[ -n "$merged_csv" ]]; then
    merged_csv="$merged_csv,$profile_id"
  else
    merged_csv="$profile_id"
  fi
  install_with_csv "$merged_csv"
}

disable_profile() {
  local profile_id="$1"
  assert_profile_exists "$profile_id"
  if [[ "$profile_id" == "core" ]]; then
    echo "Cannot disable core. Use --uninstall to remove this setup."
    exit 1
  fi

  local current_csv
  current_csv="$(load_enabled_profiles)"

  local updated_csv
  updated_csv="$(
    python3 - "$current_csv" "$profile_id" <<'PY'
import sys

current_csv, profile_id = sys.argv[1], sys.argv[2]
enabled = [s.strip() for s in current_csv.split(",") if s.strip()]
filtered = [p for p in enabled if p != profile_id]
if not filtered:
    filtered = ["core"]
print(",".join(filtered))
PY
  )"

  install_with_csv "$updated_csv"
}

uninstall_all() {
  echo "Removing managed symlinks from $TARGET_DIR..."
  for item in "${MANAGED_ITEMS[@]}"; do
    link="$TARGET_DIR/$item"
    if [[ -L "$link" ]]; then
      rm "$link"
      echo "  removed $link"
    fi

    legacy_nested_link="$TARGET_DIR/$item/$item"
    if [[ -L "$legacy_nested_link" ]]; then
      rm "$legacy_nested_link"
      echo "  removed legacy nested symlink $legacy_nested_link"
    fi
  done

  if [[ -f "$STATE_PATH" ]]; then
    rm "$STATE_PATH"
    echo "  removed $STATE_PATH"
  fi

  if [[ -d "$TARGET_DIR" ]]; then
    if rmdir "$TARGET_DIR" 2>/dev/null; then
      echo "  removed empty directory $TARGET_DIR"
    fi
  fi

  echo "Done."
}

main() {
  while [[ $# -gt 0 ]]; do
    case "$1" in
      --conflict-policy)
        if [[ -z "${2:-}" ]]; then
          echo "Error: --conflict-policy requires a value (fail|skip)."
          usage
          exit 1
        fi
        if [[ "$2" != "fail" && "$2" != "skip" ]]; then
          echo "Error: invalid --conflict-policy value: $2"
          usage
          exit 1
        fi
        CONFLICT_POLICY="$2"
        shift 2
        ;;
      *)
        break
        ;;
    esac
  done

  case "${1:-}" in
    "")
      install_with_csv "$(load_enabled_profiles)"
      ;;
    --list-profiles)
      list_profiles
      ;;
    --status)
      print_status
      ;;
    --profiles)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --profiles requires a comma-separated value."
        usage
        exit 1
      fi
      install_with_csv "$2"
      ;;
    --enable-profile)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --enable-profile requires a profile ID."
        usage
        exit 1
      fi
      enable_profile "$2"
      ;;
    --disable-profile)
      if [[ -z "${2:-}" ]]; then
        echo "Error: --disable-profile requires a profile ID."
        usage
        exit 1
      fi
      disable_profile "$2"
      ;;
    --conflict-policy)
      echo "Error: --conflict-policy must be combined with an install action."
      usage
      exit 1
      ;;
    --uninstall)
      uninstall_all
      ;;
    -h | --help)
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
}

main "$@"
