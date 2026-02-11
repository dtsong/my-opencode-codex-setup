# Contributing

Thanks for contributing.

## Principles

- Keep changes practical and composable.
- Prefer small, reviewable pull requests.
- Preserve compatibility with OpenCode/Codex workflows.

## Skill Format

Each `SKILL.md` should include:
- Purpose
- Inputs
- Process
- Output Format
- Quality Checks

## Agent Format

Each agent markdown should define:
- Role and scope
- Decision heuristics
- Tool usage boundaries

## Pull Requests

- Explain why the change exists.
- Include before/after behavior when relevant.
- Link issues when possible.

## Local Validation

This repo uses `pre-commit` for lightweight quality checks across shell, JSON/YAML, and markdown.

```bash
python3 -m pip install --user pre-commit
pre-commit install
pre-commit run --all-files
```
