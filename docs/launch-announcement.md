# Launch Announcement Copy

Use these drafts for launch day. Edit version/tag and call-to-action links before posting.

## GitHub Discussion / Long Form

`my-opencode-codex-setup` is now open source.

This repo is a practical OpenCode + Codex starter inspired by `my-claude-setup`, focused on reusable agents, structured skills, and executable workflow scripts.

Highlights in `v0.2.0`:
- profile-aware installer (`core`, `council-lite`, `council-research`)
- council-lite session lifecycle (`run`, `list`, `resume`)
- council-lite artifact validation and CI smoke coverage
- launch-ready docs, templates, and policy files

If you want to try it, start here:

```bash
git clone https://github.com/dtsong/my-opencode-codex-setup.git
cd my-opencode-codex-setup
./install.sh --profiles core,council-lite
./scripts/council-lite.sh run "First run"
./scripts/validate-council-lite.sh --latest
```

Contributions are welcome. Good starter issues:
- #7
- #8
- #9
- #10

If onboarding feels rough anywhere, please open an issue using the onboarding feedback template.

## X / Short Form

I just open sourced `my-opencode-codex-setup`.

Portable OpenCode + Codex starter with:
- reusable agents + practical skills
- profile-aware installer
- council-lite `run/list/resume` flow
- launch-ready OSS docs/templates

Repo: https://github.com/dtsong/my-opencode-codex-setup
Start: `./install.sh --profiles core,council-lite`
Feedback: onboarding issue template in repo

## LinkedIn / Medium Form

I am open sourcing `my-opencode-codex-setup`, a portable OpenCode + Codex setup inspired by `my-claude-setup`.

The goal is practical reuse: agents, skills, workflows, and profiles you can adopt quickly without rebuilding everything from scratch.

What is included:
- profile-aware installer and clean uninstall path
- `council-lite` session scaffolding with artifact validation
- CI smoke checks across Linux/macOS and secret scanning
- contributor docs, templates, and launch readiness checklists

Try it: https://github.com/dtsong/my-opencode-codex-setup

If you test onboarding, I would especially value friction-point feedback via the repo onboarding template.
