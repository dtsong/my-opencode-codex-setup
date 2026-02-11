# Workflows Playbook

Phase 4 introduces executable workflow scripts that match command docs.

## Handover

Create a handover file with repository snapshot:

```bash
./scripts/handover.sh
```

Print generated handover inline:

```bash
./scripts/handover.sh --print
```

## Git Porcelain

```bash
./scripts/git-porcelain.sh status
./scripts/git-porcelain.sh save "feat: message"
./scripts/git-porcelain.sh branch feat/my-branch
./scripts/git-porcelain.sh sync main
./scripts/git-porcelain.sh pr-draft main "feat: title"
```

Notes:
- secret-like files are blocked from commit by pattern checks
- `pr-draft` requires `gh` authentication

## Ops Check

```bash
./scripts/ops-check.sh
./scripts/ops-check.sh --strict
```

Checks are auto-detected for:
- Node.js (`package.json` scripts)
- Python (`pyproject.toml` or `requirements.txt`)
- Terraform (`*.tf` in repo root)

## Issue to PR Loop

```bash
./scripts/issue-pr-loop.sh start 123 main
# implement and commit
./scripts/issue-pr-loop.sh pr 123 main
```

This creates one branch and one draft PR per issue.

## Council Lite

```bash
./scripts/council-lite.sh status
./scripts/council-lite.sh start "Design safe billing webhooks"
```

Notes:
- requires `council-lite` profile enabled
- creates `memory/COUNCIL-LITE-<timestamp>.md` scaffold
