#!/usr/bin/env bash
set -euo pipefail

# Rubber Ducky for GitHub Copilot CLI — One-line installer
# Usage: curl -fsSL https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/master/install.sh | bash

REPO="BandaruDheeraj/rubber-ducky"
COPILOT_HOME="${COPILOT_HOME:-$HOME/.copilot}"
CACHE_DIR="$COPILOT_HOME/marketplace-cache/rubber-ducky"

echo "🦆 Rubber Ducky — Installer"
echo "==========================="
echo ""

# Check if git is available
if ! command -v git &> /dev/null; then
    echo "❌ Git is required but not installed."
    exit 1
fi

# Check if copilot CLI is installed
if ! command -v copilot &> /dev/null; then
    echo "⚠️  GitHub Copilot CLI not found in PATH."
    echo "   Install it first: https://github.com/github/copilot-cli"
    echo "   Continuing anyway (skill will be available when Copilot CLI is installed)..."
    echo ""
fi

# Clone or update the repo
if [ -d "$CACHE_DIR" ]; then
    echo "📦 Updating existing cache..."
    cd "$CACHE_DIR"
    git pull --quiet 2>/dev/null || {
        echo "   Cache update failed, removing and re-cloning..."
        rm -rf "$CACHE_DIR"
        git clone --quiet "https://github.com/$REPO.git" "$CACHE_DIR"
    }
else
    echo "📦 Cloning rubber-ducky..."
    mkdir -p "$(dirname "$CACHE_DIR")"
    git clone --quiet "https://github.com/$REPO.git" "$CACHE_DIR"
fi

# Link skill
SKILL_SRC="$CACHE_DIR/plugins/rubber-ducky/skills/rubber-duck-debugging"
SKILL_DST="$COPILOT_HOME/skills/rubber-duck-debugging"

mkdir -p "$COPILOT_HOME/skills"
if [ -L "$SKILL_DST" ] || [ -d "$SKILL_DST" ]; then
    rm -rf "$SKILL_DST"
fi
ln -s "$SKILL_SRC" "$SKILL_DST"
echo "✅ Skill linked: rubber-duck-debugging"

# Link agent
AGENT_SRC="$CACHE_DIR/plugins/rubber-ducky/agents/rubber-ducky.md"
AGENT_DST="$COPILOT_HOME/agents/rubber-ducky.md"

mkdir -p "$COPILOT_HOME/agents"
if [ -L "$AGENT_DST" ] || [ -f "$AGENT_DST" ]; then
    rm -f "$AGENT_DST"
fi
ln -s "$AGENT_SRC" "$AGENT_DST"
echo "✅ Agent linked: rubber-ducky"

# Add custom instructions if not already present
INSTRUCTIONS_FILE="$COPILOT_HOME/copilot-instructions.md"
MARKER="<!-- rubber-ducky-installed -->"

if [ -f "$INSTRUCTIONS_FILE" ] && grep -q "$MARKER" "$INSTRUCTIONS_FILE" 2>/dev/null; then
    echo "ℹ️  Custom instructions already configured."
else
    cat >> "$INSTRUCTIONS_FILE" << 'INSTRUCTIONS'

<!-- rubber-ducky-installed -->
## Rubber Duck Debugging 🦆

You have the rubber-duck-debugging skill installed. BEFORE pushing any debug
fix, behavioral change, or patch, invoke this skill to walk through the fix
with the rubber duck.

The Iron Rule: No code gets pushed until you've explained it to the duck.

Available: rubber-duck-debugging (skill), rubber-ducky (agent)

"Fix this bug" → rubber-duck-debugging BEFORE pushing the fix.
"Debug this" → rubber-duck-debugging to explain the code line by line.
"Why is this failing?" → rubber-duck-debugging to find where explanation ≠ reality.
INSTRUCTIONS
    echo "✅ Custom instructions updated: $INSTRUCTIONS_FILE"
fi

echo ""
echo "🦆 Rubber Ducky installed successfully!"
echo ""
echo "   Skill: rubber-duck-debugging"
echo "   Agent: rubber-ducky"
echo ""
echo "   Next steps:"
echo "   1. Start a new Copilot CLI session: copilot"
echo "   2. Verify: /skills list"
echo "   3. Try: 'Use the /rubber-duck-debugging skill to review my fix'"
echo ""
echo "   To update: run this script again"
echo "   To uninstall: rm -rf $SKILL_DST $AGENT_DST $CACHE_DIR"
echo "     and remove the rubber-ducky section from $INSTRUCTIONS_FILE"
