---
name: agent-self-evaluation
description: "Self-rate output on 5 axes (accuracy, completeness, clarity, actionability, conciseness) with concrete evidence per criterion."
version: 1.0.0
author: "ECC (adapted for Hermes)"
---

# Agent Self-Evaluation

After completing a complex task, pause to rate your own output against a structured 5-axis rubric. This catches omissions, flags overconfidence, and surfaces areas for improvement.

## When to Activate

- After writing code that spans 3+ files or 50+ lines
- After completing a multi-step workflow
- After a debugging session that involved 3+ attempts
- After producing a design document or written analysis

## The 5 Evaluation Axes

| Axis | Question | What it catches |
|---|---|---|
| **Accuracy** | Are the facts, claims, and outputs correct? | Hallucinations, wrong API names, incorrect syntax |
| **Completeness** | Did it cover everything the user asked for? | Missed edge cases, unhandled error paths |
| **Clarity** | Is the explanation understandable and well-structured? | Confusing explanations, jargon without definition |
| **Actionability** | Can the user act on the output immediately? | Vague suggestions, missing steps |
| **Conciseness** | Did it use the minimum words/tokens needed? | Redundancy, over-explanation, filler content |

### Scoring Scale

```
5 — Exceptional: no reasonable improvement possible
4 — Good: minor nits only, no substantive gaps
3 — Adequate: meets the request but has a notable weakness
2 — Weak: has a clear gap that affects usability or correctness
1 — Poor: fundamentally misses the request or contains significant errors
```

### The Evidence Rule

Every score below 5 MUST cite specific evidence. "Show the gap, don't just name it."

## Workflow

### Step 1: Collect the Raw Material
- The original user request
- Your final response/output
- Any tool outputs that verify correctness
- Any user feedback received during the task

### Step 2: Score Each Axis Independently
Work through the 5 axes one at a time. Score each axis fresh.

### Step 3: Produce the Evaluation Report
```
- One-line summary
- 5-axis scorecard (score + evidence per axis)
- Overall score (simple average, rounded to 1 decimal)
- 1-3 specific improvements ranked by impact
```

### Step 4: Apply the Improvement
If any axis scored 3 or below, state what you would do differently and fix it if possible.

## Anti-Patterns

- "Everything is a 5" — no evidence cited, self-congratulation
- Over-penalizing for scope creep — only evaluate against what was requested
- Mixing personal preference with objective gaps
