---
name: git-workflows
description: Safe day-to-day git workflows for branching, sync, and cleanup.
---

# Git Workflows

## Purpose

Standardize safe local git workflows for branch creation, synchronization, and cleanup.

## Inputs

- branch intent (feature/fix/chore)
- base branch (usually `main`)

## Process

1. Snapshot state with `git-status` skill.
2. Create or switch branch with clear naming.
3. Rebase or merge from base branch intentionally.
4. Commit in small units with meaningful messages.
5. Push with upstream tracking.

## Output Format

- actions taken
- resulting branch state
- next safe git step

## Quality Checks

- [ ] No destructive commands unless explicitly requested
- [ ] No force push to protected branches
- [ ] Working tree state verified after each workflow step
