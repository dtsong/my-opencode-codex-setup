# Council Lite Workflow

Purpose: run a lightweight multi-agent deliberation flow using the core agent pack.

Script:
- `scripts/council-lite.sh`

Usage:
```bash
./scripts/council-lite.sh status
./scripts/council-lite.sh start "Design safe billing webhooks"
```

Notes:
- `council-lite` profile must be enabled.
- Enable with `./install.sh --enable-profile council-lite`.
- Session scaffold is written to `memory/COUNCIL-LITE-<timestamp>.md`.
