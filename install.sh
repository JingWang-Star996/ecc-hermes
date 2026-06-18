#!/usr/bin/env bash
# ECC-Hermes Installer
# Installs adapted ECC skills for Hermes Agent and/or OpenClaw

set -e

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SKILLS_DIR="$SCRIPT_DIR/skills"

# Colors
RED='\033[0;31m'
GREEN='\033[0;32m'
YELLOW='\033[1;33m'
BLUE='\033[0;34m'
NC='\033[0m' # No Color

# Parse arguments
INSTALL_HERMES=false
INSTALL_OPENCLAW=false

if [[ "$#" -eq 0 ]]; then
    # Auto-detect
    INSTALL_HERMES=true
    INSTALL_OPENCLAW=true
else
    for arg in "$@"; do
        case $arg in
            --hermes)
                INSTALL_HERMES=true
                ;;
            --openclaw)
                INSTALL_OPENCLAW=true
                ;;
            --help|-h)
                echo "Usage: $0 [--hermes] [--openclaw]"
                echo ""
                echo "Options:"
                echo "  --hermes    Install to Hermes Agent only"
                echo "  --openclaw  Install to OpenClaw only"
                echo "  (no args)   Auto-detect and install to both"
                echo ""
                echo "Examples:"
                echo "  $0                    # Install to both"
                echo "  $0 --hermes           # Hermes only"
                echo "  $0 --openclaw         # OpenClaw only"
                exit 0
                ;;
            *)
                echo -e "${RED}Unknown option: $arg${NC}"
                echo "Use --help for usage information"
                exit 1
                ;;
        esac
    done
fi

echo -e "${BLUE}╔════════════════════════════════════════════════╗${NC}"
echo -e "${BLUE}║     ECC Skills for Hermes & OpenClaw          ║${NC}"
echo -e "${BLUE}║     Installer v1.0.0                          ║${NC}"
echo -e "${BLUE}╚════════════════════════════════════════════════╝${NC}"
echo ""

# Count skills
SKILL_COUNT=$(find "$SKILLS_DIR" -maxdepth 1 -mindepth 1 -type d | wc -l)
echo -e "${BLUE}Found $SKILL_COUNT skills to install${NC}"
echo ""

# Detect installations
HERMES_DIR=""
OPENCLAW_DIR=""

if $INSTALL_HERMES; then
    if [[ -d "$HOME/.hermes" ]]; then
        HERMES_DIR="$HOME/.hermes/skills"
        echo -e "${GREEN}✓ Detected Hermes at $HOME/.hermes${NC}"
    else
        echo -e "${YELLOW}⚠ Hermes not found at $HOME/.hermes${NC}"
    fi
fi

if $INSTALL_OPENCLAW; then
    if [[ -d "$HOME/.openclaw" ]]; then
        OPENCLAW_DIR="$HOME/.openclaw/skills"
        echo -e "${GREEN}✓ Detected OpenClaw at $HOME/.openclaw${NC}"
    else
        echo -e "${YELLOW}⚠ OpenClaw not found at $HOME/.openclaw${NC}"
    fi
fi

# Check if anything to install
if [[ -z "$HERMES_DIR" && -z "$OPENCLAW_DIR" ]]; then
    echo ""
    echo -e "${RED}✗ No compatible agent installations found${NC}"
    echo ""
    echo "Please install Hermes or OpenClaw first:"
    echo "  Hermes:  curl -fsSL https://hermes-agent.nousresearch.com/install.sh | bash"
    echo "  OpenClaw: https://github.com/anthropics/openclaw"
    exit 1
fi

echo ""

# Install function
install_to() {
    local target_dir="$1"
    local target_name="$2"
    
    echo -e "${BLUE}Installing to $target_name...${NC}"
    
    # Create target directory
    mkdir -p "$target_dir"
    
    # Copy skills
    local count=0
    for skill_dir in "$SKILLS_DIR"/*/; do
        if [[ -d "$skill_dir" ]]; then
            skill_name=$(basename "$skill_dir")
            dest="$target_dir/$skill_name"
            
            # Remove existing if present
            if [[ -d "$dest" ]]; then
                rm -rf "$dest"
            fi
            
            # Copy
            cp -r "$skill_dir" "$dest"
            ((count++))
        fi
    done
    
    echo -e "${GREEN}✓ Installed $count skills to $target_name${NC}"
    echo ""
}

# Install to detected locations
if [[ -n "$HERMES_DIR" ]]; then
    install_to "$HERMES_DIR" "Hermes"
fi

if [[ -n "$OPENCLAW_DIR" ]]; then
    install_to "$OPENCLAW_DIR" "OpenClaw"
fi

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo -e "${GREEN}✓ Installation complete!${NC}"
echo ""
echo "Next steps:"
echo ""

if [[ -n "$HERMES_DIR" ]]; then
    echo -e "${BLUE}Hermes:${NC}"
    echo "  1. Start a new session: hermes"
    echo "  2. List skills: /skills"
    echo "  3. Use a skill: /skill agent-architecture-audit"
    echo ""
fi

if [[ -n "$OPENCLAW_DIR" ]]; then
    echo -e "${BLUE}OpenClaw:${NC}"
    echo "  1. Start a new session"
    echo "  2. Load skill: Load skill: agent-architecture-audit"
    echo ""
fi

echo -e "${BLUE}════════════════════════════════════════════════${NC}"
echo ""
echo "For more information, see:"
echo "  - README.md (English)"
echo "  - README.zh-CN.md (中文)"
echo "  - docs/ADAPTATION-NOTES.md (适配说明)"
echo ""
