---
name: agent-introspection-debugging
description: "Structured self-debugging workflow for AI agent failures using capture, diagnosis, contained recovery, and introspection reports."
version: 1.0.0
author: "ECC (adapted for Hermes)"
---

# Agent Introspection Debugging

Use this skill when an agent run is failing repeatedly, consuming tokens without progress, looping on the same tools, or drifting away from the intended task.

This is a workflow skill. It teaches the agent to debug itself systematically before escalating to a human.

## When to Activate

- Maximum tool call / loop-limit failures
- Repeated retries with no forward progress
- Context growth or prompt drift that starts degrading output quality
- File-system or environment state mismatch between expectation and reality
- Tool failures that are likely recoverable with diagnosis and a smaller corrective action

## Four-Phase Loop

### Phase 1: Failure Capture

Before trying to recover, record the failure precisely.

Capture:
- error type, message, and stack trace when available
- last meaningful tool call sequence
- what the agent was trying to do
- current context pressure
- current environment assumptions

### Phase 2: Root-Cause Diagnosis

Match the failure to a known pattern before changing anything.

| Pattern | Likely Cause | Check |
| --- | --- | --- |
| Maximum tool calls / repeated same command | loop or no-exit observer path | inspect the last N tool calls for repetition |
| Context overflow / degraded reasoning | unbounded notes, repeated plans | inspect recent context for duplication |
| Connection refused / timeout | service unavailable or wrong port | verify service health, URL, and port |
| Rate limit / quota exhaustion | retry storm or missing backoff | count repeated calls |
| File missing after write | race, wrong cwd, or branch drift | re-check path, cwd, git status |
| Tests still failing after "fix" | wrong hypothesis | isolate the exact failing test |

### Phase 3: Contained Recovery

Recover with the smallest action that changes the diagnosis surface.

Safe recovery actions:
- stop repeated retries and restate the hypothesis
- trim low-signal context
- re-check the actual filesystem / branch / process state
- narrow the task to one failing command, one file, or one test
- switch from speculative reasoning to direct observation
- escalate to a human when the failure is high-risk or externally blocked

### Phase 4: Introspection Report

End with a report that makes the recovery legible:

```markdown
## Agent Self-Debug Report
- Session / task:
- Failure:
- Root cause:
- Recovery action:
- Result: success | partial | blocked
- Token / time burn risk:
- Follow-up needed:
- Preventive change to encode later:
```

## Recovery Heuristics

Prefer these interventions in order:
1. Restate the real objective in one sentence.
2. Verify the world state instead of trusting memory.
3. Shrink the failing scope.
4. Run one discriminating check.
5. Only then retry.
