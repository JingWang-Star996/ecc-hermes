# Adaptation Notes

This document explains how ECC skills were adapted for Hermes and OpenClaw.

## Overview

ECC (Everything Claude Code) was designed for Claude Code with specific features:
- **Hooks system**: PreToolUse/PostToolUse hooks for runtime enforcement
- **CLAUDE.md**: Project-level configuration and context
- **/commands**: Slash commands for workflow triggers
- **MCP tools**: Specific MCP server integrations (firecrawl, exa, etc.)

Hermes and OpenClaw don't have these features (or have different implementations), so we adapted the skills accordingly.

## What Was Removed

### 1. Claude Code Hooks

**Original pattern**:
```yaml
hooks:
  PreToolUse:
    - matcher: "write_file"
      hooks:
        - type: command
          command: "check-secrets.sh"
```

**Adaptation**: Removed entirely. Hermes/OpenClaw don't have hook systems. The methodology and best practices are preserved in the skill content.

### 2. CLAUDE.md References

**Original**:
```markdown
Read CLAUDE.md for project conventions before proceeding.
```

**Adapted**:
```markdown
Read the project context (AGENTS.md, README.md, or current session context) before proceeding.
```

### 3. Slash Commands

**Original**:
```markdown
Use `/security-review` to trigger this skill.
```

**Adapted**:
```markdown
Load this skill via your agent's skill loading mechanism:
- Hermes: `/skill security-review`
- OpenClaw: `Load skill: security-review`
```

### 4. Claude-Specific Model Names

**Original**:
```markdown
Use claude-sonnet-4 for complex tasks, claude-haiku for simple tasks.
```

**Adapted**:
```markdown
Use a heavier model (e.g., qwen3.7-plus, claude-sonnet-4) for complex tasks, 
a lighter model (e.g., qwen-turbo, claude-haiku) for simple tasks.
```

### 5. MCP Tool Dependencies

**Original**:
```markdown
This skill requires firecrawl_search and exa web_search_exa MCP tools.
```

**Adaptation**: Skills with hard MCP dependencies were rejected (see Rejected Skills below). Skills with optional MCP dependencies were adapted to note the requirement.

## What Was Preserved

### ✅ Core Methodologies

- Evaluation-first engineering
- Bounded optimization loops
- Security review checklists
- Error handling patterns
- Architecture decision records

### ✅ Best Practices

- Token budget management
- Context window optimization
- Cost-aware model routing
- Continuous learning patterns
- Agent self-evaluation frameworks

### ✅ Checklists and Workflows

- Pre-deployment checklists
- Security review steps
- Database migration procedures
- Docker patterns
- API design principles

## Rejected Skills (14 total)

### 🔴 Claude Code Hooks Dependency (9 skills)

| Skill | Reason |
|-------|--------|
| `continuous-learning` | Requires Stop hook for session evaluation |
| `continuous-learning-v2` | Requires PreToolUse/PostToolUse hooks |
| `autonomous-loops` | Relies on hook-based loop control |
| `autonomous-agent-harness` | Hook-dependent orchestration |
| `cost-tracking` | Requires hook-based usage tracking |
| `prompt-optimizer` | Hook-based prompt analysis |
| `security-scan` | Hook-based security scanning |
| `agentic-os` | Full OS-level hook integration |
| `agent-sort` | Hook-based task sorting |

**Why not adapted**: These skills fundamentally depend on Claude Code's hook system for runtime enforcement. Without hooks, the core functionality cannot be replicated.

**Alternative**: Hermes users can implement similar functionality via:
- Cron jobs for periodic tasks
- Manual skill loading for on-demand workflows
- Custom scripts for automation

### 🟡 MCP Tool Dependency (3 skills)

| Skill | Required Tools | Reason |
|-------|---------------|--------|
| `deep-research` | firecrawl, exa | Hard dependency on web scraping MCPs |
| `design-system` | Specific design MCPs | Tool-specific workflows |
| `benchmark` | Benchmark MCPs | Tool-specific measurement |

**Why not adapted**: These skills require specific MCP servers that are not universally available. Users can manually install the required MCPs if needed.

### 🟡 Wrong Domain (2 skills)

| Skill | Reason |
|-------|--------|
| `benchmark-methodology` | ECC-specific meta-methodology |
| `agent-sort` | Claude Code task sorting |

**Why not adapted**: These skills are specific to ECC's internal workflows or Claude Code's task management.

## Adaptation Process

### Step 1: Scan for Dependencies

For each skill, we checked:
- Hook references (PreToolUse, PostToolUse, Stop)
- CLAUDE.md mentions
- /command invocations
- MCP tool requirements
- Claude-specific model names

### Step 2: Classify

- **Adaptable**: No hard dependencies, or dependencies can be generalized
- **Rejectable**: Hard dependencies on Claude Code features

### Step 3: Adapt

For adaptable skills:
1. Remove hook references
2. Replace CLAUDE.md with "project context"
3. Replace /commands with skill loading instructions
4. Generalize model names to tiers (light/medium/heavy)
5. Update YAML frontmatter to Hermes/OpenClaw format

### Step 4: Validate

- Check YAML frontmatter is valid
- Verify no Claude Code-specific references remain
- Test skill loading in Hermes and OpenClaw

## Format Differences

### Hermes Skill Format

```yaml
---
name: skill-name
description: "Skill description"
version: 1.0.0
author: "Author name"
tags: [tag1, tag2]
---

# Skill Title

Content...
```

### OpenClaw Skill Format

Same as Hermes. Both use YAML frontmatter + markdown.

### Original ECC Format

```yaml
---
name: skill-name
description: >-
  Multi-line description
metadata:
  origin: ECC
---

# Skill Title

Content...
```

**Adaptation**: We updated frontmatter to include `version`, `author`, and `tags` fields for better compatibility.

## Future Improvements

### If Hermes Adds Hook Support

Re-adapt the 9 rejected skills that depend on hooks:
- `continuous-learning-v2` → Session-based learning
- `autonomous-loops` → Loop control via hooks
- `cost-tracking` → Usage tracking via hooks

### If Hermes Adds MCP Support

Re-adapt MCP-dependent skills:
- `deep-research` → With firecrawl/exa MCPs
- `design-system` → With design MCPs

### Hermes-Specific Enhancements

Add Hermes-specific skills:
- Gateway optimization
- Cron job patterns
- Multi-agent coordination
- Feishu/Telegram integration patterns

## Contributing

Want to adapt more skills? Follow this process:

1. **Choose a skill** from the rejected list
2. **Check dependencies**: Does it require hooks/MCP/Claude-specific features?
3. **If adaptable**: 
   - Copy to `skills/ecc-hermes/`
   - Remove Claude Code dependencies
   - Update frontmatter
   - Test in Hermes/OpenClaw
4. **Submit PR**: Include adaptation notes in the PR description

See the [original ECC repo](https://github.com/affaan-m/ECC) for the full skill catalog.

---

**Last updated**: 2026-06-18  
**ECC version**: 2.0.0  
**Adapted by**: Hermes Agent + community
