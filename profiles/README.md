# Profiles

Profiles let users opt into additional capability layers without changing the core setup.

## Stability Levels

- `stable` - recommended for daily use
- `beta` - usable, but still evolving
- `experimental` - early availability and active research

## Available Profiles

- `core` (`stable`) - default profile with practical workflows
- `council-lite` (`beta`) - lightweight deliberation workflow (`commands/council-lite.md`, `scripts/council-lite.sh`)
- `council-research` (`experimental`) - research-mode profile under battle testing with tracker (`profiles/council-research/BATTLE_TESTING.md`)

## Notes

- `core` is always required.
- Profile metadata is defined in `profiles/registry.json` and `profiles/<id>/manifest.json`.
- Runtime profile state is stored in `~/.config/opencode/profiles-enabled.json`.
