# Migration From my-claude-setup

## Directly Reusable

- skill structure and writing style
- workspace context format
- handover conventions
- install via symlink strategy

## Needs Adaptation

- Claude-specific hooks and command frontmatter
- slash command internals
- model/tool naming differences

## Migration Strategy

1. Port practical skills first.
2. Build a smaller core agent set.
3. Add command workflows with script fallbacks.
4. Expand to richer orchestration later.
