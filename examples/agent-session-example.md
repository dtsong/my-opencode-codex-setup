# Agent Session Example

## Scenario

Goal: add a new API endpoint safely and quickly.

## Recommended sequence

1. `architect`
   - define endpoint contract, request/response shape, and migration notes
2. `skeptic`
   - review auth, input validation, and abuse/rate-limit concerns
3. `craftsman`
   - implement endpoint and tests with minimal change surface
4. `operator`
   - validate CI gates and deployment readiness
5. `chronicler`
   - update handover and docs with decisions

## Expected outputs

- architecture decision and trade-offs
- risk findings with mitigations and checks
- code/test changes with verification
- release and rollback guidance
- concise handover notes
