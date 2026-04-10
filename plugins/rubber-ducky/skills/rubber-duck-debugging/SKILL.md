---
name: rubber-duck-debugging
description: >
  Use BEFORE pushing any code fix, debug patch, or behavioral change. Forces the agent to
  explain the code step-by-step to a rubber duck, exposing logical gaps, false assumptions,
  and misunderstandings before they reach production. Based on the classic rubber duck
  debugging method from The Pragmatic Programmer.
---

# Rubber Duck Debugging 🦆

## The Method

> "Explain your code to a rubber duck, line by line. At some point you will
> tell the duck what you are doing next and then realize that is not in fact
> what you are actually doing."
>
> — *The Pragmatic Programmer* (1999)

## The Iron Rule

```
NO CODE GETS PUSHED UNTIL YOU'VE EXPLAINED IT TO THE DUCK.
```

If you haven't completed the Explain → Walk → Catch → Verify cycle, you
cannot commit, push, or declare the task done. No exceptions.

## When to Use

**ALWAYS use this skill when:**
- Debugging any bug, test failure, or unexpected behavior
- Proposing a fix for an issue
- About to push code that changes existing behavior
- A previous fix attempt didn't work
- You're not 100% sure *why* a change fixes the problem
- The fix was found by trial-and-error rather than understanding

**Especially use when:**
- The fix seems "obvious" (obvious fixes hide assumptions)
- You're under time pressure (pressure increases error rate)
- Working in unfamiliar code (gaps in understanding = gaps in fixes)
- Multiple agents or teammates have attempted the same issue
- The bug has been reopened before

**You may skip ONLY when:**
- Change is purely cosmetic (whitespace, comments, formatting)
- Adding new code that doesn't modify existing behavior
- The change was already rubber-ducked in a prior pass this session

## The Five Quacks (Process)

### 🦆 Quack 1: Set the Scene

Before looking at the bug or code, state clearly:

1. **What is this code supposed to do?** (the intent, not the implementation)
2. **What is it actually doing instead?** (the observed behavior)
3. **How do you know?** (error message, test failure, user report, log output)

```
DUCK CHECKPOINT: Can you state the gap between intent and behavior
in one sentence? If not, you don't understand the problem yet.
```

### 🦆 Quack 2: Walk the Code Path

Trace the execution path **out loud** (in your response), line by line:

1. **Start at the entry point** — where does execution begin for this scenario?
2. **Follow every branch** — which `if/else/switch/match` path is taken and WHY?
3. **State what each variable holds** — not what you *think* it holds, what the
   code actually computes. Check types, defaults, edge cases.
4. **Cross every boundary** — function calls, API calls, async boundaries,
   module imports. Don't assume — trace.

**At each step, say TWO things:**
- "This line is *supposed to* do X"
- "This line *actually does* Y"

If X ≠ Y at any point, you've found a discrepancy. **Stop and investigate.**

```
DUCK CHECKPOINT: Did you trace every line between entry and the bug?
If you skipped a section thinking "that part's fine" — go back.
The duck doesn't allow hand-waving.
```

### 🦆 Quack 3: Catch the Discrepancy

When X ≠ Y, you've found the **quack point**. Now answer:

1. **What did you assume was true that isn't?** (the false assumption)
2. **Why did you assume that?** (naming? similar pattern? incomplete reading?)
3. **What is actually true?** (prove it — show the evidence)
4. **Is this the root cause, or a symptom of something deeper?**

```
DUCK CHECKPOINT: Can you explain the root cause to someone who has
never seen this code? If your explanation requires "it's complicated"
or "it just works that way" — you haven't found root cause yet.
```

### 🦆 Quack 4: Explain the Fix

Before writing ANY fix:

1. **State the fix in plain English** — what will change and why
2. **Explain why this fixes the root cause** — not the symptom
3. **List what else this change affects** — side effects, callers, tests,
   downstream consumers
4. **State what you are NOT changing** and why those don't need changing

```
DUCK CHECKPOINT: Could someone implement your fix from just your
English description, without seeing the code? If not, your
understanding is incomplete.
```

### 🦆 Quack 5: Verify to the Duck

After implementing the fix:

