# Council Lite Quality Gates

Use these gates to decide when `council-lite` can move from `beta` to `stable`.

## Scope

Applies to:

- `scripts/council-lite.sh`
- `scripts/validate-council-lite.sh`
- related profile/install and docs behavior

## Promotion Gates (Beta -> Stable)

- [ ] at least 20 documented real-world council-lite runs
- [ ] at least 95% artifact validation pass rate over the last 20 runs
- [ ] no critical data-loss or session-index corruption issues in the last 10 runs
- [ ] no P1/P2 installer-profile regressions in the last 2 releases
- [ ] onboarding validated by at least 3 users from clean setup to first successful run

## Operational Gates

- [ ] `run`, `list`, `resume`, and validator commands pass in CI
- [ ] installer conflict-policy behavior (`fail` and `skip`) is tested and documented
- [ ] uninstall leaves no managed profile state behind
- [ ] docs are synchronized (`README`, `docs/profiles.md`, workflow docs, changelog)

## Evidence Requirements

- [ ] run log entries with date, scenario, and outcome
- [ ] known limitations list reviewed before each release
- [ ] change impact noted in release notes for any behavior changes

## Exit Decision

Promotion requires maintainers to confirm:

- [ ] all gates above met
- [ ] no unresolved high-severity council-lite issues
- [ ] next release notes mark `council-lite` as `stable`
