#!/usr/bin/env bash
# ECC-Hermes Uninstaller
# Removes installed ECC skills from Hermes Agent and/or OpenClaw

set -e

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m'

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     ECC Skills Uninstaller                    ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# List of skills to remove
SKILLS=(
    "agent-architecture-audit"
    "agent-eval"
    "agent-harness-construction"
    "agentic-engineering"
    "agent-introspection-debugging"
    "agent-self-evaluation"
    "api-connector-builder"
    "api-design"
    "architecture-decision-records"
    "benchmark-optimization-loop"
    "context-budget"
    "continuous-agent-loop"
    "cost-aware-llm-pipeline"
    "database-migrations"
    "deployment-patterns"
    "docker-patterns"
    "error-handling"
    "security-bounty-hunter"
    "security-review"
    "token-budget-advisor"
    "ecc-hermes-guide"
)

# Remove from Hermes
if [[ -d "$HOME/.hermes/skills" ]]; then
    echo -e "${BLUE}Removing from Hermes...${NC}"
    for skill in "${SKILLS[@]}"; do
        if [[ -d "$HOME/.hermes/skills/$skill" ]]; then
            rm -rf "$HOME/.hermes/skills/$skill"
            echo -e "  ${GREEN}✓${NC} Removed $skill"
        fi
    done
    echo ""
fi

# Remove from OpenClaw
if [[ -d "$HOME/.openclaw/skills" ]]; then
    echo -e "${BLUE}Removing from OpenClaw...${NC}"
    for skill in "${SKILLS[@]}"; do
        if [[ -d "$HOME/.openclaw/skills/$skill" ]]; then
            rm -rf "$HOME/.openclaw/skills/$skill"
            echo -e "  ${GREEN}✓${NC} Removed $skill"
        fi
    done
    echo ""
fi

echo -e "${GREEN}✓ Uninstall complete${NC}"
echo ""
echo "Note: The ecc-hermes repository is still at $(pwd)"
echo "To remove it: rm -rf $(pwd)"
echo ""
