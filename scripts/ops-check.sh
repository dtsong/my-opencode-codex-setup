#!/bin/bash
set -euo pipefail

WORKSPACE="$(git rev-parse --show-toplevel 2>/dev/null || pwd)"
FAILURES=0

usage() {
  cat << 'EOF'
Usage: ops-check.sh [--strict]

Runs stack-aware quality checks for Node.js, Python, and Terraform when detected.

Options:
  --strict   Return non-zero if any check is skipped due to missing tools.
EOF
}

STRICT=0
if [[ "${1:-}" == "--help" || "${1:-}" == "-h" ]]; then
  usage
  exit 0
fi
if [[ "${1:-}" == "--strict" ]]; then
  STRICT=1
fi

SKIPPED=0

print_header() {
  echo
  echo "== $1 =="
}

run_check() {
  local label="$1"
  shift
  echo "-> $label"
  if "$@"; then
    echo "   PASS"
  else
    echo "   FAIL"
    FAILURES=$((FAILURES + 1))
  fi
}

skip_check() {
  local label="$1"
  echo "-> $label"
  echo "   SKIP"
  SKIPPED=$((SKIPPED + 1))
}

has_file() {
  [[ -f "$WORKSPACE/$1" ]]
}

has_tool() {
  command -v "$1" >/dev/null 2>&1
}

node_has_script() {
  local key="$1"
  python3 - << PY
import json
from pathlib import Path
pkg = Path("$WORKSPACE/package.json")
if not pkg.exists():
    raise SystemExit(1)
data = json.loads(pkg.read_text())
scripts = data.get("scripts", {})
if "$key" in scripts:
    raise SystemExit(0)
raise SystemExit(1)
PY
}

run_node_cmd() {
  local cmd="$1"
  bash -lc "source ~/.nvm/nvm.sh && nvm use default --silent && $cmd"
}

check_node() {
  if ! has_file "package.json"; then
    return
  fi

  print_header "Node.js"

  if [[ -f "$HOME/.nvm/nvm.sh" ]]; then
    if node_has_script "build"; then
      run_check "npm run build" run_node_cmd "npm run build"
    else
      skip_check "npm run build"
    fi

    if node_has_script "typecheck"; then
      run_check "npm run typecheck" run_node_cmd "npm run typecheck"
    elif node_has_script "type-check"; then
      run_check "npm run type-check" run_node_cmd "npm run type-check"
    else
      skip_check "npm run typecheck"
    fi

    if node_has_script "lint"; then
      run_check "npm run lint" run_node_cmd "npm run lint"
    else
      skip_check "npm run lint"
    fi

    if node_has_script "test"; then
      run_check "npm test" run_node_cmd "npm test"
    else
      skip_check "npm test"
    fi
  else
    skip_check "Node checks (nvm not found at ~/.nvm/nvm.sh)"
  fi
}

check_python() {
  if ! has_file "pyproject.toml" && ! has_file "requirements.txt"; then
    return
  fi

  print_header "Python"

  if has_tool "ruff"; then
    run_check "ruff check ." ruff check "$WORKSPACE"
  else
    skip_check "ruff check ."
  fi

  if has_tool "pytest"; then
    run_check "pytest -q" pytest -q "$WORKSPACE"
  else
    skip_check "pytest -q"
  fi

  if has_tool "mypy"; then
    run_check "mypy ." mypy "$WORKSPACE"
  else
    skip_check "mypy ."
  fi
}

check_terraform() {
  if ! compgen -G "$WORKSPACE/*.tf" > /dev/null; then
    return
  fi

  print_header "Terraform"

  if has_tool "terraform"; then
    run_check "terraform fmt -check -recursive" terraform -chdir="$WORKSPACE" fmt -check -recursive
    if [[ -d "$WORKSPACE/.terraform" ]]; then
      run_check "terraform validate" terraform -chdir="$WORKSPACE" validate
    else
      skip_check "terraform validate (run terraform init first)"
    fi
  else
    skip_check "Terraform checks (terraform CLI not installed)"
  fi
}

check_node
check_python
check_terraform

echo
echo "Summary: failures=$FAILURES skipped=$SKIPPED"

if [[ "$STRICT" -eq 1 && "$SKIPPED" -gt 0 ]]; then
  echo "Strict mode enabled and checks were skipped."
  exit 2
fi

if [[ "$FAILURES" -gt 0 ]]; then
  exit 1
fi
