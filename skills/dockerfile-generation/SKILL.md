---
name: dockerfile-generation
description: "Generate minimal, secure, multi-stage Dockerfiles with layer optimization and non-root execution. Use when the user asks to create a Dockerfile, containerize an application, optimize Docker image size, fix Docker build issues, or harden a container image."
---

# Dockerfile Generation

## Purpose

Create or improve Dockerfiles using secure, efficient containerization practices including multi-stage builds, minimal base images, and non-root execution.

## Inputs

- App runtime and entrypoint (e.g., `node server.js`, `python -m app`)
- Build tooling and artifacts (e.g., `npm run build` producing `dist/`)
- Runtime environment constraints (ports, volumes, env vars)

## Process

1. **Identify build-time vs runtime dependencies** and select appropriate base images:
   ```dockerfile
   # Build stage - includes dev tools
   FROM node:20-alpine AS builder
   WORKDIR /app
   COPY package*.json ./
   RUN npm ci --ignore-scripts
   COPY . .
   RUN npm run build

   # Runtime stage - minimal image
   FROM node:20-alpine AS runtime
   RUN addgroup -S app && adduser -S app -G app
   WORKDIR /app
   COPY --from=builder /app/dist ./dist
   COPY --from=builder /app/node_modules ./node_modules
   USER app
   EXPOSE 3000
   HEALTHCHECK CMD wget -qO- http://localhost:3000/health || exit 1
   CMD ["node", "dist/server.js"]
   ```
2. **Apply security defaults**: pin base image tags, run as non-root, avoid `COPY . .` in the runtime stage to exclude source and secrets.
3. **Optimize layers**: order instructions from least to most frequently changing (OS deps > app deps > source code) for better cache hits.
4. **Add healthcheck** and sensible default `CMD`.
5. **Verify build and run locally**:
   ```bash
   docker build -t app:test .
   docker run --rm app:test
   # Verify non-root execution
   docker run --rm app:test whoami  # should print "app", not "root"
   # Check image size
   docker images app:test --format '{{.Size}}'
   ```

## Output Format

- Dockerfile with inline comments explaining key decisions
- Build and run verification commands
- Image size comparison if replacing an existing Dockerfile

## Quality Checks

- [ ] Uses multi-stage build with minimal runtime image
- [ ] Runs as non-root user
- [ ] No secrets or source code leaked into runtime image layers
- [ ] Base image tags are pinned (e.g., `node:20.11-alpine`, not `node:latest`)
- [ ] `HEALTHCHECK` instruction is present
