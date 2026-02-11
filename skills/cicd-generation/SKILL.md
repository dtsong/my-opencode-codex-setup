---
name: cicd-generation
description: Security-first CI/CD workflow generation (GitHub Actions).
---

# CI/CD Generation

## Purpose

Generate production-ready CI/CD workflows with fail-fast checks and secure defaults.

## Inputs

- language/runtime
- package manager
- quality gate commands
- deployment target

## Process

1. Detect build, test, lint, typecheck commands.
2. Design fail-fast job order.
3. Add caching and matrix only when needed.
4. Set minimal permissions and secure auth strategy.
5. Add deployment steps with rollback awareness.

## Output Format

- analysis summary
- workflow file path
- required secrets/variables
- validation command

## Quality Checks

- [ ] Workflow uses least-privilege permissions
- [ ] Build/test gates run before deploy
- [ ] Caching and matrix choices are justified
