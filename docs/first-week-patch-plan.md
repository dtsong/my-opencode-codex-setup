# First-Week Patch Plan

This plan defines how we handle the first week after open-source launch.

## Daily Cadence (Days 1-7)

1. Check new GitHub issues twice daily (morning/evening local time).
2. Triage each issue into one of: `bug`, `docs`, `enhancement`, `question`.
3. Add priority tags manually in issue body if needed: P0/P1/P2.
4. Respond to onboarding feedback within 24 hours.
5. Log recurring friction points in issue #6.

## Patch Criteria

Cut a first-week patch release when any of the following happen:
- one confirmed onboarding blocker (`fail` outcome)
- two or more users report the same setup/documentation confusion
- any security-sensitive report needing remediation

## Candidate Scope for First Patch

- installer conflict messaging clarity
- README quick-start and troubleshooting improvements
- council-lite docs clarity and validation examples
- minor script robustness fixes without breaking interfaces

## Target Timeline

- Day 1-2: collect issues and cluster by theme
- Day 3-4: implement highest-impact fixes
- Day 5: run full release checklist and smoke tests
- Day 6-7: publish patch tag/release notes and close loop with reporters

## Owner Checklist

- keep `docs/release-checklist.md` green before tagging
- include migration/behavior notes in release body
- link fixes back to original issue IDs
