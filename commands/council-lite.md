# Council Lite Workflow

Purpose: run a lightweight multi-agent deliberation flow using the core agent pack.

Script:
- `scripts/council-lite.sh`

Usage:
```bash
./scripts/council-lite.sh status
./scripts/council-lite.sh list
./scripts/council-lite.sh run "Design safe billing webhooks"
./scripts/council-lite.sh resume <session-id>
./scripts/validate-council-lite.sh --latest
```

Notes:
- `council-lite` profile must be enabled.
- Enable with `./install.sh --enable-profile council-lite`.
- Sessions are written to `memory/council-lite/<session-id>/`.
- Artifacts include intake, assembly, deliberation rounds, and execution plan.
- Validate generated artifacts with `scripts/validate-council-lite.sh`.
