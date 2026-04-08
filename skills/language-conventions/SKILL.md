---
name: language-conventions
description: "Detect and enforce coding conventions for Python, TypeScript, and Terraform projects. Identifies linters, formatters, and style rules from existing config files and recommends minimal alignment changes. Use when the user asks about coding standards, project conventions, style guides, naming conventions, linting setup, or best practices for Python, TypeScript, or Terraform."
---

# Language Conventions

## Purpose

Detect existing coding conventions from project configuration and enforce consistent style, tooling, and naming across Python, TypeScript, and Terraform stacks.

## Inputs

- Target language or stack
- Existing repo conventions (config files, linter settings)
- Build/test tooling in use

## Process

1. **Detect existing conventions** by scanning for config files:
   ```bash
   # Python
   ls pyproject.toml setup.cfg .flake8 .ruff.toml tox.ini 2>/dev/null
   # TypeScript
   ls tsconfig.json .eslintrc* .prettierrc* biome.json 2>/dev/null
   # Terraform
   ls .terraform-version .tflint.hcl .editorconfig 2>/dev/null
   ```
2. **Prefer existing project standards** over generic defaults. If `pyproject.toml` has `[tool.ruff]`, use those rules. If `.eslintrc` exists, prefer ESLint over Biome.
3. **Recommend minimal changes** for consistency. Example recommendations:
   - Python: add `ruff check .` to CI if ruff config exists but no CI step runs it
   - TypeScript: enable `strict: true` in tsconfig if most files already pass
   - Terraform: run `terraform fmt -check -recursive` in CI
4. **Validate alignment** with language-specific quality gates:
   ```bash
   # Python
   ruff check . && ruff format --check .
   # TypeScript
   npx tsc --noEmit && npx eslint .
   # Terraform
   terraform fmt -check -recursive && terraform validate
   ```

## Output Format

- Detected conventions (config files found, active rules)
- Recommendations (specific changes with rationale)
- Verification commands to confirm alignment

## Quality Checks

- [ ] Recommendations align with existing repo patterns, not generic defaults
- [ ] Tooling choices match what the project already uses
- [ ] Verification commands are runnable and included in output
