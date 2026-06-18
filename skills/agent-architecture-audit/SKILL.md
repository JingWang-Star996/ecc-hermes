---
name: agent-architecture-audit
description: "Full-stack diagnostic for agent and LLM applications. Audits the 12-layer agent stack for wrapper regression, memory pollution, tool discipline failures, hidden repair loops, and rendering corruption."
version: 1.0.0
author: "ECC (adapted for Hermes)"
---

# Agent Architecture Audit

A diagnostic workflow for agent systems that hide failures behind wrapper layers, stale memory, retry loops, or transport/rendering mutations.

## When to Activate

**MANDATORY for:**
- Releasing any agent or LLM-powered application to production
- Shipping features with tool calling, memory, or multi-step workflows
- Agent behavior degrades after adding wrapper layers
- User reports "the agent is getting worse" or "tools are flaky"
- Same model works in playground but breaks inside your wrapper
- Debugging agent behavior for more than 15 minutes without finding root cause

## The 12-Layer Stack

Every agent system has these layers. Any of them can corrupt the answer:

| # | Layer | What Goes Wrong |
|---|-------|----------------|
| 1 | System prompt | Conflicting instructions, instruction bloat |
| 2 | Session history | Stale context injection from previous turns |
| 3 | Long-term memory | Pollution across sessions, old topics in new conversations |
| 4 | Distillation | Compressed artifacts re-entering as pseudo-facts |
| 5 | Active recall | Redundant re-summary layers wasting context |
| 6 | Tool selection | Wrong tool routing, model skips required tools |
| 7 | Tool execution | Hallucinated execution — claims to call but doesn't |
| 8 | Tool interpretation | Misread or ignored tool output |
| 9 | Answer shaping | Format corruption in final response |
| 10 | Platform rendering | Transport-layer mutation (UI, API, CLI mutates valid answers) |
| 11 | Hidden repair loops | Silent fallback/retry agents running second LLM pass |
| 12 | Persistence | Expired state or cached artifacts reused as live evidence |

## Common Failure Patterns

### 1. Wrapper Regression
The base model produces correct answers, but the wrapper layers make it worse.

### 2. Memory Contamination
Old topics leak into new conversations through history, memory retrieval, or distillation.

### 3. Tool Discipline Failure
Tools are declared in the prompt but not enforced in code. The model skips them or hallucinates execution.

### 4. Rendering/Transport Corruption
The agent's internal answer is correct, but the platform layer mutates it during delivery.

### 5. Hidden Agent Layers
Silent repair, retry, summarization, or recall agents run without explicit contracts.

## Audit Workflow

### Phase 1: Scope
Define what you're auditing: target system, entrypoints, model stack, symptoms, time window, layers to audit.

### Phase 2: Evidence Collection
Gather evidence from the codebase: source code, logs, config, memory files.

### Phase 3: Failure Mapping
For each finding, document: symptom, mechanism, source layer, root cause, evidence, confidence.

### Phase 4: Fix Strategy
Default fix order (code-first, not prompt-first):
1. Code-gate tool requirements
2. Remove or narrow hidden repair agents
3. Reduce context duplication
4. Tighten memory admission
5. Tighten distillation triggers
6. Reduce rendering mutation
7. Convert to typed JSON envelopes

## Severity Model

| Level | Meaning | Action |
|-------|---------|--------|
| critical | Agent can confidently produce wrong operational behavior | Fix before next release |
| high | Agent frequently degrades correctness or stability | Fix this sprint |
| medium | Correctness usually survives but output is fragile or wasteful | Plan for next cycle |
| low | Mostly cosmetic or maintainability issues | Backlog |

## Quick Diagnostic Questions

| # | Question | If Yes → |
|---|----------|----------|
| 1 | Can the model skip a required tool and still answer? | Tool not code-gated |
| 2 | Does old conversation content appear in new turns? | Memory contamination |
| 3 | Is the same info in system prompt AND memory AND history? | Context duplication |
| 4 | Does the platform run a second LLM pass before delivery? | Hidden repair loop |
| 5 | Does the output differ between internal generation and user delivery? | Rendering corruption |
| 6 | Are "must use tool X" rules only in prompt text? | Tool discipline failure |
| 7 | Can the agent's own monologue become persistent memory? | Memory poisoning |
