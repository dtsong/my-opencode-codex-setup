# Git Porcelain Workflow

Purpose: fast, safe git operations.

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
