# Changelog

All notable changes to this project are documented in this file.

## [0.2.0] - 2026-02-11

Profile platform and council-lite maturation release focused on OSS hardening.

### Added

- Profile management layer with registry/manifests and installer profile commands.
- `council-lite` profile and session lifecycle workflow (`run`, `list`, `resume`).
- Structured council-lite artifact generation under `memory/council-lite/<session-id>/`.
- Council-lite artifact validator: `scripts/validate-council-lite.sh`.
- CI matrix coverage on Linux and macOS.
- Secret scanning in CI with gitleaks.
- One-time launch checklist: `docs/open-source-launch.md`.
- Council-lite promotion gates: `profiles/council-lite/QUALITY_GATES.md`.

### Changed

- Installer now supports explicit conflict handling policy (`--conflict-policy fail|skip`), with `fail` as default.
- Profile and workflow docs updated for council-lite lifecycle and validation commands.
- Release checklist expanded with conflict-policy and council-lite validation checks.

### Notes

- `council-lite` remains `beta` pending quality-gate completion.
- `council-research` remains `experimental` and battle-testing-driven.

## [0.1.0] - 2026-02-11

Initial public baseline release for `my-opencode-codex-setup`.

### Added

- Phase 1 bootstrap repository structure with installer and core docs.
- Phase 2 practical skill pack for git/github, security, CI/CD, Docker, Helm, language conventions, and Terraform.
- Phase 3 hardened core agent pack (`architect`, `skeptic`, `craftsman`, `operator`, `chronicler`, `scout`) with role boundaries and playbook.
- Phase 4 executable workflow scripts:
  - `scripts/handover.sh`
  - `scripts/git-porcelain.sh`
  - `scripts/ops-check.sh`
  - `scripts/issue-pr-loop.sh`
- Phase 5 open-source readiness kit:
  - GitHub issue and PR templates
  - `CODE_OF_CONDUCT.md`
  - `SECURITY.md`
  - examples and release checklist docs

### Notes

- This release establishes the baseline for future semantic versioning.
- OpenCode/Codex command and agent mappings will continue to evolve in subsequent minor releases.
