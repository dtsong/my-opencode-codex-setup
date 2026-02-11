# Issue to PR Loop Workflow

Purpose: move one GitHub issue through implementation branch to draft PR.

Script:
- `scripts/issue-pr-loop.sh`

Usage:
```bash
./scripts/issue-pr-loop.sh start 42 main
# implement changes, commit
./scripts/issue-pr-loop.sh pr 42 main
```

Safety rules:
- One issue per branch and PR.
- Keep PR draft until checks are complete.
- Include testing notes before requesting review.
