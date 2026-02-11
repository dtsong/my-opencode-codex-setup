---
name: language-conventions
description: Project convention references for Python, TypeScript, and Terraform.
---

# Language Conventions

## Purpose

Enforce consistent coding and tooling conventions across common language stacks.

## Inputs

- target language or stack
- existing repo conventions
- build/test tooling

## Process

1. Detect current conventions from existing files.
2. Prefer existing project standards over generic defaults.
3. Recommend minimal changes for consistency.
4. Validate with the language-specific quality gates.

## Output Format

- detected conventions
- recommendations
- commands used to verify alignment

## Quality Checks

- [ ] Recommendations align with existing repo patterns
- [ ] Tooling choices are explicit
- [ ] Verification commands are included
