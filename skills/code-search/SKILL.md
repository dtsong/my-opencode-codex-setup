---
name: code-search
description: Fast repo navigation using glob + grep patterns.
---

# Code Search

## Purpose

Find files and implementations quickly with predictable search patterns.

## Inputs

- thing to locate (function, class, config, command)
- optional path scope

## Process

1. Use file pattern search for likely locations.
2. Use content search for exact symbols and related terms.
3. Read smallest relevant files first.
4. Return precise file references.

## Output Format

- likely file paths
- exact symbol locations
- short explanation of where logic lives

## Quality Checks

- [ ] Search was scoped before broadening
- [ ] Results include clickable paths
- [ ] False positives filtered
