---
name: prompt-optimizer
description: >-
  Analyze raw prompts, identify intent and gaps, match to available skills,
  and output a ready-to-paste optimized prompt. Advisory role only — never
  executes the task itself.
  TRIGGER when: user says "optimize prompt", "improve my prompt",
  "how to write a prompt for", "help me prompt", "rewrite this prompt",
  or explicitly asks to enhance prompt quality. Also triggers on Chinese
  equivalents: "优化prompt", "改进prompt", "怎么写prompt", "帮我优化这个指令".
  DO NOT TRIGGER when: user wants the task executed directly, or says
  "just do it" / "直接做".
version: 1.0.0-hermes
author: ECC Community (adapted for Hermes/OpenClaw)
tags: [prompt-engineering, optimization, analysis]
---

# Prompt Optimizer (Hermes/OpenClaw Adaptation)

Analyze a draft prompt, critique it, match it to available skills,
and output a complete optimized prompt the user can paste and run.

**Adaptation Note**: This skill is adapted from Claude Code's ECC ecosystem. We've replaced ECC-specific commands and components with Hermes/OpenClaw equivalents.

## When to Use

- User says "optimize this prompt", "improve my prompt", "rewrite this prompt"
- User says "help me write a better prompt for..."
- User says "what's the best way to ask the agent to..."
- User says "优化prompt", "改进prompt", "怎么写prompt", "帮我优化这个指令"
- User pastes a draft prompt and asks for feedback or enhancement
- User says "I don't know how to prompt for this"
- User explicitly loads this skill for prompt optimization

### Do Not Use When

- User wants the task done directly (just execute it)
- User says "优化代码", "优化性能", "optimize this code", "optimize performance" — these are refactoring tasks, not prompt optimization
- User says "just do it" or "直接做"

## How It Works

**Advisory only — do not execute the user's task.**

Do NOT write code, create files, run commands, or take any implementation
action. Your ONLY output is an analysis plus an optimized prompt.

If the user says "just do it", "直接做", or "don't optimize, just execute",
do not switch into implementation mode inside this skill. Tell the user this
skill only produces optimized prompts, and instruct them to make a normal
task request if they want execution instead.

Run this 6-phase pipeline sequentially. Present results using the Output Format below.

### Analysis Pipeline

### Phase 0: Project Detection

Before analyzing the prompt, detect the current project context:

1. Check if an `AGENTS.md`, `README.md`, or project config exists in the working directory — read it for project conventions
2. Detect tech stack from project files:
   - `package.json` → Node.js / TypeScript / React / Next.js
   - `go.mod` → Go
   - `pyproject.toml` / `requirements.txt` → Python
   - `Cargo.toml` → Rust
   - `build.gradle` / `pom.xml` → Java / Kotlin
   - `Package.swift` → Swift
   - `Gemfile` → Ruby
   - `composer.json` → PHP
   - `*.csproj` / `*.sln` → .NET
   - `Makefile` / `CMakeLists.txt` → C / C++
3. Note detected tech stack for use in Phase 3 and Phase 4

If no project files are found (e.g., the prompt is abstract or for a new project),
skip detection and flag "tech stack unknown" in Phase 4.

### Phase 1: Intent Detection

Classify the user's task into one or more categories:

| Category | Signal Words | Example |
|----------|-------------|---------|
| New Feature | build, create, add, implement, 创建, 实现, 添加 | "Build a login page" |
| Bug Fix | fix, broken, not working, error, 修复, 报错 | "Fix the auth flow" |
| Refactor | refactor, clean up, restructure, 重构, 整理 | "Refactor the API layer" |
| Research | how to, what is, explore, investigate, 怎么, 如何 | "How to add SSO" |
| Testing | test, coverage, verify, 测试, 覆盖率 | "Add tests for the cart" |
| Review | review, audit, check, 审查, 检查 | "Review my PR" |
| Documentation | document, update docs, 文档 | "Update the API docs" |
| Infrastructure | deploy, CI, docker, database, 部署, 数据库 | "Set up CI/CD pipeline" |
| Design | design, architecture, plan, 设计, 架构 | "Design the data model" |

### Phase 2: Scope Assessment

If Phase 0 detected a project, use codebase size as a signal. Otherwise, estimate
from the prompt description alone and mark the estimate as uncertain.

| Scope | Heuristic | Orchestration |
|-------|-----------|---------------|
| TRIVIAL | Single file, < 50 lines | Direct execution |
| LOW | Single component or module | Single skill or command |
| MEDIUM | Multiple components, same domain | Skill chain + verification |
| HIGH | Cross-domain, 5+ files | Plan first, then phased execution |
| EPIC | Multi-session, multi-PR, architectural shift | Use `writing-plans` skill for multi-session plan |

### Phase 3: Skill Matching

Map intent + scope + tech stack (from Phase 0) to specific Hermes/OpenClaw skills.

#### By Intent Type

