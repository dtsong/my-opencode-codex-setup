---
name: workflow
description: "Structured development workflow from planning through implementation and verification. Runs repo-specific quality gates, commits in small testable steps, and documents decisions. Use when the user asks to implement a feature end-to-end, follow a development process, run quality checks, or deliver a task with verification."
---

# Workflow

## Purpose

Provide a consistent delivery flow from planning through implementation and verification, with concrete quality gates at each stage.

## Inputs

- Task goal and acceptance criteria
- Repository context (language, framework, existing CI)
- Available quality gates (linters, tests, type checks)

## Process

1. **Clarify outcome and constraints** before writing code:
   - Restate the goal in one sentence
   - List files likely to change
   - Identify which quality gates apply (detect from repo):
     ```bash
     # Detect available quality gates
     [ -f package.json ] && echo "node: $(jq -r '.scripts.test // empty' package.json)"
     [ -f Makefile ] && grep -E '^(test|lint|check):' Makefile
     [ -f pyproject.toml ] && grep -A2 '\[tool.pytest' pyproject.toml
     ```
2. **Implement in small, testable steps** — one logical change per commit. Run tests after each change:
   ```bash
   # Example: after each change
   npm test        # or pytest, go test, cargo test, etc.
   git add <files>
   git commit -m "feat: add input validation for email field"
   ```
3. **Run all quality gates** relevant to the repo before finalizing:
   ```bash
   # Common patterns
   npm run lint && npm test           # Node.js
   ruff check . && pytest             # Python
   cargo clippy && cargo test         # Rust
   go vet ./... && go test ./...      # Go
   ```
4. **Summarize decisions and remaining risks** in the output.

## Output Format

- Goal (one sentence)
- Changes made (files modified, rationale)
- Verification performed (commands run, pass/fail)
- Remaining risks (what could not be verified and why)

## Quality Checks

- [ ] No unrelated refactors included in changes
- [ ] All available verification commands executed and passing
- [ ] Risks documented when checks cannot run (e.g., missing test environment)
