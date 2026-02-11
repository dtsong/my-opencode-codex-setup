---
name: web-security-hardening
description: Security review checklist for web applications and APIs.
---

# Web Security Hardening

## Purpose

Audit and harden web applications with a concise, repeatable checklist.

## Inputs

- framework/runtime
- API endpoints and auth model
- deployment environment

## Process

1. Validate auth and authorization boundaries.
2. Review CORS, headers, and transport security.
3. Verify rate limits and abuse controls.
4. Check input validation and output encoding.
5. Verify file upload, secret handling, and password hashing.
6. Capture risks with severity and fixes.

## Output Format

- findings by severity
- impacted files/endpoints
- mitigation steps
- verification plan

## Quality Checks

- [ ] Uses explicit PASS/FAIL/PARTIAL findings
- [ ] Includes at least one verification step per fix
- [ ] Avoids vague recommendations
