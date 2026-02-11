# Git Porcelain Workflow

Purpose: fast, safe git operations.

Script:
- `scripts/git-porcelain.sh`

Usage:
```bash
./scripts/git-porcelain.sh status
./scripts/git-porcelain.sh save "feat: message"
./scripts/git-porcelain.sh branch feat/something
./scripts/git-porcelain.sh sync main
./scripts/git-porcelain.sh pr-draft main "feat: title"
```

Supported actions:
- status snapshot
- save (stage + commit)
- sync with default branch
- create feature branch
- create PR draft

Safety rules:
- Never commit secrets.
- Never use destructive reset without explicit request.
- Prefer small conventional commits.
