# ECC for Hermes & OpenClaw

[中文文档](README.zh-CN.md)

> ECC skills adapted for [Hermes Agent](https://github.com/NousResearch/hermes-agent) and [OpenClaw](https://github.com/anthropics/openclaw).

## What is this?

[ECC (Everything Claude Code)](https://github.com/affaan-m/ECC) is a 217K+ stars collection of skills, hooks, and best practices for AI coding agents. However, ECC doesn't natively support Hermes or OpenClaw.

This project adapts **23 universal skills** from ECC for Hermes and OpenClaw users:
- ✅ Removed Claude Code-specific dependencies (hooks, CLAUDE.md, /commands)
- ✅ Preserved core methodologies and best practices
- ✅ Format-compliant with Hermes/OpenClaw skill specs

## Quick Install

```bash
# Clone and install
git clone https://github.com/JingWang-Star996/ecc-hermes.git
cd ecc-hermes
./install.sh
```

The installer auto-detects Hermes and/or OpenClaw and installs skills to the correct location.

## Skills Overview

### Agent Architecture (5 skills)
| Skill | Purpose |
|-------|---------|
| `agent-architecture-audit` | 12-layer diagnostic for agent systems |
| `agent-introspection-debugging` | 4-phase self-debugging workflow |
| `agent-self-evaluation` | Rate output on 5 axes (accuracy, completeness, clarity, actionability, conciseness) |
| `agent-harness-construction` | Design agent action spaces and tool definitions |
| `agentic-engineering` | Eval-first engineering methodology |

### Evaluation & Benchmarking (4 skills)
| Skill | Purpose |
|-------|---------|
| `agent-eval` | Head-to-head comparison of coding agents |
| `benchmark-optimization-loop` | Bounded measured optimization loops |
| `context-budget` | Audit context window consumption |
| `token-budget-advisor` | Control response depth before answering |

### Continuous Operations (5 skills)
| Skill | Purpose |
|-------|---------|
| `continuous-agent-loop` | Patterns for autonomous agent loops |
| `cost-aware-llm-pipeline` | Cost optimization for LLM API usage |
| `continuous-learning-v2` | Instinct-based learning system with confidence scoring |
| `cost-tracking` | Track token usage, spending, and budgets |
| `prompt-optimizer` | Analyze and optimize prompts for better performance |

### Software Engineering (7 skills)
| Skill | Purpose |
|-------|---------|
| `api-connector-builder` | Build API connectors following existing patterns |
| `api-design` | REST API design patterns |
| `architecture-decision-records` | Capture architectural decisions as ADRs |
| `database-migrations` | Schema changes and zero-downtime deployments |
| `deployment-patterns` | CI/CD pipelines and production readiness |
| `docker-patterns` | Docker and Compose patterns |
| `error-handling` | Error handling patterns for TS/Python/Go |

### Security (2 skills)
| Skill | Purpose |
|-------|---------|
| `security-review` | Security checklist and patterns |
| `security-bounty-hunter` | Hunt for exploitable security issues |

## What was NOT adapted

**11 skills rejected** due to:
- 🔴 Claude Code hooks dependency (6): `autonomous-loops`, `autonomous-agent-harness`, etc.
- 🟡 MCP tool dependency (3): `deep-research` (firecrawl/exa), `design-system`
- 🟡 Wrong domain (2): `benchmark-methodology`, `agent-sort`

See [docs/ADAPTATION-NOTES.md](docs/ADAPTATION-NOTES.md) for details.

## Usage

After installation, skills are available in your agent:

**Hermes**:
```
/skill agent-architecture-audit
```

**OpenClaw**:
```
Load skill: agent-architecture-audit
```

## Contributing

Contributions welcome! Areas for improvement:
- Adapt more ECC skills
- Add Hermes-specific hooks (if Hermes adds hook support)
- Translate documentation
- Add usage examples

## License

MIT — same as the original ECC project.

## Credits

- Original ECC: [affaan-m/ECC](https://github.com/affaan-m/ECC) (217K+ stars)
- Hermes Agent: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- OpenClaw: [anthropics/openclaw](https://github.com/anthropics/openclaw)

---

**Made with ❤️ for the Hermes & OpenClaw community**
