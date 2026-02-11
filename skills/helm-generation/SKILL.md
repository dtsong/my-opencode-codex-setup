---
name: helm-generation
description: Generate minimal-diff Helm values with schema-aware validation.
---

# Helm Generation

## Purpose

Create Helm values files that override only what differs from chart defaults.

## Inputs

- chart reference and version
- environment-specific requirements
- cluster/platform constraints

## Process

1. Read chart defaults and README constraints.
2. Define required overrides by environment.
3. Keep values minimal and correctly typed.
4. Validate with `helm lint`, `helm template`, and dry-run install.

## Output Format

- chart and version summary
- `values.yaml` override set
- install/upgrade command
- validation command set

## Quality Checks

- [ ] Includes only non-default overrides
- [ ] Avoids CLI-only metadata in values (release name/namespace)
- [ ] Uses correct YAML types
