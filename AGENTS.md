# AGENTS

This repository is a portable OpenCode setup: it provides reusable agents, skills, commands, scripts, and workspace context.

This file is the canonical development contract for both:
- humans contributing to this repo
- AI agents operating inside this repo

## Repository Concepts

- `agents/`: agent prompt files (roles like `architect`, `skeptic`, `craftsman`)
- `skills/`: structured skill docs (repeatable workflows/templates)
- `commands/`: reusable command docs (often mapped to scripts)
- `scripts/`: executable workflow helpers
- `workspaces/`: repo-name keyed context templates that OpenCode can inject
- `profiles/`: optional capability bundles with a registry + manifests
- `docs/`: onboarding, playbooks, and reference material

The installer (`install.sh`) symlinks these directories into `~/.config/opencode/`.

## Authoring Contracts

### Skills

Each `skills/*/SKILL.md` should include:
- Purpose
- Inputs
- Process
- Output Format
- Quality Checks

Keep skills:
- practical (focused on reducing rework)
- composable (usable alongside other skills)
- stable (avoid needless churn that breaks muscle memory)

### Agents

Each `agents/*.md` should define:
- mission (what the agent is for)
- required inputs (what it needs from the user/repo)
- workflow (ordered steps)
- tool boundaries (what it must/must not do)
- output contract (how it reports results)
- anti-patterns (what to avoid)

Keep agents:
- narrow (one dominant responsibility)
- explicit about safety boundaries
- consistent across runs (avoid prompt drift)

## Local Validation Checklist

Run these before opening a PR:

```bash
# lightweight repo-wide checks
python3 -m pip install --user pre-commit
pre-commit install
pre-commit run --all-files

# shell script syntax checks
bash -n install.sh
bash -n scripts/*.sh

# stack-aware quality gate detection for this repo
./scripts/ops-check.sh
```

If you changed council-lite artifacts or workflows, also run:

```bash
./scripts/validate-council-lite.sh --latest
```

## Safety And Hygiene

- Do not commit secrets or local-only credentials.
- Prefer minimal diffs; avoid drive-by refactors.
- Do not use destructive git commands unless explicitly requested.
- Keep docs accurate: if behavior changes, update `README.md` and the relevant `docs/*.md`.

## References

- Default execution runbook: `docs/gpt53-opencode-playbook.md`
- Workflows and scripts: `docs/workflows-playbook.md`
- Agent usage patterns: `docs/agents-playbook.md`
- Profiles and installer behavior: `docs/profiles.md`
