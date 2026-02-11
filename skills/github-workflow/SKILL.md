---
name: github-workflow
description: Practical GitHub issue and pull request workflows using gh CLI.
---

# GitHub Workflow

## Purpose

Run consistent GitHub workflows for issues, PR creation, and review follow-through.

## Inputs

- repository context
- issue or PR number (optional)
- desired operation (create/update/status/merge)

## Process

1. Confirm authentication with `gh auth status`.
2. Inspect current branch and divergence from base.
3. Build PR summary from all commits included.
4. Create or update PR with clear intent and testing notes.
5. Track review comments and CI state until merge-ready.

## Output Format

- operation performed
- key metadata (issue/PR number, URL)
- blockers and next actions

## Quality Checks

- [ ] PR body explains why and testing performed
- [ ] CI/check status included when relevant
- [ ] Merge strategy matches repo conventions
