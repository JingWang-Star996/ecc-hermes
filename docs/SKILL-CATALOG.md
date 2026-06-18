# Skill Catalog

Complete catalog of adapted ECC skills for Hermes and OpenClaw.

## Agent Architecture & Debugging (5 skills)

### agent-architecture-audit
**Purpose**: Full-stack diagnostic for agent and LLM applications  
**Use when**: Auditing agent systems, finding wrapper regression, memory pollution, tool discipline failures  
**Key features**:
- 12-layer agent stack diagnostic
- Wrapper regression detection
- Memory pollution identification
- Tool discipline failure analysis

### agent-introspection-debugging
**Purpose**: Structured self-debugging workflow for AI agent failures  
**Use when**: Agent fails, needs diagnosis and recovery  
**Key features**:
- 4-phase workflow: capture → diagnose → recover → report
- Contained recovery patterns
- Introspection report generation

### agent-self-evaluation
**Purpose**: Self-rate output on 5 axes  
**Use when**: Evaluating output quality before delivery  
**Key features**:
- 5-axis evaluation: accuracy, completeness, clarity, actionability, conciseness
- Evidence-based scoring
- Concrete improvement suggestions

### agent-harness-construction
**Purpose**: Design and optimize AI agent action spaces  
**Use when**: Building new agents, optimizing tool definitions  
**Key features**:
- Action space design patterns
- Tool definition optimization
- Observation formatting best practices

### agentic-engineering
**Purpose**: Eval-first engineering methodology  
**Use when**: Building agent systems, decomposing complex tasks  
**Key features**:
- Evaluation-first execution
- Task decomposition patterns
- Cost-aware model routing
- Decomposition strategies

## Evaluation & Benchmarking (4 skills)

### agent-eval
**Purpose**: Head-to-head comparison of coding agents  
**Use when**: Comparing agents (Claude Code, Aider, Codex, etc.)  
**Key features**:
- Pass rate metrics
- Cost tracking
- Time measurement
- Consistency analysis

### benchmark-optimization-loop
**Purpose**: Convert optimization requests into bounded measured loops  
**Use when**: "Make it faster" type requests  
**Key features**:
- Evidence-based variant testing
- Bounded optimization loops
- Measurement-first approach

### context-budget
**Purpose**: Audit context window consumption  
**Use when**: Context feels bloated, performance degrading  
**Key features**:
- Component inventory (skills, tools, config)
- Token consumption estimation
- Prioritized savings recommendations

### token-budget-advisor
**Purpose**: Control response depth before answering  
**Use when**: User wants to control token usage  
**Key features**:
- Pre-response depth choice
- 4-level depth options (25%, 50%, 75%, 100%)
- Token estimation

## Continuous Operations (2 skills)

### continuous-agent-loop
**Purpose**: Patterns for continuous autonomous agent loops  
**Use when**: Building autonomous workflows  
**Key features**:
- Quality gates
- Eval patterns
- Recovery controls
- Loop architecture patterns

### cost-aware-llm-pipeline
**Purpose**: Cost optimization for LLM API usage  
**Use when**: Managing LLM costs, optimizing API usage  
**Key features**:
- Model routing by task complexity
- Budget tracking
- Retry logic optimization
- Prompt caching strategies

### continuous-learning-v2
**Purpose**: Instinct-based learning system that observes sessions and evolves patterns into skills  
**Use when**: Setting up automatic learning, reviewing instincts, evolving patterns  
**Key features**:
- Atomic "instincts" with confidence scoring
- Project-scoped vs global patterns
- Periodic analysis via cron or manual trigger
- Evolution pipeline: observations → instincts → skills

### cost-tracking
**Purpose**: Track and report token usage, spending, and budgets  
**Use when**: Analyzing costs, checking usage trends, budget planning  
**Key features**:
- Query Hermes/OpenClaw session databases
- Estimate token usage from message content
- Cost breakdown by session, model, date
- CSV export for further analysis