1. **Re-walk the code path** from Quack 2 with the fix applied
2. **Confirm X = Y** at every step now
3. **Run the tests** — does the failing test pass? Do other tests still pass?
4. **Check for regression** — did the fix break anything adjacent?
5. **State your confidence level**: "I am [confident/somewhat confident/uncertain]
   because [reason]"

```
DUCK CHECKPOINT: The duck asks — "Are you sure?" Walk through one
more time. If you're still confident, you may push.
```

## The Duck's Questions

When acting as the rubber duck, ask these probing questions at each phase:

| Phase | Duck asks... |
|-------|-------------|
| **Scene** | "What makes you think X is the expected behavior?" |
| **Walk** | "What happens if that value is null/empty/negative/huge?" |
| **Walk** | "You said 'this calls Y' — have you verified Y does what you think?" |
| **Catch** | "Is that the only place this assumption is made?" |
| **Catch** | "What changed between when this worked and when it broke?" |
| **Fix** | "How do you know this won't break [related feature]?" |
| **Fix** | "What's the simplest possible fix? Is yours simpler?" |
| **Verify** | "If you revert your fix, does the original bug return?" |

## Anti-Patterns (The Duck Rejects These)

| Pattern | Why the Duck says NO 🦆 |
|---------|------------------------|
| "I think the fix is..." (without Quack 1-3) | Guessing isn't debugging |
| "Let me try changing X and see if it works" | Trial-and-error isn't understanding |
| "The fix works, tests pass, shipping it" (without walkthrough) | Coincidental correctness isn't confidence |
| "It's too complex to explain line by line" | If you can't explain it, you can't fix it safely |
| "I've seen this pattern before, it's always X" | Past pattern doesn't mean present root cause |
| Fixing the symptom but not the root cause | The duck wants to know *why*, not just *what* |
| "Quick fix now, proper fix later" | Later never comes. Fix it right. |
| Pushing code you can't explain | The duck has one rule: explain or don't push |

## Integration with Other Skills

- **After `systematic-debugging`** → Use rubber-duck-debugging before pushing the fix
- **After `test-driven-development`** → Explain the test rationale to the duck
- **Before `verification-before-completion`** → Duck walkthrough is a pre-verification gate
- **With `requesting-code-review`** → Duck explanation becomes your PR description

## Output Format

When using this skill, structure your response as:

```
🦆 RUBBER DUCK SESSION
━━━━━━━━━━━━━━━━━━━━━━

📋 THE PROBLEM
  Expected: [what code should do]
  Actual:   [what code does instead]
  Evidence: [how you know]

🔍 CODE WALKTHROUGH
  [line-by-line trace with "supposed to" vs "actually does"]

💡 THE QUACK POINT
  Discrepancy: [where X ≠ Y]
  False assumption: [what was wrong]
  Root cause: [the real issue]

🔧 THE FIX
  Change: [plain English description]
  Why it works: [addresses root cause because...]
  Side effects: [what else is affected]

✅ VERIFICATION
  [Re-walked code path with fix]
  Tests: [pass/fail status]
  Confidence: [level + reason]

🦆 QUACK! (approved to push)
━━━━━━━━━━━━━━━━━━━━━━
```

## Why This Works

Rubber duck debugging exploits a cognitive phenomenon: **explaining forces
understanding**. When you explain code to an external entity (even an
inanimate duck), your brain switches from "recognition mode" (skimming,
pattern-matching, assuming) to "generation mode" (constructing, verifying,
proving). Bugs hide in the gap between what you *recognize* and what you
can *generate*.

For AI code agents specifically:
- Prevents "confident but wrong" fixes that pass tests accidentally
- Forces root cause analysis instead of symptom patching
- Creates an auditable explanation trail for every fix
- Catches false assumptions that internal reasoning misses
- Reduces fix-revert-fix cycles by getting it right the first time

## Quick Reference

| Quack | Do | Don't |
|-------|-----|-------|
| 🦆 1 | State intent vs reality clearly | Skip to proposing fixes |
| 🦆 2 | Trace every line, cross every boundary | Hand-wave through "obvious" sections |
| 🦆 3 | Identify the false assumption | Describe the symptom as the cause |
| 🦆 4 | Explain fix in plain English first | Jump straight to code changes |
| 🦆 5 | Re-walk with fix, check regressions | Trust "tests pass" without understanding |
