# my-opencode-codex-setup

Portable OpenCode + Codex setup inspired by `my-claude-setup`.

This repository is a practical starter for:
- reusable agents
- structured skills
- workspace-aware project context
- session handover workflow
- command-style execution playbooks

## Quick Start

```bash
git clone https://github.com/<you>/my-opencode-codex-setup.git ~/Development/my-opencode-codex-setup
cd ~/Development/my-opencode-codex-setup
chmod +x install.sh
./install.sh
```

## What This Installs

`install.sh` creates symlinks into `~/.config/opencode/` so edits in this repo apply immediately.

## Directory Layout

```text
my-opencode-codex-setup/
├── agents/                 # OpenCode agent prompt files
├── skills/                 # Structured skill templates
├── commands/               # Reusable command/workflow prompts
├── scripts/                # Helper scripts (handover, workspace detection)
├── workspaces/             # Project-specific context templates
├── config/                 # OpenCode config examples
├── docs/                   # Migration and architecture notes
├── install.sh
├── CONTRIBUTING.md
└── LICENSE
```

## Roadmap

See `docs/roadmap.md`.

## Workflow Scripts

- `scripts/handover.sh` - create a session handover document
- `scripts/git-porcelain.sh` - status/save/sync/branch/pr helper
- `scripts/ops-check.sh` - stack-aware quality gate checks
- `scripts/issue-pr-loop.sh` - issue to branch to draft PR flow

See `docs/workflows-playbook.md` for usage patterns.