### prompt-optimizer
**Purpose**: Analyze and optimize prompts for better agent performance  
**Use when**: Improving prompt quality, writing better instructions  
**Key features**:
- 6-phase analysis pipeline
- Intent detection and scope assessment
- Skill matching and workflow recommendation
- Full and quick optimized prompt versions

## Software Engineering (7 skills)

### api-connector-builder
**Purpose**: Build API connectors following existing patterns  
**Use when**: Adding new API integrations  
**Key features**:
- Pattern matching with existing integrations
- Connector scaffolding
- Error handling patterns

### api-design
**Purpose**: REST API design patterns  
**Use when**: Designing new APIs  
**Key features**:
- Resource naming conventions
- Status code patterns
- Pagination strategies
- Error response formats
- Versioning approaches

### architecture-decision-records
**Purpose**: Capture architectural decisions as ADRs  
**Use when**: Making important design decisions  
**Key features**:
- Auto-detect decision moments
- Context recording
- Alternatives considered
- Rationale documentation

### database-migrations
**Purpose**: Database migration best practices  
**Use when**: Schema changes, data migrations  
**Key features**:
- Zero-downtime deployments
- Rollback strategies
- ORM-specific patterns
- PostgreSQL/MySQL guidance

### deployment-patterns
**Purpose**: CI/CD pipelines and production readiness  
**Use when**: Deploying applications  
**Key features**:
- CI/CD pipeline patterns
- Docker containerization
- Health checks
- Rollback strategies
- Production readiness checklists

### docker-patterns
**Purpose**: Docker and Compose patterns  
**Use when**: Containerizing applications  
**Key features**:
- Local development patterns
- Container security
- Networking strategies
- Volume management
- Multi-service orchestration

### error-handling
**Purpose**: Error handling patterns for TS/Python/Go  
**Use when**: Adding error handling to code  
**Key features**:
- Typed error classes
- Error boundaries
- Retry logic
- Circuit breakers
- User-facing error messages

## Security (2 skills)

### security-review
**Purpose**: Security checklist and patterns  
**Use when**: Reviewing code for security issues  
**Key features**:
- Authentication patterns
- Input handling
- Secrets management
- API endpoint security
- Sensitive feature protection

### security-bounty-hunter
**Purpose**: Hunt for exploitable security issues  
**Use when**: Security auditing, bug bounty hunting  
**Key features**:
- Remotely reachable vulnerability detection
- Bounty-worthy issue identification
- Exploitability assessment

## Usage Guide

### ecc-hermes-guide
**Purpose**: Complete usage guide for all adapted skills  
**Contents**:
- Skill overview and categories
- Adaptation notes
- Usage examples
- Troubleshooting

## Skill Statistics

| Category | Count |
|----------|-------|
| Agent Architecture | 5 |
| Evaluation & Benchmarking | 4 |
| Continuous Operations | 2 |
| Software Engineering | 7 |
| Security | 2 |
| Usage Guide | 1 |
| **Total** | **21** |

## Rejected Skills (11)

See [ADAPTATION-NOTES.md](ADAPTATION-NOTES.md) for details on why these skills were not adapted.

### Claude Code Hooks Dependency (6)
- continuous-learning (deprecated, replaced by v2)
- autonomous-loops
- autonomous-agent-harness
- security-scan
- agentic-os
- agent-sort

### MCP Tool Dependency (3)
- deep-research
- design-system
- benchmark

### Wrong Domain (2)
- benchmark-methodology
- agent-sort (duplicate)

---

**Total ECC skills**: 271  
**Adapted**: 23 (8.5%)  
**Rejected**: 11 (4.1%)  
**Not reviewed**: 237 (87.4%)

The 237 unreviewed skills are mostly language-specific (TypeScript, Python, Go, etc.) or framework-specific (React, Django, etc.) and can be adapted on-demand.
