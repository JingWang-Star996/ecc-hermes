---
name: continuous-learning-v2
description: >-
  Instinct-based learning system that observes sessions, creates atomic instincts
  with confidence scoring, and evolves them into skills. Adapted for Hermes/OpenClaw
  using AGENTS.md rules and periodic analysis instead of native hooks.
version: 2.1.0-hermes
author: ECC Community (adapted for Hermes/OpenClaw)
tags: [learning, instincts, continuous-improvement]
---

# Continuous Learning v2.1 - Instinct-Based Architecture (Hermes/OpenClaw Adaptation)

An advanced learning system that turns your sessions into reusable knowledge through atomic "instincts" - small learned behaviors with confidence scoring.

**Adaptation Note**: This skill is adapted from Claude Code's hook-based system. Since Hermes/OpenClaw don't have native PreToolUse/PostToolUse hooks, we use:
- **AGENTS.md rules** for observation reminders
- **Periodic cron jobs** for batch analysis
- **Manual triggers** for instinct evolution

**v2.1** adds **project-scoped instincts** — patterns stay in their project context, universal patterns are shared globally.

## When to Activate

- Setting up automatic learning from sessions
- Configuring instinct-based behavior extraction
- Tuning confidence thresholds for learned behaviors
- Reviewing, exporting, or importing instinct libraries
- Evolving instincts into full skills
- Managing project-scoped vs global instincts

## The Instinct Model

An instinct is a small learned behavior:

```yaml
---
id: prefer-functional-style
trigger: "when writing new functions"
confidence: 0.7
domain: "code-style"
source: "session-observation"
scope: project
project_id: "a1b2c3d4e5f6"
project_name: "my-react-app"
---

# Prefer Functional Style

## Action
Use functional patterns over classes when appropriate.

## Evidence
- Observed 5 instances of functional pattern preference
- User corrected class-based approach to functional on 2025-01-15
```

**Properties:**
- **Atomic** -- one trigger, one action
- **Confidence-weighted** -- 0.3 = tentative, 0.9 = near certain
- **Domain-tagged** -- code-style, testing, git, debugging, workflow, etc.
- **Evidence-backed** -- tracks what observations created it
- **Scope-aware** -- `project` (default) or `global`

## How It Works (Hermes/OpenClaw Version)

```
Session Activity
      |
      | AGENTS.md rules remind to observe patterns
      | + detect project context (git remote / repo path)
      v
+---------------------------------------------+
|  observations.jsonl                          |
|   (prompts, tool calls, outcomes, project)   |
+---------------------------------------------+
      |
      | Periodic analysis (cron or manual)
      v
+---------------------------------------------+
|          PATTERN DETECTION                   |
|   * User corrections -> instinct             |
|   * Error resolutions -> instinct            |
|   * Repeated workflows -> instinct           |
|   * Scope decision: project or global?       |
+---------------------------------------------+
      |
      | Creates/updates
      v
+---------------------------------------------+
|  projects/<project-hash>/instincts/          |
|   * prefer-functional-style.yaml (0.7)       |
|   * use-react-hooks.yaml (0.9)               |
+---------------------------------------------+
|  instincts/global/                           |
|   * always-validate-input.yaml (0.85)        |
|   * grep-before-edit.yaml (0.6)              |
+---------------------------------------------+
      |
      | Manual /evolve command
      v
+---------------------------------------------+
|  evolved/skills/                             |
|   * testing-workflow.md                      |
|   * deployment-patterns.md                   |
+---------------------------------------------+
```

## Quick Start

### 1. Set Up Observation (AGENTS.md Rules)

Add to your `AGENTS.md`:

```markdown
## Continuous Learning Observation

After significant interactions, note patterns in observations.jsonl:
- User corrections (when you did something wrong and user fixed it)
- Error resolutions (when you debugged and fixed an issue)
- Repeated workflows (when you did the same thing 3+ times)

Log format:
```json
{
  "timestamp": "2026-01-15T10:30:00Z",
  "type": "correction|resolution|workflow",
  "trigger": "what triggered the pattern",
  "action": "what was done",
  "outcome": "success|failure|corrected",
  "project": "project-name-or-global"
}
```

Store observations in:
- Project-scoped: `.ecc-homunculus/projects/<hash>/observations.jsonl`
- Global: `.ecc-homunculus/observations.jsonl`
```

### 2. Initialize Directory Structure

```bash
# Create directories
mkdir -p ~/.ecc-homunculus/{instincts/global,evolved/skills,projects}

# For current project (if in git repo)
PROJECT_HASH=$(git remote get-url origin 2>/dev/null | sha256sum | cut -c1-12)
mkdir -p .ecc-homunculus/projects/$PROJECT_HASH/instincts
```

