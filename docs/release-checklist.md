# Release Checklist

Use this checklist before tagging a release.

## Pre-release

- [ ] `README.md` reflects current scripts, skills, and agent docs
- [ ] `docs/roadmap.md` reflects current phase status
- [ ] examples still run as documented
- [ ] no local-only assumptions or paths leaked into docs

## Validation

- [ ] `bash -n scripts/*.sh` passes
- [ ] `bash -n install.sh` passes
- [ ] `./scripts/ops-check.sh` passes in this repo
- [ ] install and uninstall path tested:
  - [ ] `./install.sh`
  - [ ] `./install.sh --list-profiles`
  - [ ] `./install.sh --status`
  - [ ] `./install.sh --conflict-policy fail --profiles core,council-lite`
  - [ ] `./install.sh --conflict-policy skip --profiles core,council-lite`
  - [ ] `./install.sh --profiles core,council-lite`
  - [ ] `./install.sh --enable-profile council-research`
  - [ ] `./install.sh --disable-profile council-research`
  - [ ] `./scripts/council-lite.sh run "Smoke test"`
  - [ ] `./scripts/council-lite.sh list`
  - [ ] `./scripts/validate-council-lite.sh --latest`
  - [ ] `./install.sh --uninstall`
- [ ] experimental warning shown when `council-research` is enabled
- [ ] profile state removed on uninstall (`~/.config/opencode/profiles-enabled.json`)

## Community health

- [ ] issue templates are present and current
- [ ] PR template is present and current
- [ ] `SECURITY.md` and `CODE_OF_CONDUCT.md` are up to date

## Publish

- [ ] changelog notes prepared
- [ ] version tag created
- [ ] GitHub release drafted with highlights and migration notes
