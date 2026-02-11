---
name: dockerfile-generation
description: Build minimal, secure Dockerfiles with verification-first workflow.
---

# Dockerfile Generation

## Purpose

Create or improve Dockerfiles with secure and efficient containerization practices.

## Inputs

- app runtime and entrypoint
- build tooling and artifacts
- runtime environment constraints

## Process

1. Identify build-time vs runtime dependencies.
2. Prefer multi-stage builds for smaller images.
3. Use pinned base image tags and non-root user.
4. Add healthcheck and sensible default command.
5. Verify build and run behavior locally.

## Output Format

- Dockerfile path
- key design decisions
- build/run verification commands

## Quality Checks

- [ ] Uses minimal runtime image where practical
- [ ] Runs as non-root user
- [ ] No secrets baked into image layers
