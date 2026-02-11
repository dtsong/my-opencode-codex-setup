# Workflow Sequence Example

## Scenario

Implement GitHub issue `#123` and open a draft PR.

## Sequence

```bash
# 1) Create branch from issue
./scripts/issue-pr-loop.sh start 123 main

# 2) Implement and commit
./scripts/git-porcelain.sh status
./scripts/ops-check.sh
./scripts/git-porcelain.sh save "feat: implement issue 123"

# 3) Create draft PR
./scripts/issue-pr-loop.sh pr 123 main
```

## Optional closeout

```bash
./scripts/handover.sh --print
```

This flow keeps one issue per branch/PR and adds quality checks before review.
