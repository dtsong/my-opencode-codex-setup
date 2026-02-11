---
name: git-status
description: Fast git snapshot for status, diff, and recent history.
---

# Git Status

## Purpose

Provide a fast and safe snapshot of repository state before any git operation.

## Inputs

- optional path scope
- optional commit count for log

## Process

1. Run `git status --short --branch`.
2. Run `git diff --staged` and `git diff`.
3. Run `git log --oneline -n <N>`.
4. Highlight untracked files and high-risk changes.

## Output Format

- branch and tracking state
- staged vs unstaged summary
- untracked files
- last commits

## Quality Checks

- [ ] Includes both staged and unstaged diffs
- [ ] Mentions ahead/behind state
- [ ] Notes merge/rebase conflicts if present
