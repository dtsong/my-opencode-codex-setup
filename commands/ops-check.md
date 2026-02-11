# Ops Check Workflow

Purpose: run stack-aware health checks.

Checks by stack:
- Node.js: build, typecheck, lint, test
- Python: lint, format-check, test, optional typing
- Terraform: fmt-check, validate

Output:
- pass/fail per gate
- first failure reason
- suggested next fix step
