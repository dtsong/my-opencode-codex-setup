# my-opencode-codex-setup

Portable OpenCode + Codex setup inspired by `my-claude-setup`.

This repository is for people who use OpenCode and want a reproducible, versioned setup they can reuse across machines:
- reusable agents
- structured skills
- workspace-aware project context
- session handover workflow
- command-style execution playbooks

## Prerequisites

- OpenCode installed: https://opencode.ai/docs (install script: https://opencode.ai/install)
- `git`, `bash`, and `python3` available on your PATH
- Optional (contributors): `pre-commit`
- Optional (GitHub workflows): `gh` authenticated (`gh auth login`)

## Quick Start

```bash
git clone https://github.com/<you>/my-opencode-codex-setup.git ~/Development/my-opencode-codex-setup
cd ~/Development/my-opencode-codex-setup
chmod +x install.sh
./install.sh
```

Verify it worked:

```bash
./install.sh --status
./scripts/ops-check.sh
```

## Profiles

This setup supports optional profiles:

- `core` (`stable`) - default practical setup
- `council-lite` (`beta`) - lightweight advanced orchestration layer (`commands/council-lite.md`)
- `council-research` (`experimental`) - early availability research mode under active battle testing

Common commands:

```bash
# list available profiles
./install.sh --list-profiles

# show enabled/disabled profiles and state location
./install.sh --status

# set exact profiles (dependencies auto-added)
./install.sh --profiles core,council-lite

# choose conflict behavior when target paths already exist
./install.sh --conflict-policy fail --profiles core,council-lite
./install.sh --conflict-policy skip --profiles core,council-lite

# enable or disable one profile
./install.sh --enable-profile council-lite
./install.sh --disable-profile council-lite

# start a council-lite session scaffold
./scripts/council-lite.sh run "Design safe billing webhooks"
./scripts/council-lite.sh list
./scripts/validate-council-lite.sh --latest
```

Profile state is persisted at:

`~/.config/opencode/profiles-enabled.json`

For profile adoption guidance, see `docs/profiles.md`.

## What This Installs

`install.sh` creates symlinks into `~/.config/opencode/` so edits in this repo apply immediately.

If a managed target path already exists and is not a symlink, install fails by default.
Use `--conflict-policy skip` to leave conflicting paths untouched and continue linking non-conflicting paths.

`./install.sh --uninstall` removes managed symlinks and profile state.

## Try It Now

```bash
# create a session handover note in ./memory
./scripts/handover.sh

# quick repo-local quality gate detection
./scripts/ops-check.sh

# git helper
./scripts/git-porcelain.sh status

# issue -> branch -> draft PR loop (requires gh auth)
./scripts/issue-pr-loop.sh start 123 main
./scripts/issue-pr-loop.sh pr 123 main
```

If you enabled `council-lite`, you can also run:

```bash
./scripts/council-lite.sh run "Design safe billing webhooks"
./scripts/council-lite.sh list
./scripts/validate-council-lite.sh --latest
```

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
├── profiles/               # Optional profile metadata and manifests
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
- `scripts/council-lite.sh` - lightweight multi-agent session scaffold
- `scripts/validate-council-lite.sh` - council-lite artifact structure validator
- `scripts/share-templates.sh` - copy DM/Discord onboarding templates to clipboard

See `docs/workflows-playbook.md` for usage patterns.

## AI Delivery Playbook

Use `docs/gpt53-opencode-playbook.md` as the default runbook for GPT-5.3 + OpenCode execution to reduce rework.

## Open Source Readiness

- community templates in `.github/`
- `SECURITY.md` and `CODE_OF_CONDUCT.md`
- practical usage examples in `examples/`
- release checklist in `docs/release-checklist.md`
- launch checklist in `docs/open-source-launch.md`
- friend outreach message in `docs/friend-outreach-template.md`
- onboarding feedback channels in `docs/onboarding-feedback.md`

## Where To Go Next

- Profiles and installer behavior: `docs/profiles.md`
- Common scripts and usage patterns: `docs/workflows-playbook.md`
- Agent pack overview and how to invoke agents: `docs/agents-playbook.md` and `agents/README.md`
- Mapping from Claude setup patterns: `docs/what-maps-what.md` and `docs/migration-from-claude.md`

## Troubleshooting

Conflicts under `~/.config/opencode/`:
- If a managed path already exists and is not a symlink, install fails by default.
- Recommended: move/remove the conflicting path, then rerun `./install.sh`.
- If you want to proceed without replacing conflicting paths, use `./install.sh --conflict-policy skip`.

"I expected files to be copied":
- This repo is designed around symlinks. Editing files in this repo updates your OpenCode config immediately.

"python3 not found":
- Install requires `python3` for profile resolution and state management.
