# Friend Outreach Template

Use this message when inviting friends to help validate onboarding.

Quick copy helpers are available:

```bash
./scripts/share-templates.sh --dm
./scripts/share-templates.sh --discord
```

Or source functions into your shell:

```bash
source scripts/share-templates.sh
copy_dm
copy_discord_pin
```

## Copy/Paste Message

Hey! I am testing onboarding for my OpenCode/Codex setup and would love your help.

Goal: verify whether a new user can get from clone to a successful council-lite run quickly and clearly.

If you are up for it, please run these steps:

```bash
git clone https://github.com/dtsong/my-opencode-codex-setup.git
cd my-opencode-codex-setup
./install.sh --conflict-policy skip --profiles core,council-lite
./scripts/council-lite.sh run "Onboarding validation run"
./scripts/council-lite.sh list
./scripts/validate-council-lite.sh --latest
./install.sh --uninstall
```

Then share feedback in one of two ways:

1. Open a GitHub issue using the "Onboarding feedback" template
2. Send me the manual feedback form in `docs/onboarding-feedback.md`

What I need from you:
- OS + shell
- whether it succeeded (`success` | `partial` | `fail`)
- time-to-first-success (minutes)
- any confusion points or rough edges
- what would make this easier for new users

Thank you - this feedback directly decides when council-lite can move from beta to stable.
