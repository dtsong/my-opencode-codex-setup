# Workspace Context Format

Workspaces provide project-specific context that can be loaded by repository name.

## Structure

```text
workspaces/
  <repo-name>/
    INFRASTRUCTURE_MAP.md
    CONVENTIONS.md
    CONTEXT.md
```

## Matching Rule

1. Detect current git remote repo name.
2. Match `workspaces/<repo-name>/`.
3. If present, inject files into prompt context.
