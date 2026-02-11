# Open Source Launch Checklist

Use this one-time checklist when preparing the first broad public launch.

This is separate from `docs/release-checklist.md`, which is for recurring version releases.

## Repository Settings

- [ ] repository description and topics are current
- [ ] default branch protection is configured (required checks and no force push)
- [ ] Discussions is enabled (if using community support flow)
- [ ] issue labels are seeded (`bug`, `enhancement`, `docs`, `question`, `good first issue`)

## Community and Policy

- [ ] `README.md` includes quick start and support expectations
- [ ] `CONTRIBUTING.md` includes local validation and PR guidance
- [ ] `CODE_OF_CONDUCT.md` and `SECURITY.md` are reviewed and current
- [ ] issue/PR templates are reviewed for launch wording

## Technical Launch Readiness

- [ ] CI passes on pull requests and main
- [ ] secret scanning passes
- [ ] installer/profile flow tested on a clean environment
- [ ] council-lite run/list/resume/validate flow tested end-to-end

## Release and Communication

- [ ] `CHANGELOG.md` has release notes for launch tag
- [ ] launch tag created (for example, `v0.2.0`)
- [ ] GitHub release drafted with highlights and known limitations
- [ ] launch announcement copy prepared (X/LinkedIn/GitHub Discussion)
- [ ] first 3-5 starter issues prepared for contributors

## Post-launch Follow-up

- [ ] monitor first-week issues and triage daily
- [ ] collect onboarding friction points from early users
- [ ] publish first-week patch release plan
