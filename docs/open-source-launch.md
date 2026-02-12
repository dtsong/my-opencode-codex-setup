# Open Source Launch Checklist

Use this one-time checklist when preparing the first broad public launch.

This is separate from `docs/release-checklist.md`, which is for recurring version releases.

## Repository Settings

- [x] repository description and topics are current
- [x] default branch protection is configured (required checks and no force push)
- [x] Discussions is enabled (if using community support flow)
- [x] issue labels are seeded (`bug`, `enhancement`, `docs`, `question`, `good first issue`)

## Community and Policy

- [x] `README.md` includes quick start and support expectations
- [x] `CONTRIBUTING.md` includes local validation and PR guidance
- [x] `CODE_OF_CONDUCT.md` and `SECURITY.md` are reviewed and current
- [x] issue/PR templates are reviewed for launch wording

## Technical Launch Readiness

- [x] CI passes on pull requests and main
- [x] secret scanning passes
- [x] installer/profile flow tested on a clean environment
- [x] council-lite run/list/resume/validate flow tested end-to-end

## Release and Communication

- [x] `CHANGELOG.md` has release notes for launch tag
- [x] launch tag created (for example, `v0.2.0`)
- [x] GitHub release drafted with highlights and known limitations
- [x] launch announcement copy prepared (X/LinkedIn/GitHub Discussion)
- [x] first 3-5 starter issues prepared for contributors
- [x] friend outreach template is ready (`docs/friend-outreach-template.md`)

## Post-launch Follow-up

- [ ] monitor first-week issues and triage daily
- [ ] collect onboarding friction points from early users
- [x] onboarding feedback issue template/manual form are active (`docs/onboarding-feedback.md`)
- [x] publish first-week patch release plan

## Notes

- Launch announcement drafts: `docs/launch-announcement.md`.
- First-week triage and patch procedure: `docs/first-week-patch-plan.md`.
