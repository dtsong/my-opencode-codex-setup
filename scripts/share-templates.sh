#!/bin/bash
set -euo pipefail

copy_dm() {
  cat <<'EOF' | pbcopy
Hey all - I am validating onboarding for my OpenCode/Codex setup and need 10-15 min testers.

Please run:
1) git clone https://github.com/dtsong/my-opencode-codex-setup.git
2) cd my-opencode-codex-setup
3) ./install.sh --conflict-policy skip --profiles core,council-lite
4) ./scripts/council-lite.sh run "Onboarding validation run"
5) ./scripts/council-lite.sh list
6) ./scripts/validate-council-lite.sh --latest
7) ./install.sh --uninstall

Then share:
- OS + shell
- outcome: success | partial | fail
- time-to-first-success (minutes)
- any confusing steps

Best: open an issue with the "Onboarding feedback" template here:
https://github.com/dtsong/my-opencode-codex-setup/issues/new/choose

Thank you.
EOF
  echo "Copied DM template to clipboard."
}

copy_discord_pin() {
  cat <<'EOF' | pbcopy
## Onboarding Validation Help Wanted (10-15 min)

I am collecting onboarding feedback for:
https://github.com/dtsong/my-opencode-codex-setup

### Goal
Verify a new user can go from clone to successful `council-lite` run quickly.

### Steps
```bash
git clone https://github.com/dtsong/my-opencode-codex-setup.git
cd my-opencode-codex-setup
./install.sh --conflict-policy skip --profiles core,council-lite
./scripts/council-lite.sh run "Onboarding validation run"
./scripts/council-lite.sh list
./scripts/validate-council-lite.sh --latest
./install.sh --uninstall
```

### Please report back
- OS + shell
- result (`success` | `partial` | `fail`)
- time-to-first-success (minutes)
- confusing or rough steps
- suggested improvements

### Feedback channel (preferred)
Open an issue using **Onboarding feedback**:
https://github.com/dtsong/my-opencode-codex-setup/issues/new/choose

Thank you - this directly helps move council-lite from beta toward stable.
EOF
  echo "Copied Discord pinned message template to clipboard."
}

usage() {
  cat <<'EOF'
Usage:
  source scripts/share-templates.sh
    Then call one of:
      copy_dm
      copy_discord_pin

  Or run directly:
      ./scripts/share-templates.sh --dm
      ./scripts/share-templates.sh --discord
EOF
}

if [[ "${BASH_SOURCE[0]}" == "$0" ]]; then
  case "${1:-}" in
    --dm)
      copy_dm
      ;;
    --discord)
      copy_discord_pin
      ;;
    -h | --help | "")
      usage
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
  esac
fi
