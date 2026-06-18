---
name: ecc-hermes-guide
description: "Guide for using ECC-derived skills adapted for Hermes Agent. Contains 20 skills covering agent architecture, security, deployment, cost optimization, and engineering methodology."
version: 1.0.0
author: "ECC Community (adapted for Hermes)"
---

# ECC Skills for Hermes — Usage Guide

This package contains 20 skills adapted from the [Everything Claude Code (ECC)](https://github.com/affaan-m/everything-claude-code) repository for use with Hermes Agent. All Claude Code-specific dependencies (hooks, CLAUDE.md, /commands, MCP tool assumptions) have been removed or adapted.

## Skills Overview

### Agent Architecture & Debugging

| Skill | Purpose |
|-------|---------|
| `agent-architecture-audit` | 12-layer diagnostic for agent systems — finds wrapper regression, memory pollution, tool discipline failures |
| `agent-introspection-debugging` | 4-phase self-debugging workflow: capture → diagnose → recover → report |
| `agent-self-evaluation` | Rate output on 5 axes (accuracy, completeness, clarity, actionability, conciseness) |
| `agent-harness-construction` | Design agent action spaces, tool definitions, and observation formatting |
| `agentic-engineering` | Eval-first engineering: decomposition, model routing, cost discipline |

### Evaluation & Benchmarking

| Skill | Purpose |
|-------|---------|
| `agent-eval` | Head-to-head comparison of coding agents with pass rate, cost, time metrics |
| `benchmark-optimization-loop` | Convert "make it faster" into bounded measured optimization loops |
| `context-budget` | Audit context window consumption across skills, tools, and configuration |
| `token-budget-advisor` | Let users choose response depth (25%/50%/75%/100%) before answering |

### Continuous Operations

| Skill | Purpose |
|-------|---------|
| `continuous-agent-loop` | Patterns for continuous autonomous loops with quality gates and recovery |
| `cost-aware-llm-pipeline` | Model routing, budget tracking, retry logic, and prompt caching patterns |

### Software Engineering

| Skill | Purpose |
|-------|---------|
| `api-connector-builder` | Build API connectors matching the repo's existing integration pattern |
| `api-design` | REST API design: resource naming, status codes, pagination, versioning |
| `architecture-decision-records` | Capture architectural decisions as structured ADRs |
| `database-migrations` | Safe schema changes across PostgreSQL, MySQL, Prisma, Drizzle, Django, Go |
| `deployment-patterns` | CI/CD, Docker, health checks, rollback strategies, production checklists |
| `docker-patterns` | Docker Compose, container security, networking, volumes |
| `error-handling` | Typed errors, error boundaries, retries, circuit breakers (TS/Python/Go) |

### Security

| Skill | Purpose |
|-------|---------|
| `security-review` | Comprehensive security checklist: auth, input validation, XSS, CSRF, secrets |
| `security-bounty-hunter` | Find exploitable, bounty-worthy vulnerabilities (not noisy local-only findings) |

## How to Use

### Automatic Activation

These skills are automatically available when relevant. Hermes loads them based on your task context. For example:
- Working on API design? → `api-design` activates
- Debugging an agent? → `agent-introspection-debugging` activates
- Reviewing security? → `security-review` activates

### Manual Invocation

You can explicitly request a skill:
- "Use the agent-architecture-audit skill to diagnose this system"
- "Run a security review on this code"
- "Apply the database-migrations patterns to this schema change"

### Combining Skills

Skills work together naturally:
1. `agentic-engineering` → decompose work
2. `agent-harness-construction` → design tool interfaces
3. `agent-eval` → measure results
4. `agent-self-evaluation` → reflect on quality

## What Was Adapted

The following Claude Code-specific elements were removed or replaced:

| Original (Claude Code) | Adapted (Hermes) |
|------------------------|-------------------|
| `CLAUDE.md` | "project context" or "current session context" |
| `/command` invocations | Removed or replaced with Hermes equivalents |
| PreToolUse/PostToolUse hooks | Removed (Hermes doesn't have hooks) |
| `.claude/` directory references | Removed or generalized |
| Claude Code as runtime | Generalized to "agent runtime" |
| `claude -p` | Generalized to "run agent non-interactively" |
| firecrawl/exa MCP tools | Generalized to "web search tools" |
| Task tool (Claude Code) | `delegate_task` (Hermes) |
| `~/.claude/` paths | `~/.hermes/` paths |

## What Was Rejected (and Why)

14 skills from the original 34 were rejected:

| Skill | Rejection Reason |
|-------|-----------------|
| `agentic-os` | Entirely built around CLAUDE.md as kernel, .claude/commands/ as interface |
| `agent-payment-x402` | Deeply tied to Claude Code MCP server configuration |
| `autonomous-agent-harness` | Explicitly designed to "replace Hermes" using Claude Code runtime |
| `autonomous-loops` | All patterns reference `claude -p` CLI; too much rework needed |
| `benchmark` | Depends on browser MCP tool for Core Web Vitals measurement |
| `benchmark-methodology` | Brand/marketing competitive analysis, not code benchmarking |
| `continuous-learning` | Requires Claude Code Stop hook |
| `continuous-learning-v2` | Requires PreToolUse/PostToolUse hooks (100% hook-dependent) |
| `cost-tracking` | Tied to `~/.claude-cost-tracker/usage.db` SQLite database |
| `deep-research` | Requires firecrawl/exa MCP tools specifically |
| `design-system` | Depends on browser MCP for visual analysis |
| `prompt-optimizer` | Entirely built around ECC commands/agents catalog |
| `security-scan` | Tied to AgentShield tool scanning `.claude/` directory |
| `agent-sort` | Built around ECC installation surface (.claude/skills/) |

## Relationship to ecc-imports

The `ecc-imports` directory contains earlier, less-curated imports. This `ecc-hermes` package is the refined, curated set. Once this package is validated, `ecc-imports` can be safely removed.

## Version History

- **v1.0.0** — Initial adaptation of 20 skills from ECC for Hermes Agent
