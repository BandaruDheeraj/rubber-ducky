# 🦆 Rubber Ducky

> **"Explain your code to a rubber duck, line by line."**
> — *The Pragmatic Programmer* (1999)

Rubber duck debugging skill and agent for AI code agents (GitHub Copilot CLI,
Claude Code, and any tool that supports the superpowers plugin format).

**Forces agents to explain their code step-by-step before pushing fixes** —
catching false assumptions, logical gaps, and root cause misidentification
before they reach production.

## Why

AI code agents are confidently wrong at a terrifying rate. They'll propose a
fix, tests will pass, and the fix will be completely wrong — addressing a
symptom while the root cause lurks underneath.

The rubber duck solves this by requiring **forced articulation**: the agent
must explain what the code does, line by line, to an impartial duck. Bugs
hide in the gap between what you *think* the code does and what it *actually*
does. The duck finds that gap.

## What's Included

### Skills

| Skill | Description |
|-------|-------------|
| `rubber-duck-debugging` | 5-phase process: Scene → Walk → Catch → Fix → Verify. The core debugging method as a structured skill. |

### Agents

| Agent | Description |
|-------|-------------|
| `rubber-ducky` | The rubber duck itself. Asks probing questions, rejects hand-waving, and doesn't approve pushing until the developer can fully explain their fix. |

## Installation

### GitHub Copilot CLI

```bash
# One-line install (macOS/Linux)
curl -fsSL https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/main/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/main/install.ps1 | iex
```

Or install manually:

```bash
# Clone
git clone https://github.com/BandaruDheeraj/rubber-ducky.git ~/.copilot/marketplace-cache/rubber-ducky

# Symlink skills
mkdir -p ~/.copilot/skills
ln -s ~/.copilot/marketplace-cache/rubber-ducky/plugins/rubber-ducky/skills/rubber-duck-debugging ~/.copilot/skills/rubber-duck-debugging

# Symlink agent
mkdir -p ~/.copilot/agents
ln -s ~/.copilot/marketplace-cache/rubber-ducky/plugins/rubber-ducky/agents/rubber-ducky.md ~/.copilot/agents/rubber-ducky.md
```

### Claude Code

```bash
# From your project directory
claude plugin add BandaruDheeraj/rubber-ducky
```

### Sticky Note Environment

Copy the skill into your team's shared environment:

```bash
cp plugins/rubber-ducky/skills/rubber-duck-debugging/SKILL.md .sticky-note/environment/skills/rubber-duck-debugging.md
cp plugins/rubber-ducky/agents/rubber-ducky.md .sticky-note/environment/agents/rubber-ducky.md
```

## Usage

### Automatic

The skill activates automatically when the agent detects debugging activity:
fixing bugs, investigating test failures, or patching unexpected behavior.

### Manual

```
Use the /rubber-duck-debugging skill to walk through this fix before I push
Ask the @rubber-ducky agent to review my debug patch
```

### The Five Quacks

| Phase | What happens |
|-------|-------------|
| 🦆 **Quack 1: Scene** | State what the code should do vs. what it does |
| 🦆 **Quack 2: Walk** | Trace execution line-by-line, "supposed to" vs "actually does" |
| 🦆 **Quack 3: Catch** | Find where explanation ≠ reality (the quack point) |
| 🦆 **Quack 4: Fix** | Explain the fix in plain English before writing code |
| 🦆 **Quack 5: Verify** | Re-walk the code path with the fix, run tests, confirm |

### Output

Every rubber duck session produces a structured report:

```
🦆 RUBBER DUCK SESSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 THE PROBLEM
  Expected: user token refreshes silently
  Actual:   401 on every refresh attempt
  Evidence: test_token_refresh fails, logs show expired comparison

🔍 CODE WALKTHROUGH
  Line 42: getToken() returns encoded JWT string ✓
  Line 43: isExpired(token) compares token.exp... ← WAIT
           token is still encoded here. token.exp is undefined.
           isExpired returns true for every token.

💡 THE QUACK POINT
  Discrepancy: isExpired() receives encoded string, expects decoded object
  False assumption: getToken() returns decoded token
  Root cause: missing decode step between get and validate

🔧 THE FIX
  Change: Add jwt.decode(token) before passing to isExpired()
  Why: isExpired needs the decoded payload to read .exp field
  Side effects: None — decode is read-only, callers receive same token

✅ VERIFICATION
  Re-walked: getToken() → decode() → isExpired(decoded) → .exp exists ✓
  Tests: test_token_refresh passes, all 47 auth tests pass
  Confidence: 🦆🦆🦆🦆🦆 — root cause identified and verified

🦆 QUACK! Approved to push.
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━
```

## The Iron Rule

```
NO CODE GETS PUSHED UNTIL YOU'VE EXPLAINED IT TO THE DUCK.
```

## Works With

- **[obra/superpowers](https://github.com/obra/superpowers)** — Use after `systematic-debugging`, before `verification-before-completion`
- **[sticky-note](https://github.com/BandaruDheeraj/sticky-note)** — Integrates as a shared team skill via the environment system
- **Any AI coding agent** that supports markdown skill/agent definitions

## The Science

Rubber duck debugging exploits a cognitive phenomenon: **explaining forces
understanding**. When you explain code to an external entity, your brain
switches from "recognition mode" (skimming, assuming) to "generation mode"
(constructing, verifying, proving). Bugs hide in the gap between recognition
and generation.

For AI agents, this translates to: forcing step-by-step articulation catches
the "confidently wrong" failure mode where an agent proposes a plausible fix
that doesn't address the actual root cause.

## References

- [The Pragmatic Programmer](https://en.wikipedia.org/wiki/The_Pragmatic_Programmer) — Hunt & Thomas, 1999
- [rubberduckdebugging.com](https://rubberduckdebugging.com/) — The canonical reference
- [Rubber duck debugging (Wikipedia)](https://en.wikipedia.org/wiki/Rubber_duck_debugging)
- [Rubber Duck Problem Solving (Coding Horror)](https://blog.codinghorror.com/rubber-duck-problem-solving/)

## License

MIT — see [LICENSE](LICENSE)
