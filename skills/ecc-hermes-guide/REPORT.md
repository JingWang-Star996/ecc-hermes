# ECC → Hermes Skills Adaptation Report

**Date**: 2026-06-18
**Source**: /tmp/ecc-analysis/skills/ (34 candidate skills)
**Output**: ~/.hermes/skills/ecc-hermes/ (20 adapted skills)
**Guide**: ~/.hermes/skills/ecc-hermes-guide/SKILL.md

---

## Summary

| Category | Count |
|----------|-------|
| Total candidates | 34 |
| **Adopted** | **20** |
| **Rejected** | **14** |
| Adoption rate | 59% |

---

## Adopted Skills (20)

### Tier 1: Pure Methodology (no adaptation needed beyond frontmatter)

| # | Skill | Lines | Value |
|---|-------|-------|-------|
| 1 | agent-architecture-audit | 257 | 12-layer diagnostic for agent systems |
| 2 | agent-harness-construction | 74 | Action space + observation design |
| 3 | agent-introspection-debugging | 154 | 4-phase self-debugging workflow |
| 4 | agent-self-evaluation | 182 | 5-axis output quality scoring |
| 5 | api-connector-builder | 121 | Repo-native integration patterns |
| 6 | api-design | 524 | REST API design patterns (complete reference) |
| 7 | architecture-decision-records | 180 | Structured ADR capture workflow |
| 8 | benchmark-optimization-loop | 70 | Measured optimization methodology |
| 9 | cost-aware-llm-pipeline | 184 | Model routing + budget tracking code |
| 10 | database-migrations | 430 | Multi-ORM migration patterns |
| 11 | deployment-patterns | 428 | CI/CD + Docker + production readiness |
| 12 | docker-patterns | 365 | Container dev patterns |
| 13 | error-handling | 377 | Typed errors across TS/Python/Go |
| 14 | security-bounty-hunter | 100 | Exploitable vulnerability discovery |
| 15 | security-review | 504 | Comprehensive security checklist |

### Tier 2: Minor Adaptation (removed Claude Code references)

| # | Skill | Adaptation |
|---|-------|-----------|
| 16 | agentic-engineering | Changed model names to generic tiers |
| 17 | agent-eval | Removed Claude Code-specific CLI references |
| 18 | context-budget | Changed CLAUDE.md → "project context file" |
| 19 | continuous-agent-loop | Short skill, minimal changes needed |
| 20 | token-budget-advisor | Removed Claude Code trigger patterns |

---

## Rejected Skills (14)

| # | Skill | Rejection Reason | Severity |
|---|-------|-----------------|----------|
| 1 | agentic-os | Entirely built around CLAUDE.md as kernel, .claude/commands/ as interface, Claude Code as runtime. Cannot be meaningfully adapted. | 🔴 Fundamental |
| 2 | agent-payment-x402 | Deeply tied to Claude Code MCP server config (mcpServers JSON). Blockchain payment niche. | 🔴 Fundamental |
| 3 | autonomous-agent-harness | Explicitly designed to "replace Hermes" using Claude Code's native crons, dispatch, and MCP. Architecture diagram references Claude Code Runtime. | 🔴 Fundamental |
| 4 | autonomous-loops | All 6 patterns reference `claude -p` CLI. NanoClaw REPL, Continuous Claude PR Loop, etc. are Claude Code-specific implementations. | 🔴 Fundamental |
| 5 | benchmark | Depends on browser MCP tool for Core Web Vitals measurement. Core methodology is thin without the tool. | 🟡 Tool-dependent |
| 6 | benchmark-methodology | Not about code benchmarks — it's brand/marketing competitive analysis (positioning, visual identity, pricing). Wrong domain for Hermes dev skills. | 🟡 Wrong domain |
| 7 | continuous-learning | Requires Claude Code Stop hook for session-end pattern extraction. | 🔴 Fundamental |
| 8 | continuous-learning-v2 | 100% dependent on PreToolUse/PostToolUse hooks for observation. Core architecture is hook-based. | 🔴 Fundamental |
| 9 | cost-tracking | Tied to `~/.claude-cost-tracker/usage.db` SQLite schema. All SQL queries reference Claude Code session_id. | 🔴 Fundamental |
| 10 | deep-research | Requires firecrawl_search, firecrawl_scrape, web_search_exa MCP tools. Workflow is tool-centric. | 🟡 Tool-dependent |
| 11 | design-system | Mode 1 requires browser MCP for competitor research. Mode 2 requires browser MCP for visual audit. | 🟡 Tool-dependent |
| 12 | prompt-optimizer | Entirely built around ECC commands (/plan, /tdd, /verify), agents (planner, tdd-guide), and skills catalog. | 🔴 Fundamental |
| 13 | security-scan | Tied to AgentShield (ecc-agentshield npm package) scanning `.claude/` directory structure. | 🔴 Fundamental |
| 14 | agent-sort | Built around ECC installation surface (.claude/skills/, commands/, rules/, hooks/). Methodology is ECC-specific. | 🟡 ECC-specific |

