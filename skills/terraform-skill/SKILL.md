---
name: terraform-skill
description: Terraform/OpenTofu authoring, testing, and security workflow.
---

# Terraform Skill

## Purpose

Guide safe infrastructure-as-code changes using Terraform/OpenTofu best practices.

## Inputs

- IaC module or environment target
- provider and backend configuration
- policy/security constraints

## Process

1. Read current module patterns and state implications.
2. Implement minimal, reviewable IaC changes.
3. Run `fmt`, `validate`, and plan checks.
4. Add or update tests (native tests or Terratest when needed).
5. Report security and drift considerations.

## Output Format

- changed modules/resources
- validation and plan summary
- risk notes and rollout guidance

## Quality Checks

- [ ] `fmt` and `validate` performed
- [ ] Plan output reviewed for unintended changes
- [ ] Sensitive values are not exposed in code or logs
