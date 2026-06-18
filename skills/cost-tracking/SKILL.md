---
name: cost-tracking
description: >-
  Track and report token usage, spending, and budgets from local session databases.
  Adapted for Hermes and OpenClaw session tracking systems.
  Use when the user asks about costs, spending, usage, tokens, budgets, or cost breakdowns.
version: 1.0.0-hermes
author: ECC Community (adapted for Hermes/OpenClaw)
tags: [cost-tracking, token-usage, budget]
---

# Cost Tracking (Hermes/OpenClaw Adaptation)

Use this skill to analyze token usage and costs from local session databases.

**Adaptation Note**: This skill is adapted from Claude Code's cost-tracking system. Since Hermes and OpenClaw have different session storage mechanisms, we provide queries for both systems.

## When to Use

- The user asks "how much have I spent?", "what did this session cost?", or "what is my token usage?"
- The user mentions budgets, spending limits, overruns, or cost controls
- The user wants a cost breakdown by project, tool, session, model, or date
- The user wants to compare today against yesterday or inspect a recent trend
- The user asks for a CSV export of recent usage records

## How It Works

### Step 1: Detect Agent System

First, determine which agent system is being used:

```bash
# Check for Hermes
if [ -f ~/.hermes/state.db ]; then
  echo "Hermes detected"
  AGENT_SYSTEM="hermes"
  DB_PATH="$HOME/.hermes/state.db"
# Check for OpenClaw
elif [ -f ~/.openclaw/sessions.db ]; then
  echo "OpenClaw detected"
  AGENT_SYSTEM="openclaw"
  DB_PATH="$HOME/.openclaw/sessions.db"
else
  echo "No agent system detected"
  exit 1
fi
```

### Step 2: Verify Database

```bash
command -v sqlite3 >/dev/null && echo "sqlite3 available" || echo "sqlite3 missing"
test -f "$DB_PATH" && echo "Database found at $DB_PATH" || echo "Database not found"
```

If the database is missing, do not fabricate usage data. Tell the user that cost tracking is not configured.

### Step 3: Understand Schema

**Hermes Schema** (`~/.hermes/state.db`):

Hermes stores sessions in a `sessions` table and messages in a `messages` table. Token counts may be stored in message metadata or need to be estimated from content length.

```sql
-- Check available tables
sqlite3 ~/.hermes/state.db ".tables"

-- Check sessions table structure
sqlite3 ~/.hermes/state.db ".schema sessions"

-- Check messages table structure
sqlite3 ~/.hermes/state.db ".schema messages"
```

**OpenClaw Schema** (`~/.openclaw/sessions.db`):

OpenClaw may have a different schema. Check the actual structure:

```bash
sqlite3 ~/.openclaw/sessions.db ".schema"
```

### Step 4: Query Usage Data

#### Quick Summary (Hermes)

```bash
sqlite3 ~/.hermes/state.db "
  SELECT
    'Total sessions: ' || COUNT(*) ||
    ' | Active: ' || SUM(CASE WHEN status = 'active' THEN 1 ELSE 0 END)
  FROM sessions;
"
```

#### Session List with Message Counts

```bash
sqlite3 -header -column ~/.hermes/state.db "
  SELECT
    s.id as session_id,
    s.title,
    s.created_at,
    COUNT(m.id) as message_count,
    s.model
  FROM sessions s
  LEFT JOIN messages m ON s.id = m.session_id
  GROUP BY s.id
  ORDER BY s.created_at DESC
  LIMIT 20;
"
```

#### Token Usage Estimation

If token counts are not directly stored, estimate from message content:

```bash
sqlite3 -header -column ~/.hermes/state.db "
  SELECT
    s.id as session_id,
    s.title,
    COUNT(m.id) as messages,
    SUM(LENGTH(m.content)) as total_chars,
    ROUND(SUM(LENGTH(m.content)) / 4.0, 0) as estimated_tokens
  FROM sessions s
  LEFT JOIN messages m ON s.id = m.session_id
  GROUP BY s.id
  ORDER BY estimated_tokens DESC
  LIMIT 10;
"
```

**Note**: Token estimation uses ~4 characters per token as a rough average. Actual token counts vary by model and content type.

#### Cost Estimation

If you know your model's pricing, calculate costs:

```bash
# Example: qwen3.7-plus pricing (adjust for your model)
# Input: $0.0008 per 1K tokens
# Output: $0.002 per 1K tokens

sqlite3 -header -column ~/.hermes/state.db "
  SELECT
    s.id as session_id,
    s.title,
    s.model,
    COUNT(m.id) as messages,
    ROUND(SUM(CASE WHEN m.role = 'user' THEN LENGTH(m.content) ELSE 0 END) / 4.0 / 1000.0 * 0.0008, 4) as input_cost,
    ROUND(SUM(CASE WHEN m.role = 'assistant' THEN LENGTH(m.content) ELSE 0 END) / 4.0 / 1000.0 * 0.002, 4) as output_cost,
    ROUND(
      SUM(CASE WHEN m.role = 'user' THEN LENGTH(m.content) ELSE 0 END) / 4.0 / 1000.0 * 0.0008 +
      SUM(CASE WHEN m.role = 'assistant' THEN LENGTH(m.content) ELSE 0 END) / 4.0 / 1000.0 * 0.002,
      4
    ) as total_cost
  FROM sessions s
  LEFT JOIN messages m ON s.id = m.session_id
  GROUP BY s.id
  ORDER BY total_cost DESC
  LIMIT 10;
"
```

**Important**: Model pricing changes over time. Verify current pricing from your provider before making cost decisions.

### Step 5: Export Data

Export to CSV for further analysis:

```bash
sqlite3 -header -csv ~/.hermes/state.db "
  SELECT
    s.id as session_id,
    s.title,
    s.created_at,
    s.model,
    COUNT(m.id) as message_count,
    SUM(LENGTH(m.content)) as total_chars
  FROM sessions s
  LEFT JOIN messages m ON s.id = m.session_id
  GROUP BY s.id
  ORDER BY s.created_at DESC;
" > session_usage.csv
```

## Reporting Guidance

When presenting cost data, include:

1. **Total sessions** and message counts
2. **Estimated token usage** (if actual counts not available)
3. **Estimated costs** (with pricing source noted)
4. **Top sessions by usage** ranked by tokens or cost
5. **Recent trends** (last 7 days if data available)

For small amounts, format currency with four decimal places. For larger amounts, two decimals are enough.

## Anti-Patterns

- Do not estimate costs without noting that they are estimates
- Do not assume the database exists without checking
- Do not run unbounded `SELECT *` exports on large databases
- Do not hard-code current model pricing in user-facing answers without noting the source
- Do not fabricate usage data if the database is missing

## Advanced: Custom Tracking

If you want more accurate token tracking, you can:

1. **Use provider APIs**: Some providers offer usage APIs (e.g., OpenAI, Anthropic)
2. **Log manually**: Add a post-response hook in your workflow to log token counts
3. **Use middleware**: If running a custom gateway, log token usage at the API level

### Example: Hermes Gateway Logging

If you're running Hermes Gateway, you can add logging middleware to track actual token counts:

```python
# Example: Add to your gateway config
# Log each API call with token counts
# Store in a separate SQLite database for analysis
```

## Related

- `token-budget-advisor` - Control response depth before answering
- `cost-aware-llm-pipeline` - Model routing and budget design patterns
- `context-budget` - Audit context window consumption
- Original ECC: https://github.com/affaan-m/ECC

---

*Track your agent's token usage and optimize costs.*