### 3. Periodic Analysis (Cron Job)

Set up a cron job to analyze observations weekly:

```bash
# Hermes cron example
hermes cron add --name "instinct-analysis" \
  --schedule "0 9 * * 1" \
  --prompt "Analyze observations in .ecc-homunculus/ and create/update instincts with confidence scoring"
```

Or manually trigger analysis:
```
Load skill: continuous-learning-v2
Then say: "Analyze my recent observations and create instincts"
```

## Commands

| Command | Description |
|---------|-------------|
| `Load skill: continuous-learning-v2` then "Show instinct status" | Show all instincts with confidence |
| `Load skill: continuous-learning-v2` then "Evolve instincts" | Cluster related instincts into skills |
| `Load skill: continuous-learning-v2` then "Export instincts" | Export instincts to file |
| `Load skill: continuous-learning-v2` then "Import instincts from file" | Import instincts |
| `Load skill: continuous-learning-v2` then "Promote project instinct to global" | Promote project instincts |

## Configuration

Create `~/.ecc-homunculus/config.json`:

```json
{
  "version": "2.1-hermes",
  "analysis": {
    "min_observations_to_create_instinct": 3,
    "confidence_increase_per_observation": 0.1,
    "confidence_decrease_on_correction": 0.2,
    "min_confidence_to_apply": 0.5
  },
  "promotion": {
    "min_projects_with_same_instinct": 2,
    "min_confidence_for_promotion": 0.8
  }
}
```

## File Structure

```
~/.ecc-homunculus/
+-- config.json              # Configuration
+-- observations.jsonl       # Global observations (fallback)
+-- instincts/
|   +-- global/              # Global auto-learned instincts
|       +-- always-validate-input.yaml
|       +-- grep-before-edit.yaml
+-- evolved/
|   +-- skills/              # Global generated skills
|       +-- testing-workflow.md
+-- projects/
    +-- a1b2c3d4e5f6/        # Project hash (from git remote URL)
    |   +-- observations.jsonl
    |   +-- instincts/
    |   |   +-- prefer-functional-style.yaml
    |   +-- evolved/
    |       +-- skills/
    +-- f6e5d4c3b2a1/        # Another project
        +-- ...
```

## Scope Decision Guide

| Pattern Type | Scope | Examples |
|-------------|-------|---------|
| Language/framework conventions | **project** | "Use React hooks", "Follow Django REST patterns" |
| File structure preferences | **project** | "Tests in `__tests__`/", "Components in src/components/" |
| Code style | **project** | "Use functional style", "Prefer dataclasses" |
| Error handling strategies | **project** | "Use Result type for errors" |
| Security practices | **global** | "Validate user input", "Sanitize SQL" |
| General best practices | **global** | "Write tests first", "Always handle errors" |
| Tool workflow preferences | **global** | "Grep before Edit", "Read before Write" |
| Git practices | **global** | "Conventional commits", "Small focused commits" |

## Confidence Scoring

Confidence evolves over time:

| Score | Meaning | Behavior |
|-------|---------|----------|
| 0.3 | Tentative | Suggested but not enforced |
| 0.5 | Moderate | Applied when relevant |
| 0.7 | Strong | Auto-approved for application |
| 0.9 | Near-certain | Core behavior |

**Confidence increases** when:
- Pattern is repeatedly observed
- User doesn't correct the suggested behavior
- Similar instincts from other sources agree

**Confidence decreases** when:
- User explicitly corrects the behavior
- Pattern isn't observed for extended periods
- Contradicting evidence appears

## Differences from Claude Code Version

| Feature | Claude Code | Hermes/OpenClaw |
|---------|-------------|-----------------|
| Observation | PreToolUse/PostToolUse hooks (100% reliable) | AGENTS.md rules + manual logging |
| Analysis | Background agent (automatic) | Periodic cron or manual trigger |
| Reliability | Every tool call observed | Depends on agent remembering to log |
| Commands | /instinct-status, /evolve | Load skill + natural language |

**Mitigation**: Use Heartbeat checks to remind yourself to log observations:

```markdown
## Heartbeat Checklist
- [ ] Log any user corrections since last check
- [ ] Log any error resolutions
- [ ] Check if any patterns are repeating
```

## Privacy

- Observations stay **local** on your machine
- Project-scoped instincts are isolated per project
- Only **instincts** (patterns) can be exported — not raw observations
- No actual code or conversation content is shared
- You control what gets exported and promoted

## Related

- `cost-tracking` - Track token usage and costs
- `token-budget-advisor` - Control response depth
- Original ECC: https://github.com/affaan-m/ECC

---

*Instinct-based learning: teaching your agent your patterns, one project at a time.*
