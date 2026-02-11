# Profiles

Profiles let you choose how much capability to install.

## Available Profiles

- `core` (`stable`) - default practical setup
- `council-lite` (`beta`) - lightweight advanced orchestration layer with `commands/council-lite.md`
- `council-research` (`experimental`) - early availability research mode under active battle testing

## Quick Commands

```bash
# show all profiles
./install.sh --list-profiles

# show enabled profiles and state file location
./install.sh --status

# set exact profile set (dependencies auto-added)
./install.sh --profiles core,council-lite

# enable/disable one profile
./install.sh --enable-profile council-lite
./install.sh --disable-profile council-lite
```

## State Location

Profile state is stored at:

`~/.config/opencode/profiles-enabled.json`

This file is created or updated during install/profile changes.

## Adoption Path

1. Start with `core`.
2. Enable `council-lite` when you want more orchestration.
3. Try `council-research` only when you are comfortable with fast iteration and changing behavior.

After enabling `council-lite`, run:

```bash
./scripts/council-lite.sh run "Design safe billing webhooks"
./scripts/council-lite.sh list
./scripts/council-lite.sh resume <session-id>
```

## Experimental Warning: council-research

`council-research` is intentionally marked as experimental/early availability:

- behavior and interfaces may change without notice
- battle testing is in progress
- not recommended as your only daily-driver profile

Track runs and readiness in `profiles/council-research/BATTLE_TESTING.md`.

## Uninstall Behavior

`./install.sh --uninstall` removes:

- managed symlinks in `~/.config/opencode/`
- profile state file `~/.config/opencode/profiles-enabled.json`

If `~/.config/opencode/` becomes empty, the directory is removed.
