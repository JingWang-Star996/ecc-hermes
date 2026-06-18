---
name: api-connector-builder
description: "Build a new API connector or provider by matching the target repo's existing integration pattern exactly."
version: 1.0.0
author: "ECC (adapted for Hermes)"
---

# API Connector Builder

Use this when the job is to add a repo-native integration surface, not just a generic HTTP client.

## When to Use

- "Build a Jira connector for this project"
- "Add a Slack provider following the existing pattern"
- "Create a new integration for this API"

## Guardrails

- do not invent a new integration architecture when the repo already has one
- do not start from vendor docs alone; start from existing in-repo connectors first
- do not stop at transport code if the repo expects registry wiring, tests, and docs
- do not cargo-cult old connectors if the repo has a newer current pattern

## Workflow

### 1. Learn the house style
Inspect at least 2 existing connectors/providers and map: file layout, abstraction boundaries, config model, retry/pagination conventions, registry hooks, test fixtures.

### 2. Narrow the target integration
Define only the surface the repo actually needs: auth flow, key entities, core operations, pagination and rate limits, webhook or polling model.

### 3. Build in repo-native layers
Typical slices: config/schema, client/transport, mapping layer, connector entrypoint, registration, tests.

### 4. Validate against the source pattern
The new connector should look obvious in the codebase, not imported from a different ecosystem.

## Quality Checklist

- [ ] matches an existing in-repo integration pattern
- [ ] config validation exists
- [ ] auth and error handling are explicit
- [ ] pagination/retry behavior follows repo norms
- [ ] registry/discovery wiring is complete
- [ ] tests mirror the host repo's style
