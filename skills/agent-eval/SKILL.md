---
name: agent-eval
description: "Head-to-head comparison of coding agents on custom tasks with pass rate, cost, time, and consistency metrics."
version: 1.0.0
author: "ECC (adapted for Hermes)"
---

# Agent Eval Skill

A lightweight methodology for comparing coding agents head-to-head on reproducible tasks.

## When to Activate

- Comparing coding agents on your own codebase
- Measuring agent performance before adopting a new tool or model
- Running regression checks when an agent updates its model or tooling
- Producing data-backed agent selection decisions for a team

## Core Concepts

### YAML Task Definitions

Define tasks declaratively. Each task specifies what to do, which files to touch, and how to judge success:

```yaml
name: add-retry-logic
description: Add exponential backoff retry to the HTTP client
repo: ./my-project
files:
  - src/http_client.py
prompt: |
  Add retry logic with exponential backoff to all HTTP requests.
  Max 3 retries. Initial delay 1s, max delay 30s.
judge:
  - type: pytest
    command: pytest tests/test_http_client.py -v
  - type: grep
    pattern: "exponential_backoff|retry"
    files: src/http_client.py
```

### Isolation

Each agent run gets its own isolated environment (git worktree, temp directory, or container) for reproducibility.

### Metrics Collected

| Metric | What It Measures |
|--------|-----------------|
| Pass rate | Did the agent produce code that passes the judge? |
| Cost | API spend per task (when available) |
| Time | Wall-clock seconds to completion |
| Consistency | Pass rate across repeated runs |

## Workflow

### 1. Define Tasks
Create task definitions with YAML files.

### 2. Run Agents
Execute agents against your tasks using Hermes delegate_task or shell scripts.

### 3. Compare Results
Generate a comparison report with pass rate, cost, time, and consistency.

## Judge Types

### Code-Based (deterministic)
```yaml
judge:
  - type: pytest
    command: pytest tests/ -v
  - type: command
    command: npm run build
```

### Pattern-Based
```yaml
judge:
  - type: grep
    pattern: "class.*Retry"
    files: src/**/*.py
```

### Model-Based (LLM-as-judge)
```yaml
judge:
  - type: llm
    prompt: |
      Does this implementation correctly handle exponential backoff?
```

## Best Practices

- Start with 3-5 tasks that represent your real workload
- Run at least 3 trials per agent to capture variance
- Pin the commit so results are reproducible
- Include at least one deterministic judge per task
- Track cost alongside pass rate
- Version your task definitions
