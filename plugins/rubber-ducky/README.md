# Rubber Ducky 🦆

Rubber duck debugging skill and agent for AI code agents.

Forces step-by-step code explanation before pushing any fix, catching false
assumptions and logical gaps before they reach production.

## Skills (1)

| Skill | Description |
|-------|-------------|
| `rubber-duck-debugging` | 5-phase explain-to-the-duck process: Scene → Walk → Catch → Fix → Verify |

## Agents (1)

| Agent | Description |
|-------|-------------|
| `rubber-ducky` | The rubber duck — a silent audience that forces self-explanation |

## The Method

Based on the classic technique from *The Pragmatic Programmer* (1999) and
[rubberduckdebugging.com](https://rubberduckdebugging.com/):

1. **Explain** what the code is supposed to do
2. **Walk through** the code line by line
3. **Catch** the moment where explanation ≠ reality
4. **Explain** the fix in plain English before writing it
5. **Verify** by re-walking the code path with the fix

## Usage

Skills activate automatically when debugging. You can also invoke manually:

```
Use the /rubber-duck-debugging skill to walk through this fix
Ask the @rubber-ducky agent to review my debug patch
```

## The Iron Rule

> No code gets pushed until you've explained it to the duck.

## Source

Inspired by [The Pragmatic Programmer](https://en.wikipedia.org/wiki/The_Pragmatic_Programmer)
and [rubberduckdebugging.com](https://rubberduckdebugging.com/).
