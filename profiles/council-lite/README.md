# Council Lite Profile

Stability: `beta`

Council Lite provides a lightweight deliberation workflow on top of the core profile.

Promotion criteria from `beta` to `stable` are defined in `profiles/council-lite/QUALITY_GATES.md`.

## What It Adds

- `commands/council-lite.md`
- `scripts/council-lite.sh`

## Enable

```bash
./install.sh --enable-profile council-lite
```

## Quick Start

```bash
./scripts/council-lite.sh run "Design safe billing webhooks"
./scripts/council-lite.sh list
./scripts/council-lite.sh resume <session-id>
./scripts/validate-council-lite.sh --latest
```

This initializes a structured session under `memory/council-lite/<session-id>/` with:

- intake
- assembly
- deliberation rounds (position/challenge/converge)
- execution plan
