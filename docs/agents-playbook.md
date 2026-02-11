# Agents Playbook

This playbook defines how to use the Phase 3 core agent pack.

## Goals

- increase consistency of outputs
- reduce role overlap and prompt drift
- improve decision traceability

## Core Pattern

Every agent prompt includes:
- mission
- required inputs
- workflow
- tool boundaries
- output contract
- explicit anti-patterns

## Recommended Invocation Pattern

1. Start with one primary agent aligned to the dominant problem.
2. Add one challenger agent for risk or implementation cross-check.
3. Merge outputs into a single actionable plan.

Common pairings:
- `architect` + `skeptic`
- `craftsman` + `operator`
- `scout` + `architect`
- `chronicler` + any agent when finalizing handoff

## Output Quality Bar

- recommendations are evidence-based
- risks include mitigation and verification
- next steps are executable in sequence
- unknowns are surfaced, not hidden

## Future Extensions (Phase 3.1+)

- add mobile and data-specialized agents
- add agent scorecard and selection automation
- add golden examples per agent role