| Intent | Skills to Load | Purpose |
|--------|----------------|---------|
| New Feature | `writing-plans`, `test-driven-development` | Plan architecture, TDD methodology |
| Bug Fix | `systematic-debugging`, `test-driven-development` | Debug methodology, test-first fix |
| Refactor | `simplify-code`, `requesting-code-review` | Code cleanup, review process |
| Research | `arxiv`, `paper-to-project` | Research papers, implementation |
| Testing | `test-driven-development` | TDD methodology guidance |
| Review | `requesting-code-review`, `security-review` | Code review, security audit |
| Documentation | `writing-plans` | Documentation planning |
| Infrastructure | `docker-patterns`, `deployment-patterns`, `database-migrations` | Containerization, deployment, migrations |
| Design (MEDIUM-HIGH) | `writing-plans`, `architecture-decision-records` | Planning, ADR documentation |
| Design (EPIC) | `writing-plans` | Multi-session blueprint |

#### By Tech Stack (Optional Enhancement)

If the user has language-specific skills installed, add them:

| Tech Stack | Skills to Add |
|------------|--------------|
| Python / Django | `error-handling` (Python patterns) |
| Go | `error-handling` (Go patterns) |
| TypeScript / React | `error-handling` (TS patterns) |
| PostgreSQL | `database-migrations` |
| Docker | `docker-patterns` |

### Phase 4: Missing Context Detection

Scan the prompt for missing critical information. Check each item and mark
whether Phase 0 auto-detected it or the user must supply it:

- [ ] **Tech stack** — Detected in Phase 0, or must user specify?
- [ ] **Target scope** — Files, directories, or modules mentioned?
- [ ] **Acceptance criteria** — How to know the task is done?
- [ ] **Error handling** — Edge cases and failure modes addressed?
- [ ] **Security requirements** — Auth, input validation, secrets?
- [ ] **Testing expectations** — Unit, integration, E2E?
- [ ] **Performance constraints** — Load, latency, resource limits?
- [ ] **UI/UX requirements** — Design specs, responsive, a11y? (if frontend)
- [ ] **Database changes** — Schema, migrations, indexes? (if data layer)
- [ ] **Existing patterns** — Reference files or conventions to follow?
- [ ] **Scope boundaries** — What NOT to do?

**If 3+ critical items are missing**, ask the user up to 3 clarification
questions before generating the optimized prompt. Then incorporate the
answers into the optimized prompt.

### Phase 5: Workflow & Model Recommendation

Determine where this prompt sits in the development lifecycle:

```
Research → Plan → Implement (TDD) → Review → Verify → Commit
```

For MEDIUM+ tasks, always start with `writing-plans` skill. For EPIC tasks, use it for multi-session planning.

**Model recommendation** (include in output):

| Scope | Recommended Approach | Rationale |
|-------|---------------------|-----------|
| TRIVIAL-LOW | Light model (qwen-turbo, claude-haiku) | Fast, cost-efficient for simple tasks |
| MEDIUM | Medium model (qwen3.7-plus, claude-sonnet) | Best coding model for standard work |
| HIGH | Heavy model for planning + medium for implementation | Deep reasoning for architecture |
| EPIC | Heavy model for blueprint + medium for execution | Multi-session planning requires deep reasoning |

**Multi-prompt splitting** (for HIGH/EPIC scope):

For tasks that exceed a single session, split into sequential prompts:
- Prompt 1: Research + Plan (use research skills, then `writing-plans`)
- Prompt 2-N: Implement one phase per prompt (each ends with verification)
- Final Prompt: Integration test + code review across all phases

---

## Output Format

Present your analysis in this exact structure. Respond in the same language
as the user's input.

### Section 1: Prompt Diagnosis

**Strengths:** List what the original prompt does well.

**Issues:**

| Issue | Impact | Suggested Fix |
|-------|--------|---------------|
| (problem) | (consequence) | (how to fix) |

**Needs Clarification:** Numbered list of questions the user should answer.
If Phase 0 auto-detected the answer, state it instead of asking.

### Section 2: Recommended Skills

| Type | Skill | Purpose |
|------|-------|---------|
| Planning | `writing-plans` | Plan architecture before coding |
| Methodology | `test-driven-development` | TDD methodology guidance |
| Review | `requesting-code-review` | Post-implementation review |
| Model | qwen3.7-plus | Recommended for this scope |

### Section 3: Optimized Prompt — Full Version

Present the complete optimized prompt inside a single fenced code block.
The prompt must be self-contained and ready to copy-paste. Include:
- Clear task description with context
- Tech stack (detected or specified)
- Skill loading instructions at the right workflow stages
- Acceptance criteria
- Verification steps
- Scope boundaries (what NOT to do)

For items that reference planning, write: "Load skill: writing-plans to..."

### Section 4: Optimized Prompt — Quick Version

A compact version for experienced users. Vary by intent type:

| Intent | Quick Pattern |
|--------|--------------|
| New Feature | `Load skill: writing-plans for [feature]. Load skill: test-driven-development to implement.` |
| Bug Fix | `Load skill: systematic-debugging for [bug]. Load skill: test-driven-development to fix.` |
| Refactor | `Load skill: simplify-code for [scope]. Load skill: requesting-code-review.` |
| Research | `Load skill: arxiv for [topic]. Load skill: writing-plans based on findings.` |
| Testing | `Load skill: test-driven-development for [module].` |
| Review | `Load skill: requesting-code-review. Load skill: security-review.` |
| EPIC | `Load skill: writing-plans for "[objective]". Execute phases with verification gates.` |

