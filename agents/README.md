# Agents

Phase 3 core agent pack for OpenCode/Codex.

## Core Agents

- `architect`: architecture and API/system boundaries
- `skeptic`: security, reliability, and failure-mode risk review
- `craftsman`: implementation quality and verification discipline
- `operator`: CI/CD, deployment readiness, and observability
- `chronicler`: handovers, ADRs, and decision documentation
- `scout`: option research and recommendation matrix

## Design Rules

- Keep each agent narrow and composable.
- Include mission, inputs, workflow, and output contract.
- Explicitly define tool boundaries to prevent role drift.

## Selection Heuristic

- uncertain design or API shape -> `architect`
- high-risk changes or security concerns -> `skeptic`
- implementation and tests -> `craftsman`
- release and runtime behavior -> `operator`
- docs, handovers, decision records -> `chronicler`
- technology choice or strategy options -> `scout`
