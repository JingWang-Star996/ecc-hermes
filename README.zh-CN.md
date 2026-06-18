# ECC for Hermes & OpenClaw

> ECC skills 适配版 — 支持 [Hermes Agent](https://github.com/NousResearch/hermes-agent) 和 [OpenClaw](https://github.com/anthropics/openclaw)

## 这是什么？

[ECC (Everything Claude Code)](https://github.com/affaan-m/ECC) 是一个 217K+ stars 的 AI 编程 Agent 优化系统，包含 skills、hooks、最佳实践等。但 ECC 原生不支持 Hermes 和 OpenClaw。

本项目从 ECC 中适配了 **23 个通用 skills**，供 Hermes 和 OpenClaw 用户使用：
- ✅ 移除 Claude Code 专属依赖（hooks、CLAUDE.md、/commands）
- ✅ 保留核心方法论和最佳实践
- ✅ 格式符合 Hermes/OpenClaw skill 规范

## 快速安装

```bash
# 克隆并安装
git clone https://github.com/JingWang-Star996/ecc-hermes.git
cd ecc-hermes
./install.sh
```

安装脚本会自动检测 Hermes 和/或 OpenClaw，并安装到正确位置。

### 安装选项

```bash
# 只安装到 Hermes
./install.sh --hermes

# 只安装到 OpenClaw
./install.sh --openclaw

# 安装到两者（默认）
./install.sh

# 卸载
./uninstall.sh
```

## Skills 概览

### Agent 架构（5 个 skills）

| Skill | 用途 |
|-------|------|
| `agent-architecture-audit` | Agent 系统 12 层诊断 |
| `agent-introspection-debugging` | 4 阶段自我调试工作流 |
| `agent-self-evaluation` | 5 维度输出评估（准确性、完整性、清晰度、可操作性、简洁性） |
| `agent-harness-construction` | 设计 Agent 动作空间和工具定义 |
| `agentic-engineering` | 评估优先的工程方法论 |

### 评估与基准（4 个 skills）

| Skill | 用途 |
|-------|------|
| `agent-eval` | 编码 Agent 对比评测 |
| `benchmark-optimization-loop` | 有界测量优化循环 |
| `context-budget` | 上下文窗口消耗审计 |
| `token-budget-advisor` | 响应前控制深度级别 |

### 持续运营（5 个 skills）

| Skill | 用途 |
|-------|------|
| `continuous-agent-loop` | 自主 Agent 循环模式 |
| `cost-aware-llm-pipeline` | LLM API 成本优化 |
| `continuous-learning-v2` | 基于 instinct 的学习系统，带置信度评分 |
| `cost-tracking` | 追踪 token 使用、支出和预算 |
| `prompt-optimizer` | 分析和优化 prompts 以获得更好性能 |

### 软件工程（7 个 skills）

| Skill | 用途 |
|-------|------|
| `api-connector-builder` | 按现有模式构建 API 连接器 |
| `api-design` | REST API 设计模式 |
| `architecture-decision-records` | 架构决策记录（ADR） |
| `database-migrations` | 数据库迁移和零停机部署 |
| `deployment-patterns` | CI/CD 流水线和生产就绪检查 |
| `docker-patterns` | Docker 和 Compose 模式 |
| `error-handling` | TS/Python/Go 错误处理模式 |

### 安全（2 个 skills）

| Skill | 用途 |
|-------|------|
| `security-review` | 安全检查清单和模式 |
| `security-bounty-hunter` | 漏洞赏金猎人 |

## 未适配的 Skills

**11 个 skills 被拒绝**，原因：
- 🔴 依赖 Claude Code hooks 系统（6 个）：`autonomous-loops`、`autonomous-agent-harness` 等
- 🟡 依赖特定 MCP 工具（3 个）：`deep-research`（firecrawl/exa）、`design-system`
- 🟡 领域不匹配（2 个）：`benchmark-methodology`、`agent-sort`

详见 [docs/ADAPTATION-NOTES.md](docs/ADAPTATION-NOTES.md)

## 使用方法

安装后，skills 在 Agent 中可用：

**Hermes**:
```
/skill agent-architecture-audit
```

**OpenClaw**:
```
Load skill: agent-architecture-audit
```

### 使用指南

完整的 skill 使用指南已安装为 `ecc-hermes-guide`，包含：
- 每个 skill 的详细说明
- 适配注意事项
- 使用示例

## 适配细节

### 移除的内容

| 原始内容 | 适配后 |
|---------|--------|
| `CLAUDE.md` 引用 | "项目上下文" 或 "当前会话上下文" |
| `/command` 命令 | 移除或改为工作流步骤 |
| PreToolUse/PostToolUse hooks | 移除（Hermes/OpenClaw 无此机制） |
| `claude -p` | 泛化为 "non-interactive agent run" |
| Claude 专属模型名 | 通用层级（light/medium/heavy） |

### 保留的内容

- ✅ 核心方法论和最佳实践
- ✅ 检查清单和验证流程
- ✅ 架构模式和设计原则
- ✅ 安全审查和错误处理模式

## 贡献

欢迎贡献！改进方向：
- 适配更多 ECC skills
- 添加 Hermes/OpenClaw 专属增强
- 翻译文档
- 添加使用示例

### 开发流程

```bash
# 1. Fork 并克隆
git clone https://github.com/JingWang-Star996/ecc-hermes.git
cd ecc-hermes

# 2. 创建分支
git checkout -b feature/add-new-skill

# 3. 添加 skill
cp -r /path/to/skill skills/ecc-hermes/
# 适配格式（移除 Claude Code 依赖）

# 4. 测试
./install.sh --hermes
# 在 Hermes 中验证 skill 可用

# 5. 提交
git add .
git commit -m "feat: add new-skill-name"
git push origin feature/add-new-skill
```

## 许可证

MIT — 与原始 ECC 项目一致。

## 致谢

- 原始 ECC: [affaan-m/ECC](https://github.com/affaan-m/ECC) (217K+ stars)
- Hermes Agent: [NousResearch/hermes-agent](https://github.com/NousResearch/hermes-agent)
- OpenClaw: [anthropics/openclaw](https://github.com/anthropics/openclaw)

## 相关链接

- [ECC 原始项目](https://github.com/affaan-m/ECC)
- [Hermes Agent 文档](https://hermes-agent.nousresearch.com/docs/)
- [OpenClaw 文档](https://github.com/anthropics/openclaw)

---

**为 Hermes & OpenClaw 社区制作 ❤️**
