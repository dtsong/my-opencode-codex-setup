# GPT-5.3 + OpenCode Delivery Playbook

Use this one-page runbook to reduce rework when building with GPT-5.3 and OpenCode.

## Principles

- plan before code, verify before PR
- follow existing repo patterns before introducing new ones
- make decisions explicit when they affect prompts, model behavior, or workflow
- leave a clean handoff artifact at session end

## Default Flow

1. Frame scope and definition of done.
2. Inspect existing patterns and constraints.
3. Implement in small, testable slices.
4. Verify with stack-specific checks.
5. Prepare PR with full context from branch divergence.
6. Capture session handoff for continuity.

## Trigger -> Skill -> Expected Output

| Trigger | Skill(s) | Expected Output |
|---|---|---|
| new task request with ambiguity | `Prompt Wizard`, `workflow` | clear task statement with in-scope/out-of-scope and verification checklist |
| editing unfamiliar code | `code-search`, `Pattern Analysis` | file map, current conventions, and safe insertion points |
| implementing code changes | `language-conventions`, `workflow` | minimal-diff changes aligned to existing standards |
| adding or changing tests | `Testing Strategy` | test pyramid plan and targeted coverage additions |
| prompt/model behavior design | `Prompt Engineering` | versioned prompt contract (role, constraints, schema, examples) |
| preventing AI regressions | `AI Evaluation` | golden dataset, scoring rubric, and regression thresholds |
| architecture-impacting choice | `ADR Template` | ADR with options, rationale, consequences, and review triggers |
| git state unclear | `git-status`, `git-workflows` | staged/unstaged snapshot, branch state, and next safe git step |
| ready to publish work | `github-workflow` | PR with why, testing notes, blockers, and CI status summary |
| session ending or context switch | `handover` | concise continuity note with decisions, risks, and ordered next steps |

## GPT-5.3 Guardrails

- require structured outputs for machine-consumed steps (JSON schema or strict markdown template)
- keep prompt versions in repo and tie changes to eval results
- treat prompt updates like code changes: diff, review, validate, and document
- fail builds when core eval thresholds regress

## PR Ready Checklist

- [ ] scope is explicit (in/out) and unchanged during implementation
- [ ] change matches local conventions and avoids unrelated refactors
- [ ] required checks/tests executed (or risks documented if blocked)
- [ ] PR explains why, not only what
- [ ] handoff note exists when work is incomplete or multi-session
