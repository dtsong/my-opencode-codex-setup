# Council Lite Profile

Stability: `beta`

Council Lite provides a lightweight deliberation workflow on top of the core profile.

## What It Adds

- `commands/council-lite.md`
- `scripts/council-lite.sh`

## Enable

```bash
./install.sh --enable-profile council-lite
```

## Quick Start

```bash
./scripts/council-lite.sh start "Design safe billing webhooks"
```

This generates a session scaffold in `memory/` with recommended agents and execution flow.
