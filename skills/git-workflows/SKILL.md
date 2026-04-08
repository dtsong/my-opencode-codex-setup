---
name: git-workflows
description: "Safe day-to-day git workflows for branching, syncing, rebasing, and cleanup. Creates feature branches, syncs with remote via pull/rebase, and deletes merged branches. Use when the user asks to create a branch, sync with main, rebase, push changes, clean up stale branches, or manage upstream tracking."
---

# Git Workflows

## Purpose

Standardize safe local git workflows for branch creation, synchronization, and cleanup with explicit commands at every step.

## Inputs

- Branch intent (feature, fix, chore)
- Base branch (usually `main`)

## Process

1. **Snapshot current state** before any operation:
   ```bash
   git status --short --branch
   git stash list
   ```
2. **Create or switch branch** with conventional naming:
   ```bash
   # Feature branch
   git checkout -b feature/add-auth main
   # Fix branch
   git checkout -b fix/login-crash main
   # Chore branch
   git checkout -b chore/update-deps main
   ```
3. **Sync with base branch** using rebase for clean history:
   ```bash
   git fetch origin
   git rebase origin/main
   # If conflicts arise, resolve then:
   git rebase --continue
   ```
4. **Commit in small units** with meaningful messages:
   ```bash
   git add <specific-files>
   git commit -m "feat: add JWT validation middleware"
   ```
5. **Push with upstream tracking**:
   ```bash
   git push -u origin feature/add-auth
   ```
6. **Cleanup after merge**:
   ```bash
   git checkout main && git pull
   git branch -d feature/add-auth
   # Remove remote tracking for deleted branches
   git fetch --prune
   ```

## Output Format

- Actions taken (exact commands run)
- Resulting branch state (`git log --oneline -5`)
- Next safe git step recommendation

## Quality Checks

- [ ] No destructive commands (`reset --hard`, `push --force`) unless explicitly requested
- [ ] No force push to protected branches
- [ ] Working tree state verified with `git status` after each workflow step
- [ ] Stash checked before branch switches to avoid losing work
