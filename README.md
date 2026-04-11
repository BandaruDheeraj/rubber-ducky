<p align="center">
  <img src="https://github.com/user-attachments/assets/b1866595-9a5a-42b3-bd40-073e5b656832" alt="Rubber Ducky header image" />
</p>

<p align="center">
  <strong>Explain your code to a rubber duck, line by line.</strong><br />
  <em>— The Pragmatic Programmer (1999)</em>
</p>

Rubber duck debugging skill and agent for AI code agents (GitHub Copilot CLI, Claude Code, and any tool that supports the superpowers plugin format).

**Force agents to explain their code step-by-step before pushing fixes** — catching false assumptions, logical gaps, and root cause misidentification before they reach production.

## Why

AI code agents are confidently wrong at a terrifying rate. They'll propose a
fix, tests will pass, and the fix will be completely wrong — addressing a
symptom while the root cause lurks underneath.

The rubber duck solves this by requiring **forced self-explanation**: the agent
must explain what the code does, line by line, to a silent plastic duck that
offers nothing back. The duck doesn't ask questions, give feedback, or suggest
fixes. The agent does all the talking. Bugs reveal themselves mid-explanation,
because what the agent is *about to say* contradicts what the code *actually does*.

This is how rubber duck debugging has always worked — the power is in the
explanation, not the response.

## What's Included

### Skills

| Skill | Description |
|-------|-------------|
| `rubber-duck-debugging` | 5-phase process: Scene → Walk → Catch → Fix → Verify. The core debugging method as a structured skill. |

### Agents

| Agent | Description |
|-------|-------------|
| `rubber-ducky` | The rubber duck itself — a silent audience. It doesn't ask questions, suggest fixes, or give feedback. It just sits there while the agent explains. That's the whole method. |

## Installation

**Note:** Installation differs by platform.

### GitHub Copilot CLI

Tell your agent:

```
Fetch and follow instructions from https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/master/INSTALL.md
```

Or use the one-line installer:

```bash
# macOS/Linux
curl -fsSL https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/master/install.sh | bash

# Windows (PowerShell)
irm https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/master/install.ps1 | iex
```

### Codex

Tell Codex:

```
Fetch and follow instructions from https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/master/INSTALL.md
```

### Claude Code

```bash
/plugin install rubber-ducky@BandaruDheeraj/rubber-ducky
```

### Any Other Agent

Tell your agent:

```
Fetch and follow instructions from https://raw.githubusercontent.com/BandaruDheeraj/rubber-ducky/master/INSTALL.md
```

**Detailed docs:** [INSTALL.md](INSTALL.md)

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

Every rubber duck session produces a structured report — the agent's own
explanation to the silent duck:

```
🦆 RUBBER DUCK SESSION
━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━

📋 THE PROBLEM (Quack 1)
  "Duck, here's what's going on..."
  Expected: user token refreshes silently
  Actual:   401 on every refresh attempt
  Evidence: test_token_refresh fails, logs show expired comparison

🔍 CODE WALKTHROUGH (Quack 2)
  "Let me walk you through this, line by line..."
  Line 42: getToken() returns encoded JWT string ✓
  Line 43: isExpired(token) compares token.exp... ← WAIT
           token is still encoded here. token.exp is undefined.
           isExpired returns true for every token.

💡 THE QUACK POINT (Quack 3)
  "Wait — I just said token.exp but... it's still encoded."
  Discrepancy: isExpired() receives encoded string, expects decoded object
  False assumption: getToken() returns decoded token
  Root cause: missing decode step between get and validate

🔧 THE FIX (Quack 4)
  "Here's what I'm going to change, duck..."
  Change: Add jwt.decode(token) before passing to isExpired()
  Why: isExpired needs the decoded payload to read .exp field
  Side effects: None — decode is read-only, callers receive same token
  Not changing: getToken() itself — it correctly returns raw JWT

✅ VERIFICATION (Quack 5)
  "Let me walk through it again with the fix..."
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

Rubber duck debugging exploits a cognitive phenomenon: **self-explanation to a
silent audience forces understanding**. When you explain code to something that
offers nothing back, your brain switches from "recognition mode" (skimming,
assuming) to "generation mode" (constructing, verifying, proving). Bugs hide in
the gap between recognition and generation.

The duck's silence is the feature, not a limitation:

| Mechanism | Why silence works |
|-----------|------------------|
| **Self-explanation effect** | YOU generate the insight, not the listener |
| **Cognitive offloading** | Externalizing logic frees working memory |
| **Psychological distance** | Addressing an "other" activates analytical mode |
| **No interruption** | The duck can't derail your train of thought |
| **No premature answers** | A human would guess; the duck makes you finish thinking |

## References

- [The Pragmatic Programmer](https://en.wikipedia.org/wiki/The_Pragmatic_Programmer) — Hunt & Thomas, 1999
- [rubberduckdebugging.com](https://rubberduckdebugging.com/) — The canonical reference
- [Rubber duck debugging (Wikipedia)](https://en.wikipedia.org/wiki/Rubber_duck_debugging)
- [Rubber Duck Problem Solving (Coding Horror)](https://blog.codinghorror.com/rubber-duck-problem-solving/)

## License

MIT — see [LICENSE](LICENSE)