### Section 5: Enhancement Rationale

| Enhancement | Reason |
|-------------|--------|
| (what was added) | (why it matters) |

### Footer

> Not what you need? Tell me what to adjust, or make a normal task request
> if you want execution instead of prompt optimization.

---

## Examples

### Trigger Examples

- "Optimize this prompt"
- "Rewrite this prompt so the agent uses the right skills"
- "帮我优化这个指令"
- "How should I prompt the agent for this task?"

### Example 1: Vague Chinese Prompt (Project Detected)

**User input:**
```
帮我写一个用户登录页面
```

**Phase 0 detects:** `package.json` with Next.js 15, TypeScript, Tailwind CSS

**Optimized Prompt (Full):**
```
使用项目现有技术栈（Next.js 15 + TypeScript + Tailwind CSS）实现用户登录页面。

技术要求：
- 沿用项目现有的组件结构和路由约定
- 表单验证使用项目中已有的验证方案（检查是否已用 Zod/Yup/其他）
- 认证方式：沿用项目现有认证方案（如无，默认 JWT）
- 包含：邮箱/密码登录表单、表单验证、错误提示、加载状态、响应式布局

工作流：
1. Load skill: writing-plans 先规划组件结构和认证流程，参考现有页面的模式
2. Load skill: test-driven-development 测试先行：编写登录表单的单元测试和认证流程的集成测试
3. 实现登录页面和认证逻辑
4. Load skill: requesting-code-review 审查实现
5. 验证所有测试通过且页面正常渲染

安全要求：
- 密码不明文传输
- 防止暴力破解（rate limiting）
- XSS 防护
- CSRF token

验收标准：
- 所有测试通过，覆盖率 80%+
- 页面在移动端和桌面端正常渲染
- 登录成功跳转到 dashboard，失败显示错误信息

不要做：
- 不要实现注册页面
- 不要实现忘记密码功能
- 不要修改现有的路由结构
```

### Example 2: Moderate English Prompt

**User input:**
```
Add a REST API endpoint for user profile updates with validation
```

**Phase 0 detects:** `go.mod` with Go 1.22, Chi router

**Optimized Prompt (Full):**
```
Add a REST API endpoint for user profile updates (PATCH /api/users/:id).

Tech stack: Go 1.22 + Chi router (detected from project)

Requirements:
- PATCH /api/users/:id — partial update of user profile
- Input validation for fields: name, email, avatar_url, bio
- Auth: require valid token, users can only update own profile
- Return 200 with updated user on success
- Return 400 with validation errors on invalid input
- Return 401/403 for auth failures
- Follow existing API patterns in the codebase

Workflow:
1. Load skill: writing-plans to plan the endpoint structure, middleware chain, and validation logic
2. Load skill: test-driven-development — write table-driven tests for success, validation failure, auth failure, not-found
3. Implement following existing handler patterns
4. Load skill: requesting-code-review
5. Run full test suite, confirm no regressions

Load skill: error-handling for Go error patterns

Do not:
- Modify existing endpoints
- Change the database schema (use existing user table)
- Add new dependencies without checking existing ones first
```

### Example 3: EPIC Project

**User input:**
```
Migrate our monolith to microservices
```

**Optimized Prompt (Full):**
```
Load skill: writing-plans to plan: "Migrate monolith to microservices architecture"

Before executing, answer these questions in the plan:
1. Which domain boundaries exist in the current monolith?
2. Which service should be extracted first (lowest coupling)?
3. Communication pattern: REST APIs, gRPC, or event-driven (Kafka/RabbitMQ)?
4. Database strategy: shared DB initially or database-per-service from start?
5. Deployment target: Kubernetes, Docker Compose, or serverless?

The plan should produce phases like:
- Phase 1: Identify service boundaries and create domain map
- Phase 2: Set up infrastructure (API gateway, service mesh, CI/CD per service)
- Phase 3: Extract first service (strangler fig pattern)
- Phase 4: Verify with integration tests, then extract next service
- Phase N: Decommission monolith

Each phase = 1 PR, with verification gates between phases.

Load skill: docker-patterns for containerization guidance
Load skill: deployment-patterns for deployment strategies

Recommended: Heavy model (qwen-max, claude-opus) for planning, medium model (qwen3.7-plus, claude-sonnet) for phase execution.
```

---

## Related Skills

| Skill | When to Reference |
|-------|------------------|
| `writing-plans` | Planning phase in optimized prompts |
| `test-driven-development` | Implementation methodology |
| `systematic-debugging` | Bug fix workflows |
| `requesting-code-review` | Review phase |
| `security-review` | Security audit phase |
| `docker-patterns` | Infrastructure tasks |
| `deployment-patterns` | Deployment tasks |
| `database-migrations` | Database changes |
| `token-budget-advisor` | Token optimization recommendations |
| `cost-aware-llm-pipeline` | Cost optimization |

---

*Optimize your prompts for better agent performance.*