### Rejection Severity Legend
- 🔴 **Fundamental**: Core architecture depends on Claude Code features. Cannot be adapted without rewriting from scratch.
- 🟡 **Tool-dependent**: Requires specific MCP tools not available in Hermes by default.
- 🟡 **Wrong domain**: Skill is for a different purpose than expected.
- 🟡 **ECC-specific**: Methodology is tied to ECC's installation/organization model.

---

## Adaptation Rules Applied

| Claude Code Element | Hermes Equivalent |
|---------------------|-------------------|
| `CLAUDE.md` | "project context" or "current session context" |
| `/command` invocations | Removed or described as manual workflow steps |
| PreToolUse/PostToolUse hooks | Removed (Hermes has no hook system) |
| `.claude/` directory | Removed or generalized |
| `claude -p` | "run agent non-interactively" or `delegate_task` |
| `~/.claude/` paths | `~/.hermes/` paths |
| firecrawl/exa MCP | "web search tools" (generic) |
| Task tool | `delegate_task` |
| Claude Code as runtime | "agent runtime" (generic) |
| Model names (Sonnet/Opus/Haiku) | "light/medium/heavy model" tiers |

---

## Files Created

```
~/.hermes/skills/
├── ecc-hermes/                          # 20 adapted skills
│   ├── agent-architecture-audit/SKILL.md
│   ├── agent-eval/SKILL.md
│   ├── agent-harness-construction/SKILL.md
│   ├── agent-introspection-debugging/SKILL.md
│   ├── agent-self-evaluation/SKILL.md
│   ├── agentic-engineering/SKILL.md
│   ├── api-connector-builder/SKILL.md
│   ├── api-design/SKILL.md
│   ├── architecture-decision-records/SKILL.md
│   ├── benchmark-optimization-loop/SKILL.md
│   ├── context-budget/SKILL.md
│   ├── continuous-agent-loop/SKILL.md
│   ├── cost-aware-llm-pipeline/SKILL.md
│   ├── database-migrations/SKILL.md
│   ├── deployment-patterns/SKILL.md
│   ├── docker-patterns/SKILL.md
│   ├── error-handling/SKILL.md
│   ├── security-bounty-hunter/SKILL.md
│   ├── security-review/SKILL.md
│   └── token-budget-advisor/SKILL.md
└── ecc-hermes-guide/
    └── SKILL.md                         # Usage guide + adaptation notes
```

---

## Recommendations

1. **Immediate use**: The 15 Tier-1 skills are production-ready and can be used immediately.
2. **Test Tier-2 skills**: The 5 adapted skills should be tested in real workflows to verify the adaptations work correctly.
3. **Future work**: If Hermes adds a hook system or web search MCP, the rejected tool-dependent skills (deep-research, design-system, benchmark) could be reconsidered.
4. **Cleanup**: Once ecc-hermes is validated, the ecc-imports directory can be removed.
